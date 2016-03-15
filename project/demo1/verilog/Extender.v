/********************************************************************************************************
/		MODULE: Extender
/		PURPOSE: Given Inputs to extend and provide all the possible extentsions
/
/		INPUTS: Instruction[10:0] - Input to sign extend
/
/		OUTPUTS: Imm5S[15:0] - 5 bit sign extended value
/				 Imm5Z[15:0] - 5 bit zero extended value
/				 Imm8S[15:0] - 8 bit sign extended value
/				 Dis11[15:0] - 11 bit sign extended value
********************************************************************************************************/
module Extender (Extend, Imm5S, Imm5Z, Imm8S, Dis11);

	input [10:0] Extend;
	
	output [15:0] Imm5S;
	output [15:0] Imm5Z;
	output [15:0] Imm8S;
	output [15:0] Dis11;
	
	Bits5_SExt choiceA(.In(Extend[4:0]), .Out(Imm5S));
	Bits5_ZExt choiceB(.In(Extend[4:0]), .Out(Imm5Z));
	Bits8_SExt choiceC(.In(Extend[7:0]), .Out(Imm8S));
	Bits11_SExt choiceD(.In(Extend[10:0]), .Out(Dis11));

endmodule 