module FA_2(A, B, CI, SUM, CO);

// 4-bit full adder w/ carring in

input [3:0]A;
input [3:0]B;
input CI;

output [3:0]SUM;
output CO;

wire n1, n2, n3;

//4_1-bit full adders strung together CIN to CO and AB split amoung FAs

FA DUT1 (.A(A[0]), .B(B[0]), .Cin(CI), .Cout(n1), .S(SUM[0]));
FA DUT2 (.A(A[1]), .B(B[1]), .Cin(n1), .Cout(n2), .S(SUM[1]));
FA DUT3 (.A(A[2]), .B(B[2]), .Cin(n2), .Cout(n3), .S(SUM[2]));
FA DUT4 (.A(A[3]), .B(B[3]), .Cin(n3), .Cout(CO), .S(SUM[3]));

endmodule
