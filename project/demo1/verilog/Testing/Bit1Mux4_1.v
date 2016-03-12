/**************************************************************************************************
PURPOSE: Given 4 one bit inputs choose between the four with a two bit select input.
**************************************************************************************************/
module Bit1_Mux4_1 (in0, in1, in2, in3, s, out);
input in0;
input in1;
input in2;
input in3;
input [1:0]s;

output out;

assign out = s[1] ? (s[0] ? in3 : in2) : (s[0] ? in1 : in0);

endmodule 