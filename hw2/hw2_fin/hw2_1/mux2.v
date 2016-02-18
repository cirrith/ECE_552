/****************************
purpose: Given two inputs select between the two with s bit
****************************/

module mux2 (in0, in1, s, out);
input in0;
input in1;
input s;

output out;

assign out = s ? in1 : in0;

endmodule
