/****************************
purpose: Given two 16-bit vectors perform bitwise And on them
****************************/
module And (A, B, Out);

input [15:0] A;
input [15:0] B;

output [15:0] Out;

and AND[15:0] (Out, A, B);

endmodule 