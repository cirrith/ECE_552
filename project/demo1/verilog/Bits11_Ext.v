////////////////////////////////////////////////////////////////////////////////
////	Bits11_Ext															////
////	works																////
////////////////////////////////////////////////////////////////////////////////

module Bits11_Ext(In, Sign, Out);

// Declare all inputs and outputs
	input Sign;
	input [10:0] In;
	output [15:0] Out;
	

// Instantiate required logic
	assign Out = {{5{In[10]}}, In[10:0]};

	
endmodule