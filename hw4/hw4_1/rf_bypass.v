/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (read1data, read2data, err, clk, rst, read1regsel, read2regsel, writeregsel, writedata, write);
	input clk, rst;
	input [2:0] read1regsel;
	input [2:0] read2regsel;
	input [2:0] writeregsel;
	input [15:0] writedata;
	input        write;
	
	output [15:0] read1data;
	output [15:0] read2data;
	output        err;
	
	wire [15:0] read1out;
	wire [15:0] read2out;
	
	rf RF(.read1data(read1out), .read2data(read2out), .err(err), .clk(clk), .rst(rst), .read1regsel(read1regsel), .read2regsel(read2regsel), .writeregsel(writeregsel), .writedata(writedata), .write(write));

	assign read1data = write ? (writeregsel == read1regsel ? writedata: read1out) : read1out;
	assign read2data = write ? (writeregsel == read2regsel ? writedata: read2out) : read2out;
	
endmodule
// DUMMY LINE FOR REV CONTROL :1:
