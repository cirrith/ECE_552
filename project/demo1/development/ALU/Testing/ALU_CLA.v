/********************************************************************************************************
/		MODULE: ALU_Bit16_CLA - 16 bit Carry Look-ahead Adder
/		PURPOSE: Given two 16 bit inputs and a carry in, creates 16 bit sum and carry out
/
/		INPUTS: A[15:0] - First Operand
/				B[15:0] - Second Operand
/				Ci - Carry in
/
/		OUTPUTS: S - Sum of Adddition
/				 Co - Carry Out 
********************************************************************************************************/
module ALU_CLA (A, B, Ci, S, Co);
input [15:0] A;
input [15:0] B;

input Ci;

output [15:0] S;
output Co;

wire [3:0] prop;
wire [3:0] gen;

wire C1;
wire C2;
wire C3;
wire C4;

assign C1 = gen[0] | prop[0]&Ci;
assign C2 = gen[1] | prop[1]&gen[0] | prop[1]&prop[0]&Ci; 
assign C3 = gen[2] | prop[2]&gen[1] | prop[2]&prop[1]&gen[0] | prop[2]&prop[1]&prop[0]&Ci;
assign Co = gen[3] | prop[3]&gen[2] | prop[3]&prop[2]&gen[1] | prop[3]&prop[2]&prop[1]&gen[0] | prop[3]&prop[2]&prop[1]&prop[0]&Ci;

cla_4b mod0(.A(A[3:0]),   .B(B[3:0]),   .Ci(Ci),  .S(S[3:0]),   .P(prop[0]), .G(gen[0]));
cla_4b mod1(.A(A[7:4]),   .B(B[7:4]),   .Ci(C1),  .S(S[7:4]),   .P(prop[1]), .G(gen[1]));
cla_4b mod2(.A(A[11:8]),  .B(B[11:8]),  .Ci(C2),  .S(S[11:8]),  .P(prop[2]), .G(gen[2]));
cla_4b mod3(.A(A[15:12]), .B(B[15:12]), .Ci(C3),  .S(S[15:12]), .P(prop[3]), .G(gen[3]));

endmodule 