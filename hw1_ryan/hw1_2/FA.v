module FA(A, B, Cin, S, Cout);

// 1-bit full adder w/ carry in
// Constructed using only nand & xor gates

input A;
input B;
input Cin;

output S;
output Cout;

wire n1, n2, n3;

xor2 XO1(.in1(A), .in2(B), .out(n1));
xor2 XO2(.in1(n1), .in2(Cin), .out(S));

nand2 NA1(.in1(n1), .in2(Cin), .out(n2));
nand2 NA2(.in1(A), .in2(B), .out(n3));
nand2 NA3(.in1(n2), .in2(n3), .out(Cout));

endmodule 
