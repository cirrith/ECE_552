module fulladder16(A, B, SUM, CO);

// 16-bit full adder block w/o carry in

input [15:0]A;
input [15:0]B;

output [15:0]SUM;
output CO;

wire n1, n2, n3;

// 4_4-bit full adders strung together CO to CIN & A/B split among the 4

FA_2 FA1(.A(A[3:0]), .B(B[3:0]), .CI(0), .CO(n1), .SUM(SUM[3:0]));
FA_2 FA2(.A(A[7:4]), .B(B[7:4]), .CI(n1), .CO(n2), .SUM(SUM[7:4]));
FA_2 FA3(.A(A[11:8]), .B(B[11:8]), .CI(n2), .CO(n3), .SUM(SUM[11:8]));
FA_2 FA4(.A(A[15:12]), .B(B[15:12]), .CI(n3), .CO(CO), .SUM(SUM[15:12]));

endmodule
