////////////////////////////////////////////////////////////////////////////////
////	Bits8_Ext															////
////	works																////
////////////////////////////////////////////////////////////////////////////////

module Bits5_Ext(In, Sign, Out);

// Declare all inputs and outputs
	input Sign;
	input [7:0] In;
	output [15:0] Out;
	

// Instantiate required logic
	assign Out = Sign ? {{8{In[7]}}, In[7:0]} : {8'h00, In[7:0]};

	
endmodule