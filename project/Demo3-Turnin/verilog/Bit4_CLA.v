/********************************************************************************************************
/		MODULE: Bit4_CLA - 4 bit Carry Look-ahead Adder
/		PURPOSE: Given two four bit inputs and a carry in, creates four bit sum and propagate and generate signals
/			for the block of four bits
/
/		INPUTS: A [3:0] - First Operand
/				B [3:0] - Second Operand
/				Ci - Carry in
/
/		OUTPUTS: S [3:0] - Sum of Adddition
/				 P - Propagate 
/				 G - Generate
********************************************************************************************************/
module Bit4_CLA (A, B, Ci, S, P, G);

input [3:0] 	A;
input [3:0]		B;
input 			Ci;

output [3:0] 	S;
output 			P;
output 			G;

wire [3:0] prop;
wire [3:0] gen;

wire C1;
wire C2;
wire C3;

assign C1 = gen[0] | prop[0]&Ci;
assign C2 = gen[1] | prop[1]&gen[0] | prop[1]&prop[0]&Ci; 
assign C3 = gen[2] | prop[2]&gen[1] | prop[2]&prop[1]&gen[0] | prop[2]&prop[1]&prop[0]&Ci;

CLA_FA FA_mod0(.A(A[0]), .B(B[0]), .Ci(Ci), .S(S[0]), .P(prop[0]), .G(gen[0]));
CLA_FA FA_mod1(.A(A[1]), .B(B[1]), .Ci(C1),  .S(S[1]), .P(prop[1]), .G(gen[1]));
CLA_FA FA_mod2(.A(A[2]), .B(B[2]), .Ci(C2),  .S(S[2]), .P(prop[2]), .G(gen[2]));
CLA_FA FA_mod3(.A(A[3]), .B(B[3]), .Ci(C3),  .S(S[3]), .P(prop[3]), .G(gen[3]));

assign P = &prop;
assign G = gen[3] | prop[3]&gen[2] | prop[3]&prop[2]&gen[1] | prop[3]&prop[2]&prop[1]&gen[0];

endmodule 

//Checked 3/22/16