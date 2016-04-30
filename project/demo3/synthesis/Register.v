/********************************************************************************************************
/		MODULE: Register
/		PURPOSE: Given data, write signal, and clk store the data when the write signal is high at the positive
/			edge of the clock.
/
/
/		INPUTS: clk - Clock
/				rst - Reset
/				write - To write or not to write that is the question
/				wdata[Data_Width-1:0] - Data to write
/
/		OUTPUTS: rdata[Data_Width-1:0] - Data that is currently being stored
********************************************************************************************************/
module Register (clk, rst, write, wdata, rdata);

parameter Data_Width = 16;

input clk;
input rst;
input write;

input [Data_Width-1:0] wdata;

output [Data_Width-1:0] rdata;

wire [Data_Width-1:0] in;

dff bit[Data_Width-1:0] (.q(rdata), .d(in), .clk(clk), .rst(rst));

assign in = write ? wdata : rdata;

endmodule
