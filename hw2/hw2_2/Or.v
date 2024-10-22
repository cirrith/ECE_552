/****************************
purpose: Given two 16-bit vectors perform bitwise Or on them
****************************/
module Or (A, B, Out);

input [15:0] A;
input [15:0] B;

output [15:0] Out;

or OR[15:0] (Out, A, B);

endmodule 
