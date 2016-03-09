////////////////////////////////////////////////////////////////////////////////
////	16-bit 2->1 Mux														////
////	works																////
////////////////////////////////////////////////////////////////////////////////

module Bits16_Mux2_1(A, B, Sel, Out);

// Declare inputs and outputs
	input Sel;
	input [15:0] A, B;
	output [15:0] Out;
	
	
// Instantiate required logic
	assign Out = Sel ? B : A;
	
	
endmodule







