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
	
	assign Stall = memstall | (state != 4'b0000 & !Done);
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
                          .tag_in               (Addr[15:11]),
                          .index                (Addr[10:3]),
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
			
			16'b0000_X_X_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Don't know if needed, 1 cycle hit
			16'b0000_1_0_X_X_X_XXXX_XX_X : begin ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Write
			16'b0000_0_1_X_X_X_XXXX_XX_X : begin ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0001; end //Read
			16'b0000_X_X_X_X_X_XXXX_XX_X : begin nxtstate = 4'b0000; end //No Request (00 or 11)
			
			16'b0001_X_X_1_1_X_XXXX_XX_X : begin Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Hit
			16'b0001_X_X_X_1_1_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b0; coffset = 2'b00; mwrite = 1'b1; moffset = 2'b00; mover = 1'b1; nxtstate = 4'b0111; end //Dirty 0
			16'b0001_X_X_X_X_X_XXXX_XX_X : begin mread = 1'b1; moffset = 2'b00; nxtstate = 4'b0010; end //Miss
			
			16'b0010_X_X_X_X_X_XXXX_XX_X : begin mread = 1'b1; moffset = 2'b01; nxtstate = 4'b0011; end //Start Read 1
			
			16'b0011_1_0_X_X_X_XXXX_00_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b10; coffset = 2'b00; cdata = 1'b0; nxtstate = 4'b0100; end //Start Read 2 / Write Cache 0 w/ override
			16'b0011_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b10; coffset = 2'b00; cdata = 1'b1; nxtstate = 4'b0100; end //Start Read 2 / Write Cahce 0
			
			16'b0100_1_0_X_X_X_XXXX_01_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b11; coffset = 2'b01; cdata = 1'b0; nxtstate = 4'b0101; end //Start Read 3 / Write Cache 1 w/ override
			16'b0100_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b11; coffset = 2'b01; cdata = 1'b1; nxtstate = 4'b0101; end //Start Read 3 / Write Cache 1 w/ override
			
			16'b0101_1_0_X_X_X_XXXX_10_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b10; cdata = 1'b0; nxtstate = 4'b0110; end //Cache 2 w/ override
			16'b0101_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b10; cdata = 1'b1; nxtstate = 4'b0110; end //Cache 2		
		
			16'b0110_1_0_X_X_X_XXXX_11_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b11; cdata = 1'b0; nxtstate = 4'b0111; end //Cache 3 w/ override
			16'b0110_X_X_X_X_X_XXXX_XX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b11; cdata = 1'b1; nxtstate = 4'b0111; end //Cache 3
		
			16'b0111_1_0_X_X_X_XXXX_XX_X : begin Done = 1'b1; ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Write on Done
			16'b0111_0_1_X_X_X_XXXX_XX_X : begin Done = 1'b1; ccomp = 1'b0; cwrite = 1'b0; nxtstate = 4'b0001; end //Read on Done
			16'b0111_X_X_X_X_X_XXXX_XX_X : begin Done = 1'b1; ccomp = 1'b0; cwrite = 1'b0; nxtstate = 4'b0000; end //Done
			
			16'b1000_X_X_X_X_X_1000_XX_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b01; nxtstate = 4'b1000; end //Dirty 1
			16'b1000_X_X_X_X_X_1000_XX_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b10; nxtstate = 4'b1000; end //Dirty 2
			16'b1000_X_X_X_X_X_1000_XX_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b11; nxtstate = 4'b1000; end //Dirty 3
			16'b1000_X_X_X_X_X_1000_XX_X : begin mread = 1'b1; moffset = 2'b00; nxtstate = 4'b0010; end //Read 0
		endcase
	end
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
