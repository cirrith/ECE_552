module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
	input [15:0] Addr;
	input [15:0] DataIn;
	input        Rd;
	input        Wr;
	input        createdump;
	input        clk;
	input        rst;
   
	output [15:0] DataOut;
	output reg Done;
	output Stall;
	output reg CacheHit;
	output err;

	wire [15:0] memout;
	wire [15:0] cData;
	wire [15:0] mData;
	
	wire [15:0] mAddr;
	
	wire [3:0] busy;
	
	wire [4:0] tag_out;
	
	wire [3:0] state;
	
	wire memstall;
	
	wire [2:0] cacheOffset;
	
	wire hit;
	wire dirty;
	wire valid;
	
	wire enable;
	
	wire awrite; //Access Write
	
	wire cerr;
	wire merr;
	
	wire [4:0] tag_in;
	wire [7:0] index;
	
	reg mwrite;
	reg mread;
	reg [1:0] moffset;
	reg [1:0] coffset;
	reg mover;
	reg ccomp;
	reg cwrite;
	reg cdata;	
	
	reg valid_in;

	reg error;
	reg [3:0] nxtstate;
   
	dff State [3:0] (.q(state), .d(nxtstate), .clk(clk), .rst(rst));

	assign cData = cdata ? memout : DataIn;
	assign mAddr = mover ? {tag_out, Addr[10:3], moffset, 1'b0} : {Addr[15:3], moffset, 1'b0};
	assign mData = DataOut;
	
	assign cacheOffset = awrite ? {coffset, 1'b0} : mwrite ? {moffset, 1'b0} : Addr[2:0]; //Check conditions
	
	assign enable = 1'b1;
	assign err = error | merr | cerr;
	assign awrite = !ccomp & cwrite;
	
	assign Stall = memstall | Wr | Rd;
	
	assign tag_in = Addr[15:11];
	assign index = Addr[10:3];
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (DataOut),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cerr),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (cacheOffset),
                          .data_in              (cData),
                          .comp                 (ccomp),
                          .write                (cwrite),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (memout),
                     .stall             (memstall),
                     .busy              (busy),
                     .err               (merr),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mAddr),
                     .data_in           (mData),
                     .wr                (mwrite),
                     .rd                (mread));

	always @ (*) begin
		mwrite = 1'b0;
		mread = 1'b0;
		moffset = 2'b00;
		coffset = 2'b00;
		mover = 1'b0;
		ccomp = 1'b0;
		cwrite = 1'b0;
		cdata = 1'b0;
		
		valid_in = 1'b0;
		
		Done = 1'b0;
		CacheHit = 1'b0;
		
		error = 1'b0;
		nxtstate = 4'b0000;
		
		casex({state, Wr, Rd, hit, valid, dirty, busy, Addr[2:1], Addr[0]})		
			16'bXXXX_X_X_X_X_X_XXXX_XX_1 : begin error = 1'b1; nxtstate = 4'b0000; end //Error
			
			//16'b0000_1_0_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Write, in cycle
			//16'b0000_0_1_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Read, in cycle
			16'b0000_1_0_X_X_X_XXXX_XX_X : begin ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Write
			16'b0000_0_1_X_X_X_XXXX_XX_X : begin ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0001; end //Read
			16'b0000_X_X_X_X_X_XXXX_XX_X : begin nxtstate = 4'b0000; end //No Request (00 or 11)
			
			16'b0001_1_0_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Hit Repeat Write
			16'b0001_0_1_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0001; end //Hit Repeat Read
			16'b0001_X_X_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Hit
			16'b0001_X_X_X_1_1_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b0; coffset = 2'b00; mwrite = 1'b1; moffset = 2'b00; mover = 1'b1; nxtstate = 4'b1001; end //Dirty 0
			16'b0001_X_X_X_X_X_XXXX_XX_X : begin mread = 1'b1; moffset = 2'b00; nxtstate = 4'b0010; end //Miss
			
			16'b0010_X_X_X_X_X_XXXX_XX_X : begin mread = 1'b1; moffset = 2'b01; nxtstate = 4'b0011; end //Start Read 1
			
			16'b0011_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b10; coffset = 2'b00; cdata = 1'b1; nxtstate = 4'b0100; end //Start Read 2 / Write Cahce 0
			
			16'b0100_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b11; coffset = 2'b01; cdata = 1'b1; nxtstate = 4'b0101; end //Start Read 3 / Write Cache 1
			
			16'b0101_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b10; cdata = 1'b1; nxtstate = 4'b0110; end //Cache 2		
			
			16'b0110_1_0_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b11; cdata = 1'b1; nxtstate = 4'b0111; end //Cache 3 Write
			16'b0110_0_1_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b11; cdata = 1'b1; nxtstate = 4'b1000; end //Cache 3 Read
			
			16'b0111_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b1000; end //Dirty Write
			
			16'b1000_1_0_X_X_X_XXXX_XX_X : begin Done = 1'b1; ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Write on Done
			16'b1000_0_1_X_X_X_XXXX_XX_X : begin Done = 1'b1; ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0001; end //Read on Done
			16'b1000_X_X_X_X_X_XXXX_XX_X : begin Done = 1'b1; ccomp = 1'b0; cwrite = 1'b0; nxtstate = 4'b0000; end //Done
			
			16'b1001_X_X_X_X_X_1110_XX_X : begin mread = 1'b1; moffset = 2'b00; nxtstate = 4'b0010; end //Read 0
			16'b1001_X_X_X_X_X_X111_XX_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b11; nxtstate = 4'b1001; end //Dirty 3
			16'b1001_X_X_X_X_X_0X11_XX_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b10; nxtstate = 4'b1001; end //Dirty 2
			16'b1001_X_X_X_X_X_00X1_XX_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b01; nxtstate = 4'b1001; end //Dirty 1
		endcase
	end
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
