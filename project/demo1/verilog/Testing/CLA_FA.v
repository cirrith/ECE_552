/********************************************************************************************************
/		MODULE: ALU_CLA_FA - Carry Look-ahead Full Adder
/		PURPOSE: Given three one bit inputs, creates sum and propagate and generate signals
/
/		INPUTS: A - First Operand
/				B - Second Operand
/				Cin - Carry in
/
/		OUTPUTS: S - Sum of Adddition
/				 P - Propagate 
/				 G - Generate
********************************************************************************************************/
module CLA_FA (A, B, Cin, S, P, G);

input A;
input B;
input Cin;

output P;
output G;
output S;

xor Prop (P, A, B);
and Gen (G, A, B);

xor Sum (S, A, B, Cin);

endmodule
