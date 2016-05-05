/********************************************************************************************************
/		MODULE: Bit16_Mux8_1
/		PURPOSE: 8 input Mux with 3 select lines
/
/		INPUTS: in0 [15:0] - 000
/				in1 [15:0] - 001
/				in2 [15:0] - 010
/				in3 [15:0] - 011
/				in4 [15:0] - 100
/				in5 [15:0] - 101
/				in6 [15:0] - 110
/				in7 [15:0] - 111
/				s [2:0] - Select lines
/
/		OUTPUTS: out [15:0] - output of mux
********************************************************************************************************/
module Bit16_Mux8_1 (in0, in1, in2, in3, in4, in5, in6, in7, s, out);

	input [15:0] in0;
	input [15:0] in1;
	input [15:0] in2;
	input [15:0] in3;
	input [15:0] in4;
	input [15:0] in5;
	input [15:0] in6;
	input [15:0] in7;
	input [2:0] s;
	
	output [15:0] out;

	assign out = s[2] ?	(s[1] ? (s[0] ? in7 : in6) : (s[0] ? in5 : in4)) : (s[1] ? (s[0] ? in3 : in2) : (s[0] ? in1 : in0));

endmodule