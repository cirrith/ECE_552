////////////////////////////////////////////////////////////////////////////////
////	PC_inc																////
////	works																////
////////////////////////////////////////////////////////////////////////////////

module PC_inc(PC, New_PC);

// Declare inputs and outputs
	input [15:0] PC;
	output [15:0] New_PC;
	
	
// Declare wires
	wire Overflow;
	wire [2:0] inc;
	
	
// Instantiate required logic
	assign inc = 3'b100;
	
	cla incrementer(.A(PC), .B(inc), .Cin(1'b0), .Si(1'b0), .Out(New_PC), .Ofl(Overflow));
	

endmodule






