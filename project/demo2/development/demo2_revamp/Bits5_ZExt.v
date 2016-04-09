/********************************************************************************************************
/		MODULE: Bit8_ZExt
/		PURPOSE: Given a 5 bit input sign extend it up to 16 bits
/
/		INPUTS: In[4:0] - Input to sign extend
/
/		OUTPUTS: Out[15:0] - Signed Extended output
********************************************************************************************************/
module Bits5_ZExt(In, Out);

	input [4:0] In;
	
	output [15:0] Out;

	assign Out = {{11{1'b0}}, In[4:0]};	
endmodule