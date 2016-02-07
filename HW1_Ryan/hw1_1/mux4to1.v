module mux4to1(out, InA, InB, InC, InD, S);

input InA, InB, InC, InD;
input [1:0] S;
output out;

wire n1, n2;

// 4-to-1 multiplexer, two levels of muxing (A or B) & (C or D)

mux2to1 Mux1(.out(n1), .InA(InA), .InB(InB), .S(S[0]));  //AB mux

mux2to1 Mux2(.out(n2), .InA(InC), .InB(InD), .S(S[0]));  //CD mux

mux2to1 Mux3(.out(out), .InA(n1), .InB(n2), .S(S[1]));  //AB or CD mux

endmodule
