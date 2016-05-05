/********************************************************************************************************
/		MODULE: Bit1_Mux4_1
/		PURPOSE: Take 4 1 bit inputs and select between them based on a select code
/
/		INPUTS: in0 - Input 0 00
/				in1 - Input 1 01
/				in2 - Input 2 10
/				in3 - Input 3 11
/				s[1:0] - Select Code
/
/		OUTPUTS: out - output of mux
********************************************************************************************************/
module Bit1_Mux4_1 (in0, in1, in2, in3, s, out);
input in0;
input in1;
input in2;
input in3;
input [1:0]s;

output out;

assign out = s[1] ? (s[0] ? in3 : in2) : (s[0] ? in1 : in0);

endmodule 
