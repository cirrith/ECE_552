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
	
	wire [3:0] state;
	wire victimway;

	wire [4:0] tag_out0;
	wire [15:0] data_out0;
	wire hit0;
	wire dirty0;
	wire valid0;
	wire err0;
	wire enable0;
	wire [4:0] tag_in0;
	wire [7:0] index0;
	wire [2:0] offset0;
	wire [15:0] data_in0;
	wire ccomp0;
	wire cwrite0;
	wire valid_in0;

	wire [4:0] tag_out1;
	wire [15:0] data_out1;
	wire hit1;
	wire dirty1;
	wire valid1;
	wire err1;
	wire enable1;
	wire [4:0] tag_in1;
	wire [7:0] index1;
	wire [2:0] offset1;
	wire [15:0] data_in1;
	wire ccomp1;
	wire cwrite1;
	wire valid_in1;
	
	wire awrite; //Access Write
	wire hit;
	wire valid;
	wire dirty;
	
	wire [4:0] mTag;
	wire [15:0] mAddr;
	wire merr;
	wire mstall;
	wire [3:0] busy;
	wire [15:0] memout;
	wire [15:0] mData;
	
	wire fullHit;
	
	wire victim;
	
	reg flip;
	
	reg mwrite;
	reg mread;
	
	reg [1:0] moffset;
	reg [1:0] coffset;
	
	reg mover;
	reg ccomp;
	reg cwrite;
	reg cdata;	
	
	reg valid_in;
	
	reg victimnxt; 
	reg error;
	reg [3:0] nxtstate;
	
	assign hit = victim ? hit1 : hit0;
	assign valid = victim ? valid1 : valid0;
	assign dirty = victim ? dirty1 : dirty0;
	
	assign err = error | merr | err0 | err1;
	assign awrite = !ccomp & cwrite;
	
	assign Stall = mstall | state != 4'b0000;
	
	assign enable0 = 1'b1;
	assign enable1 = 1'b1;
	
	assign offset0 = awrite ? {coffset, 1'b0} : mwrite ? {moffset, 1'b0} : Addr[2:0]; //Check conditions
	assign offset1 = awrite ? {coffset, 1'b0} : mwrite ? {moffset, 1'b0} : Addr[2:0]; //Check conditions
	
	assign ccomp0 = flip ? ccomp : !victim ? ccomp : 1'b0;
	assign ccomp1 = flip ? ccomp : victim ? ccomp : 1'b0;
	
	assign cwrite0 = flip ? cwrite : !victim ? cwrite : 1'b0;
	assign cwrite1 = flip ? cwrite : victim ? cwrite : 1'b0;
	
	assign data_in0 = cdata ? memout : DataIn;
	assign data_in1 = cdata ? memout : DataIn;	

	assign valid_in0 = !victim ? valid_in : 1'b0;
	assign valid_in1 = victim ? valid_in : 1'b0; 

	assign tag_in0 = Addr[15:11];
	assign tag_in1 = Addr[15:11];
	
	assign index0 = Addr[10:3];
	assign index1 = Addr[10:3];

	assign mData = victim ? data_out1 : data_out0;
	assign mTag = victim ? tag_out1 : tag_out0;
	assign mAddr = mover ? {mTag, Addr[10:3], moffset, 1'b0} : {Addr[15:3], moffset, 1'b0};
	
	assign fullHit = (hit0 & valid0) | (hit1 & valid1);
	
	assign DataOut = victim ? data_out1 : data_out0;
	
	always @ (*) begin
		casex({state, flip, hit0, hit1, valid0, valid1})

			9'b0000_1_1_X_1_X : begin victimnxt = 1'b0; end //Hit0
			9'b0000_1_X_1_X_1 : begin victimnxt = 1'b1; end //Hit1		
			9'b0000_1_X_X_0_0 : begin victimnxt = 1'b0; end //Neither valid
			9'b0000_1_X_X_0_1 : begin victimnxt = 1'b0; end //Cache0 not valid
			9'b0000_1_X_X_1_0 : begin victimnxt = 1'b1; end //Cache1 not valid
			9'b0000_1_X_X_1_1 : begin victimnxt = victimway; end //Eviction
			
			9'b0001_1_1_X_1_X : begin victimnxt = 1'b0; end //Hit0
			9'b0001_1_X_1_X_1 : begin victimnxt = 1'b1; end //Hit1	
			9'b0001_1_X_X_0_0 : begin victimnxt = 1'b0; end //Neither valid
			9'b0001_1_X_X_0_1 : begin victimnxt = 1'b0; end //Cache0 not valid
			9'b0001_1_X_X_1_0 : begin victimnxt = 1'b1; end //Cache1 not valid
			9'b0001_1_X_X_1_1 : begin victimnxt = victimway; end //Eviction
			
			9'b1000_1_1_X_1_X : begin victimnxt = 1'b0; end //Hit0
			9'b1000_1_X_1_X_1 : begin victimnxt = 1'b1; end //Hit1				
			9'b1000_1_X_X_0_0 : begin victimnxt = 1'b0; end //Neither valid
			9'b1000_1_X_X_0_1 : begin victimnxt = 1'b0; end //Cache0 not valid
			9'b1000_1_X_X_1_0 : begin victimnxt = 1'b1; end //Cache1 not valid
			9'b1000_1_X_X_1_1 : begin victimnxt = victimway; end //Eviction
			
			7'bXXXX_X_X_X : begin victimnxt = victim; end
		endcase
	end
	
	dff Victim (.q(victim), .d(victimnxt), .clk(clk), .rst(rst));
	
	dff Victimway (.q(victimway), .d(flip ? ~victimway : victimway), .clk(clk), .rst(rst));
	
	dff State [3:0] (.q(state), .d(nxtstate), .clk(clk), .rst(rst));
	
	parameter mem_type = 0;
cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (tag_out0),
                          .data_out             (data_out0),
                          .hit                  (hit0),
                          .dirty                (dirty0),
                          .valid                (valid0),
                          .err                  (err0),
                          // Inputs
                          .enable               (enable0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in0),
                          .index                (index0),
                          .offset               (offset0),
                          .data_in              (data_in0),
                          .comp                 (ccomp0),
                          .write                (cwrite0),
                          .valid_in             (valid_in0));
   cache #(2 + mem_type) c1(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (data_out1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (err1),
                          // Inputs
                          .enable               (enable1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in1),
                          .index                (index1),
                          .offset               (offset1),
                          .data_in              (data_in1),
                          .comp                 (ccomp1),
                          .write                (cwrite1),
                          .valid_in             (valid_in1));

   four_bank_mem mem(// Outputs
                     .data_out          (memout),
                     .stall             (mstall),
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
		
		flip = 1'b0;
		
		valid_in = 1'b0;
		
		Done = 1'b0;
		CacheHit = 1'b0;
		
		error = 1'b0;
		nxtstate = 4'b0000;
		
		casex({state, Wr, Rd, hit, valid, dirty, busy, Addr[0]})		
			14'bXXXX_X_X_X_X_X_XXXX_1 : begin error = 1'b1; nxtstate = 4'b0000; end //Error
			
			//14'b0000_1_0_1_1_X_XXXX_X : begin flip = 1'b1; Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Write, in cycle
			//14'b0000_0_1_1_1_X_XXXX_X : begin flip = 1'b1; Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Read, in cycle
			14'b0000_1_0_X_X_X_XXXX_X : begin flip = 1'b1; ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Write
			14'b0000_0_1_X_X_X_XXXX_X : begin flip = 1'b1; ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0001; end //Read
			14'b0000_X_X_X_X_X_XXXX_X : begin nxtstate = 4'b0000; end //No Request (00 or 11)
			                        
			//14'b0001_1_0_1_1_X_XXXX_X : begin flip = 1'b1; Done = 1'b1; CacheHit = 1'b1; ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0000; end //Hit Repeat Write
			//14'b0001_0_1_1_1_X_XXXX_X : begin flip = 1'b1; Done = 1'b1; CacheHit = 1'b1; ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0000; end //Hit Repeat Read
			14'b0001_X_X_1_1_X_XXXX_X : begin Done = 1'b1; CacheHit = 1'b1; nxtstate = 4'b0000; end //Hit
			14'b0001_X_X_X_1_1_XXXX_X : begin ccomp = 1'b0; cwrite = 1'b0; coffset = 2'b00; mwrite = 1'b1; moffset = 2'b00; mover = 1'b1; nxtstate = 4'b1001; end //Dirty 0
			14'b0001_X_X_X_X_X_XXXX_X : begin mread = 1'b1; moffset = 2'b00; nxtstate = 4'b0010; end //Miss
			//14'b0001_X_X_X_X_X_XXXX_X : begin Done = 1'b1; nxtstate = 4'b0000; end
			                        
			14'b0010_X_X_X_X_X_XXXX_X : begin mread = 1'b1; moffset = 2'b01; nxtstate = 4'b0011; end //Start Read 1
			                        
			14'b0011_X_X_X_X_X_XXXX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b10; coffset = 2'b00; cdata = 1'b1; nxtstate = 4'b0100; end //Start Read 2 / Write Cahce 0
			                        
			14'b0100_X_X_X_X_X_XXXX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; mread = 1'b1; moffset = 2'b11; coffset = 2'b01; cdata = 1'b1; nxtstate = 4'b0101; end //Start Read 3 / Write Cache 1
			                        
			14'b0101_X_X_X_X_X_XXXX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b10; cdata = 1'b1; nxtstate = 4'b0110; end //Cache 2		
			                        
			14'b0110_1_0_X_X_X_XXXX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b11; cdata = 1'b1; nxtstate = 4'b0111; end //Cache 3 Write
			14'b0110_0_1_X_X_X_XXXX_X : begin ccomp = 1'b0; cwrite = 1'b1; valid_in = 1'b1; coffset = 2'b11; cdata = 1'b1; nxtstate = 4'b1000; end //Cache 3 Read
			                        
			14'b0111_X_X_X_X_X_XXXX_X : begin ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b1000; end //Dirty Write
			                        
			//14'b1000_1_0_X_X_X_XXXX_X : begin flip = 1'b1; Done = 1'b1; ccomp = 1'b1; cwrite = 1'b1; nxtstate = 4'b0001; end //Write on Done
			//14'b1000_0_1_X_X_X_XXXX_X : begin flip = 1'b1; Done = 1'b1; ccomp = 1'b1; cwrite = 1'b0; nxtstate = 4'b0001; end //Read on Done
			14'b1000_X_X_X_X_X_XXXX_X : begin Done = 1'b1; ccomp = 1'b0; cwrite = 1'b0; nxtstate = 4'b0000; end //Done
			                        
			14'b1001_X_X_X_X_X_1110_X : begin mread = 1'b1; moffset = 2'b00; nxtstate = 4'b0010; end //Read 0
			14'b1001_X_X_X_X_X_X111_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b11; nxtstate = 4'b1001; end //Dirty 3
			14'b1001_X_X_X_X_X_0X11_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b10; nxtstate = 4'b1001; end //Dirty 2
			14'b1001_X_X_X_X_X_00X1_X : begin mwrite = 1'b1; mover = 1'b1; moffset = 2'b01; nxtstate = 4'b1001; end //Dirty 1
		endcase
	end
	
	//mwrite = 1'b0; mread = 1'b0; moffset = 2'b00; coffset = 2'b00; mover = 1'b0; ccomp = 1'b0; cwrite = 1'b0; cdata = 1'b0;	flip = 1'b0; valid_in = 1'b0; Done = 1'b0; CacheHit = 1'b0;	error = 1'b0; nxtstate = 4'b0000;
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
