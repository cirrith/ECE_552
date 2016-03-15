/********************************************************************************************************
/		MODULE: ALU_XOR
/		PURPOSE: Given two 16 bit inputs does bitwise ANDN between the two and returns result
/
/		INPUTS: A - First Operand
/				B - Second Operand
/
/		OUTPUTS: Out - Result of andn
********************************************************************************************************/
module ALU_ANDN (A, B, Out);

input [15:0] A;
input [15:0] B;

output [15:0] Out;

and ANDN[15:0] (Out, A, ~B);

endmodule 
