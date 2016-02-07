module mul2to1(out, InA, InB, S);
input InA, InB, S;
output out;
wire n1, n2, n3;

not1 N1(.in1(S), .out(n1));

nand2 NA1(.in1(InA), .in2(n1), .out(n2));
nand2 NA2(.in1(InB), .in2(S), .out(n3));

nand2 NA3(.in1(n2), .in2(n3), .out(out));
endmodule
