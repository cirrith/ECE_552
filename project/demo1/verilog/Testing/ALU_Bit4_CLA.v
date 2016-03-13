/********************************************************************************************************
/		MODULE: ALU_Bit4_CLA - 4 bit Carry Look-ahead Adder
/		PURPOSE: Given two four bit inputs and a carry in, creates four bit sum and propagate and generate signals
			for the block of four bits
/
/		INPUTS: A - First Operand
/				B - Second Operand
/				Ci - Carry in
/
/		OUTPUTS: S - Sum of Adddition
/				 P - Propagate 
/				 G - Generate
********************************************************************************************************/
<<<<<<< HEAD
module ALU_Bit4_CLA (A, B, Ci, S, P, G);

input [3:0] A;
input [3:0] B;
input Ci;

output [3:0] S;
output P;
output G;

wire [3:0] prop;
wire [3:0] gen;

wire C1;
wire C2;
wire C3;

assign C1 = gen[0] | prop[0]&Ci;
assign C2 = gen[1] | prop[1]&gen[0] | prop[1]&prop[0]&Ci; 
assign C3 = gen[2] | prop[2]&gen[1] | prop[2]&prop[1]&gen[0] | prop[2]&prop[1]&prop[0]&Ci;

ALU_CLA_FA FA_mod0(.A(A[0]), .B(B[0]), .Ci(Ci), .S(S[0]), .P(prop[0]), .G(gen[0]));
ALU_CLA_FA FA_mod1(.A(A[1]), .B(B[1]), .Ci(C1),  .S(S[1]), .P(prop[1]), .G(gen[1]));
ALU_CLA_FA FA_mod2(.A(A[2]), .B(B[2]), .Ci(C2),  .S(S[2]), .P(prop[2]), .G(gen[2]));
ALU_CLA_FA FA_mod3(.A(A[3]), .B(B[3]), .Ci(C3),  .S(S[3]), .P(prop[3]), .G(gen[3]));

assign P = &prop;
assign G = gen[3] | prop[3]&gen[2] | prop[3]&prop[2]&gen[1] | prop[3]&prop[2]&prop[1]&gen[0];

endmodule 
=======
module ALU_Bit4_CLA(A, B, Cin, S, G, P);

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

ALU_CLA_FA fa1(.A(A[0]),.B(B[0]),.Cin(Cin),.S(S[0]),.Cout());
ALU_CLA_FA fa2(.A(A[1]),.B(B[1]),.Cin(c1),.S(S[1]),.Cout());
ALU_CLA_FA fa3(.A(A[2]),.B(B[2]),.Cin(c2),.S(S[2]),.Cout());
ALU_CLA_FA fa4(.A(A[3]),.B(B[3]),.Cin(c3),.S(S[3]),.Cout());		

endmodule
>>>>>>> 2e640e2555e217a06b6c352cc5c5f6091e568d2d
