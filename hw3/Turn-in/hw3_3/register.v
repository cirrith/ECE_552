/**************************
Purpose: Store a 16 bit vector on posedge clk w/ write high. Clear on rst and always output data on data

Inputs: 
	clk: Clock
	write: Data to store on posedge clock with write high
	rst: Reset to 0
	wdata: [15:0] Data to be stored

Outputs:
	rdata: [15:0] Data currently being stored
***************************/

module register (clk, rst, write, wdata, rdata);

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
