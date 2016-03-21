/********************************************************************************************************
/		MODULE: ALU_XOR
/		PURPOSE: Given two 16 bit inputs does bitwise XOR between the two and returns result
/
/		INPUTS: A - First Operand
/				B - Second Operand
/
/		OUTPUTS: Out - Result of xor
********************************************************************************************************/
module ALU_XOR (A, B, Out);

input [15:0] A;
input [15:0] B;

output [15:0] Out;

xor XOR[15:0] (Out, A, B);

endmodule 
