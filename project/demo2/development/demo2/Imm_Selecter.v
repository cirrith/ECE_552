/********************************************************************************************************
/		MODULE: Imm_Selecter
/		PURPOSE: Given Inputs to extend and a select code produce the correct extened output
/
/		INPUTS: Extend[10:0] - Input to sign extend
/				Imm_Sel[2:0] - Select bits for output
/					000 - 5 Bit Sign Extended
/					001 - 5 Bit Zero Extended
/					010 - 8 Bit Sign Extended
/					011 - 11 Bit Sign Extended
/					100 - PC + 2
/					101 - UNUSED
/					110 - UNUSED
/					111 - UNUSED
/
/		OUTPUTS: Immediate[15:0] - To be passed into one of the possible slot for ALU B Source
********************************************************************************************************/
module Imm_Selecter (Extend, Imm_Sel, PC2, Immediate);
	
	input [10:0] Extend;
	input [2:0] Imm_Sel;
	input [15:0] PC2;
	
	output [15:0] Immediate;
	
	wire [15:0] Imm5S;
	wire [15:0] Imm5Z;
	wire [15:0] Imm8S;
	wire [15:0] Imm11S;
	
	Bits5_SExt choice0(.In(Extend[4:0]), .Out(Imm5S));
	Bits5_ZExt choice1(.In(Extend[4:0]), .Out(Imm5Z));
	Bits8_SExt choice2(.In(Extend[7:0]), .Out(Imm8S));
	Bits11_SExt choice3(.In(Extend[10:0]), .Out(Imm11S));
	
	Bit16_Mux8_1 Mux(.in0(Imm5S), .in1(Imm5Z), .in2(Imm8S), .in3(Imm11S), .in4(PC2), .in5(16'h0000), .in6(16'h0000), .in7(16'h0000), .s(Imm_Sel), .out(Immediate))

endmodule 