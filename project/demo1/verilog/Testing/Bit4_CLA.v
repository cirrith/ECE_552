/********************************************************************************************************
/		MODULE: Bit4_CLA - 4 bit Carry Look-ahead Adder
/		PURPOSE: Given two four bit inputs and a carry in, creates four bit sum and propagate and generate signals
			for the block of four bits
/
/		INPUTS: A - First Operand
/				B - Second Operand
/				Cin - Carry in
/
/		OUTPUTS: S - Sum of Adddition
/				 P - Propagate 
/				 G - Generate
********************************************************************************************************/
module Bit4_CLA(A, B, Cin, S, G, P);

input [3:0] A,B;
input Cin;
output [3:0] S;
output wire G, P;

wire g0, g1, g2, g3, p1, p2, p3, c2, c3;

assign g0 = A[0] & B[0]; 
assign g1 = A[1] & B[1]; 
assign g2 = A[2] & B[2]; 
assign g3 = A[3] & B[3];
assign p0 = A[0] | B[0];
assign p1 = A[1] | B[1];
assign p2 = A[2] | B[2];
assign p3 = A[3] | B[3];
assign c1 = (Cin & p0) | g0;
assign c2 = (c1 & p1) | g1;
assign c3 = (c2 & p2) | g2;
assign G = (c3 & p3) | g3; // c4 OR Cout
assign P = (A[0] | B[0]) & (A[1] | B[1]) & (A[2] | B[2]) & (A[3] | B[3]);

CLA_FA fa1(.A(A[0]),.B(B[0]),.Cin(Cin),.S(S[0]),.Cout());
CLA_FA fa2(.A(A[1]),.B(B[1]),.Cin(c1),.S(S[1]),.Cout());
CLA_FA fa3(.A(A[2]),.B(B[2]),.Cin(c2),.S(S[2]),.Cout());
CLA_FA fa4(.A(A[3]),.B(B[3]),.Cin(c3),.S(S[3]),.Cout());		

endmodule