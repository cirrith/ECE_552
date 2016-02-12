/****************************
purpose: Given a 16 bit input perform the given opcode by 1 when sh is high
****************************/

module shift1 (in, op, sh, out);
input [15:0] in;
input sh;
input [1:0] op;

output [15:0] out;

wire [15:0] trans; 




mux2 low_sel0(.in0(in[0]), .in1(trans[0]), .s(sh), .out(out[0]));




endmodule 
