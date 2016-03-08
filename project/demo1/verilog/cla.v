/****************************
purpose: Given two 16-bit vectors and a carry in bit perform a carry look ahead addition
works: yes
****************************/
module cla (A, B, Cin, Si, Out, Ofl);
input [15:0] A;
input [15:0] B;

input Cin;
input Si;

output [15:0] Out;
output Ofl;

wire [3:0] prop;
wire [3:0] gen;

wire C1;
wire C2;
wire C3;
wire C4;

//TODO: CHECK THESE
assign C1 = gen[0] | prop[0]&Cin;
assign C2 = gen[1] | prop[1]&gen[0] | prop[1]&prop[0]&Cin; 
assign C3 = gen[2] | prop[2]&gen[1] | prop[2]&prop[1]&gen[0] | prop[2]&prop[1]&prop[0]&Cin;
assign C4 = gen[3] | prop[3]&gen[2] | prop[3]&prop[2]&gen[1] | prop[3]&prop[2]&prop[1]&gen[0] | prop[3]&prop[2]&prop[1]&prop[0]&Cin;

cla_4b mod0(.A(A[3:0]),   .B(B[3:0]),   .Cin(Cin), .S(Out[3:0]),   .P(prop[0]), .G(gen[0]));
cla_4b mod1(.A(A[7:4]),   .B(B[7:4]),   .Cin(C1),  .S(Out[7:4]),   .P(prop[1]), .G(gen[1]));
cla_4b mod2(.A(A[11:8]),  .B(B[11:8]),  .Cin(C2),  .S(Out[11:8]),  .P(prop[2]), .G(gen[2]));
cla_4b mod3(.A(A[15:12]), .B(B[15:12]), .Cin(C3),  .S(Out[15:12]), .P(prop[3]), .G(gen[3]));

assign Ofl = Si ? (A[15]&B[15]) ^ Out[15] : C4;

endmodule 