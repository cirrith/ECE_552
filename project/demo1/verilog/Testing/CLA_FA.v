/********************************************************************************************************
/		MODULE: CLA_FA - Carry Look-ahead Full Adder
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
module CLA_FA(A,B,Cin,S,Cout);
input A,B,Cin;
output S,Cout;

wire abSum,abSumAndCin,abSumAndCinInv,abCarry,abCarryIn,carryAnd;

// Going off picture created in Notebook (look there for reference)
xor2 xorMod1(.in1(A),.in2(B),.out(abSum));
xor2 xorMod2(.in1(abSum),.in2(Cin),.out(S));

nand2 nandMod1(.in1(abSum),.in2(Cin),.out(abSumAndCin));
not1 notMod1(.in1(abSumAndCin),.out(abSumAndCinInv));

nand2 nandMod2(.in1(A),.in2(B),.out(abCarry));
not1 notMod2(.in1(abCarry),.out(abCarryInv));

nor2 norMod1(.in1(abSumAndCinInv),.in2(abCarryInv),.out(carryAnd));
not1 notMod3(.in1(carryAnd),.out(Cout));

endmodule
