/****************************
purpose: Given two 16-bit vectors perform bitwise Xor on them
****************************/
module Xor (A, B, Out);

input [15:0] A;
input [15:0] B;

output [15:0] Out;

xor XOR[15:0] (Out, A, B);

endmodule 
