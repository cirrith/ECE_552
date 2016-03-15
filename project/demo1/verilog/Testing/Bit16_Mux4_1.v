/********************************************************************************************************
/		MODULE: Bit16_Mux4_1
/		PURPOSE: Take 4 16 bit inputs and select between them based on a select code
/
/		INPUTS: in0 - Input 0 00
/				in1 - Input 1 01
/				in2 - Input 2 10
/				in3 - Input 3 11
/				s[1:0] - Select Code
/
/		OUTPUTS: out[15:0] - output of mux
********************************************************************************************************/
module Bit16_Mux4_1 (in0, in1, in2, in3, s, out);
input [15:0] in0;
input [15:0] in1;
input [15:0] in2;
input [15:0] in3;
input [1:0] s;

output [15:0] out;

assign out = s[1] ? (s[0] ? in3 : in2) : (s[0] ? in1 : in0);

endmodule 