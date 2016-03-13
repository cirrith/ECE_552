/********************************************************************************************************
/		MODULE: CLA - 16 bit Carry Look-ahead Adder
/		PURPOSE: Given two 16 bit inputs and a carry in, creates 16 bit sum and carry out
/
/		INPUTS: A[15:0] - First Operand
/				B[15:0] - Second Operand
/				Ci - Carry in
/
/		OUTPUTS: S - Sum of Adddition
/				 Co - Carry Out 
********************************************************************************************************/
module CLA(A, B, Cin, S, Cout);

input [15:0] A,B;
input Cin;
output [15:0] S;
output Cout;

wire g0, g1, g2, g3, p0, p1, p2, p3;

assign c1 = (Cin & p0) | g0;
assign c2 = (c1 & p1) | g1;
assign c3 = (c2 & p2) | g2;
assign Cout = (c3 & p3) | g3;

Bit4_CLA claMod1(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .G(g0), .P(p0));
Bit4_CLA claMod2(.A(A[7:4]), .B(B[7:4]), .Cin(c1), .S(S[7:4]), .G(g1), .P(p1));
Bit4_CLA claMod3(.A(A[11:8]), .B(B[11:8]), .Cin(c2), .S(S[11:8]), .G(g2), .P(p2));
Bit4_CLA claMod4(.A(A[15:12]), .B(B[15:12]), .Cin(c3), .S(S[15:12]), .G(g3), .P(p3));
	
endmodule