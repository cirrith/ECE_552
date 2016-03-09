/****************************
purpose: Given two 1-bit vectors add them and generate the Propagate, Generate, and Sum signals
works: yes
****************************/

module cla_FA (A, B, Cin, S, P, G);

input A;
input B;
input Cin;

output P;
output G;
output S;

xor Prop (P, A, B);
and Gen (G, A, B);

xor Sum (S, A, B, Cin);

endmodule
