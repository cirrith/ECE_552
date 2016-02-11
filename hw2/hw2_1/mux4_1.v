// For this mux, I assume that A is the lowest and D is the highest.
// Similar to hex values

module mux4_1(A, B, C, D, Sel, Out);

// Declare inputs and outputs
input A, B, C, D;
input [1:0] Sel;
output Out;


////////////////////////////////////////////////////////////////////////////////
////////////////////		 	Do the thing!				////////////////////
////////////////////////////////////////////////////////////////////////////////


assign Out = (Sel[1] && Sel[0]) ? D : ((Sel[1] && !Sel[0]) ? C : ((!Sel[1] && Sel[0]) ? B : A));


endmodule