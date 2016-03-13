/**************************************************************************************************
PURPOSE: Given two one bit inputs choose between the two with a select input.
**************************************************************************************************/
module Bit1Mux2_1 (in0, in1, s, out);
input in0;
input in1;
input s;

output out;

assign out = s ? in1 : in0;

endmodule
