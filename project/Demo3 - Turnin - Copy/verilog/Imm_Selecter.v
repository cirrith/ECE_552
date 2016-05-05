/********************************************************************************************************
/		MODULE: Imm_Selecter
/		PURPOSE: Given Inputs to extend and a select code produce the correct extened output
/
/		INPUTS: Extend[10:0] - Input to sign extend
/				Imm_Sel[1:0] - Select bits for output
/					00 - 5 Bit Sign Extended
/					01 - 5 Bit Zero Extended
/					10 - 8 Bit Sign Extended
/					11 - 11 Bit Sign Extended
/
/		OUTPUTS: Immediate[15:0] - To be passed into one of the possible slot for ALU B Source
********************************************************************************************************/
module Imm_Selecter (Extend, Imm_Sel, Immediate);
	
	input [10:0] Extend;
	input [1:0] Imm_Sel;
	
	output [15:0] Immediate;
	
	wire [15:0] Imm5S;
	wire [15:0] Imm5Z;
	wire [15:0] Imm8S;
	wire [15:0] Imm11S;
	
	Bits5_SExt choice0(.In(Extend[4:0]), .Out(Imm5S));
	Bits5_ZExt choice1(.In(Extend[4:0]), .Out(Imm5Z));
	Bits8_SExt choice2(.In(Extend[7:0]), .Out(Imm8S));
	Bits11_SExt choice3(.In(Extend[10:0]), .Out(Imm11S));
	
	Bit16_Mux4_1 Mux(.in0(Imm5S), .in1(Imm5Z), .in2(Imm8S), .in3(Imm11S), .s(Imm_Sel), .out(Immediate));

endmodule 