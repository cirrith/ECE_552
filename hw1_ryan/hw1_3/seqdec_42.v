module seqdec_42(InA, Clk, Reset, Out);

// 1 hot implmentation of sequence detector
// Reset brings State 1 (St1) high

input InA;
input Clk;
input Reset;

output Out;

wire q1, q2, q3, q4, q5, q6, q7, q8, q9;
wire d1, d2, d3, d4, d5, d6, d7, d8, d9;

// Register input logic

assign d1 = ((InA&&q1) || (InA&&q3) || (InA&&q8) || Reset);
assign d2 = ((!InA&&q1) || (!InA&&q2) || (!InA&&q7));
assign d3 = ((InA&&q2) || (InA&&q9) || (InA&&q6) || (InA&&q5) || (InA&&q4));
assign d4 = (!InA&&q3);
assign d5 = ((!InA&&q4) || (!InA&&q9));
assign d6 = (!InA&&q5);
assign d7 = (!InA&&q6);
assign d8 = (InA&&q7);
assign d9 = (!InA&&q8);

assign Out = q9;

// Layout of registers

dff St1 (.q(q1), .d(d1), .clk(Clk), .rst(0));
dff St2 (.q(q2), .d(d2), .clk(Clk), .rst(Reset));
dff St3 (.q(q3), .d(d3), .clk(Clk), .rst(Reset));
dff St4 (.q(q4), .d(d4), .clk(Clk), .rst(Reset));
dff St5 (.q(q5), .d(d5), .clk(Clk), .rst(Reset));
dff St6 (.q(q6), .d(d6), .clk(Clk), .rst(Reset));
dff St7 (.q(q7), .d(d7), .clk(Clk), .rst(Reset));
dff St8 (.q(q8), .d(d8), .clk(Clk), .rst(Reset));
dff St9 (.q(q9), .d(d9), .clk(Clk), .rst(Reset));

endmodule


