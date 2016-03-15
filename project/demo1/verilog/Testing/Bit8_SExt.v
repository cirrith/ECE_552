/********************************************************************************************************
/		MODULE: Bit8_SExt
/		PURPOSE: Given a 8 bit input sign extend it up to 16 bits
/
/		INPUTS: In[7:0] - Input to sign extend
/
/		OUTPUTS: Out[15:0] - Signed Extended output
********************************************************************************************************/
module Bits8_SExt(In, Out);

	input [7:0] In;

	output [15:0] Out;
		
	assign Out = {{8{In[7]}}, In[7:0]};

endmodule