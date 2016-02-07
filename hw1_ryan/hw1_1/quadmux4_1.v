module quadmux4_1 (InA, InB, InC, InD, S, Out);

//4-bit 4-to-1 multiplexer

input [3:0] InA;
input [3:0] InB;
input [3:0] InC;
input [3:0] InD;

input [1:0] S;

output [3:0] Out;

// 4_1-bit multiplexers
mux4to1 mux[3:0](.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S), .out(Out));

endmodule
