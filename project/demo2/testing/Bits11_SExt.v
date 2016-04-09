/********************************************************************************************************
/		MODULE: Bit8_SExt
/		PURPOSE: Given a 11 bit input sign extend it up to 16 bits
/
/		INPUTS: In[10:0] - Input to sign extend
/
/		OUTPUTS: Out[15:0] - Signed Extended output
********************************************************************************************************/
module Bits11_SExt(In, Out);

	input [10:0] In;
	
	output [15:0] Out;

	assign Out = {{5{In[10]}}, In[10:0]};
endmodule