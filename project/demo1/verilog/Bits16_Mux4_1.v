////////////////////////////////////////////////////////////////////////////////
////	16-bit 4->1 Mux														////
////	works																////
////////////////////////////////////////////////////////////////////////////////

module Bits16_Mux4_1(A, B, C, D, Sel, Out);

	// Declare inputs and outputs
	input [1:0] Sel;
	input [15:0] A, B, C, D;
	output [15:0] Out;
	
	
	// Declare wires
	wire [15:0] temp_low, temp_high;
	
	
	// Instantiate required logic
	Bits16_Mux2_1   level_low(.A(A[15:0]), .B(B[15:0]), .Sel(Sel[0]), .Out(temp_low[15:0]));
	Bits16_Mux2_1  level_high(.A(C[15:0]), .B(D[15:0]), .Sel(Sel[0]), .Out(temp_high[15:0]));
	Bits16_Mux2_1 level_final(.A(temp_low), .B(temp_high), .Sel(Sel[1]), .Out(Out[15:0]));
	
	
endmodule







