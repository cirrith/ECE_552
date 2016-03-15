/********************************************************************************************************
/		MODULE: ALU_CLA_FA - Carry Look-ahead Full Adder
/		PURPOSE: Given three one bit inputs, creates sum and propagate and generate signals
/
/		INPUTS: A - First Operand
/				B - Second Operand
/				Ci - Carry in
/
/		OUTPUTS: S - Sum of Adddition
/				 P - Propagate 
/				 G - Generate
********************************************************************************************************/
module ALU_CLA_FA (A, B, Ci, S, P, G);

input A;
input B;
input Ci;

output P;
output G;
output S;

xor Prop (P, A, B);
and Gen (G, A, B);

xor Sum (S, A, B, Ci);

endmodule
