/****************************
purpose: Given two 4-bit vectors add them and generate the Propagate, Generate, and Sum signals
works: yes
****************************/

module cla_4b (A, B, Cin, S, P, G);

input [3:0] A;
input [3:0] B;
input Cin;

output [3:0] S;
output P;
output G;

wire [3:0] prop;
wire [3:0] gen;

wire C1;
wire C2;
wire C3;

//TODO: CHECK THESE
assign C1 = gen[0] | prop[0]&Cin;
assign C2 = gen[1] | prop[1]&gen[0] | prop[1]&prop[0]&Cin; 
assign C3 = gen[2] | prop[2]&gen[1] | prop[2]&prop[1]&gen[0] | prop[2]&prop[1]&prop[0]&Cin;

cla_FA FA_mod0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .P(prop[0]), .G(gen[0]));
cla_FA FA_mod1(.A(A[1]), .B(B[1]), .Cin(C1),  .S(S[1]), .P(prop[1]), .G(gen[1]));
cla_FA FA_mod2(.A(A[2]), .B(B[2]), .Cin(C2),  .S(S[2]), .P(prop[2]), .G(gen[2]));
cla_FA FA_mod3(.A(A[3]), .B(B[3]), .Cin(C3),  .S(S[3]), .P(prop[3]), .G(gen[3]));

//TODO: CHECK THESE
assign P = &prop;
assign G = gen[3] | prop[3]&gen[2] | prop[3]&prop[2]&gen[1] | prop[3]&prop[2]&prop[1]&gen[0];

endmodule 
