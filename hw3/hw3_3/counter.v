module counter(valid, pop, clk, rst, sel, write, full, empty, datavalid);

input valid;
input pop;
input clk;
input rst;

output [3:0] write;
output [3:0] sel;
output full;
output empty;
output datavalid;

wire [4:0] d;
wire [4:0] q;

dff St0 (.q(q[0]), .d(d[0]), .clk(clk), .rst(1'b0));
dff St1 (.q(q[1]), .d(d[1]), .clk(clk), .rst(rst));
dff St2 (.q(q[2]), .d(d[2]), .clk(clk), .rst(rst));
dff St3 (.q(q[3]), .d(d[3]), .clk(clk), .rst(rst));
dff St4 (.q(q[4]), .d(d[4]), .clk(clk), .rst(rst));

assign d[0] = !valid&pop&q[1] | !valid&!pop&q[0] | !valid&pop&q[0] | rst;
assign d[1] = valid&pop&q[1] | valid&!pop&q[0] | !valid&pop&q[2] | !valid&!pop&q[1] | valid&pop&q[0];
assign d[2] = valid&pop&q[2] | valid&!pop&q[1] | !valid&pop&q[3] | !valid&!pop&q[2];
assign d[3] = valid&pop&q[3] | valid&!pop&q[2] | !valid&pop&q[4] | !valid&!pop&q[3] | valid&pop&q[4];
assign d[4] = valid&!pop&q[3] | valid&!pop&q[4] | !valid&!pop&q[4];

assign write[0] = valid&pop&q[0] | valid&!pop&q[0] | !valid&pop&q[1] | valid&pop&q[1] | !valid&pop&q[2] | valid&pop&q[2] | !valid&pop&q[3] | valid&pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];
assign write[1] = valid&!pop&q[1] | !valid&pop&q[2] | valid&pop&q[2] | !valid&pop&q[3] | valid&pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];
assign write[2] = valid&!pop&q[2] | !valid&pop&q[3] | valid&pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];
assign write[3] = valid&!pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];

assign sel[0] = !valid&pop&q[1] | !valid&pop&q[2] | valid&pop&q[2] | !valid&pop&q[3] | valid&pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];
assign sel[1] = !valid&pop&q[2] | !valid&pop&q[3] | valid&pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];
assign sel[2] = !valid&pop&q[3] | valid&pop&q[4] | !valid&pop&q[4];
assign sel[3] = valid&pop&q[4] | !valid&pop&q[4];

assign empty = q[0] | rst;
assign full = q[4];

assign datavalid = q[1] | q[2] | q[3] | q[4];

endmodule 