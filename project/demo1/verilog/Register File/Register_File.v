/********************************************************************************************************
/		MODULE: Register_File
/		PURPOSE: Contains 8 16-bit registers, two of which can be read from in a single cycle and one which
/		can be written too. 
/
/
/		INPUTS: clk - Clock
/				rst - Reset
/				read1regsel [2:0] - Which register to read for output 1
/				read2regsel [2:0] - Which register to read for output 2
/				writeregsel [2:0] - Which register to write to when enabled
/				writedata [15:0] -  Data to write
/				write - To write or not to write that is the question
/
/		OUTPUTS: read1data - Data from the 1st selected register
/				 read2data - Data from the 2nd selected register
				 err - ???
********************************************************************************************************/
module Register_File (read1data, read2data, err, clk, rst, read1regsel, read2regsel, writeregsel, writedata, write);

	parameter width = 16;
	
	input clk, rst;
	input [2:0] read1regsel;
	input [2:0] read2regsel;
	input [2:0] writeregsel;
	input [15:0] writedata;
	input        write;

	output [15:0] read1data;
	output [15:0] read2data;
	output        err;
   
	wire [7:0] wri;
	wire [15:0] regOut [0:7];
	
	assign wri[0] = (writeregsel == 0) & write;
	assign wri[1] = (writeregsel == 1) & write;
	assign wri[2] = (writeregsel == 2) & write;
	assign wri[3] = (writeregsel == 3) & write;
	assign wri[4] = (writeregsel == 4) & write;
	assign wri[5] = (writeregsel == 5) & write;
	assign wri[6] = (writeregsel == 6) & write;
	assign wri[7] = (writeregsel == 7) & write;
   
	Register Reg0(.clk(clk), .rst(rst), .write(wri[0]), .wdata(writedata), .rdata(regOut[0]));
	Register Reg1(.clk(clk), .rst(rst), .write(wri[1]), .wdata(writedata), .rdata(regOut[1]));
	Register Reg2(.clk(clk), .rst(rst), .write(wri[2]), .wdata(writedata), .rdata(regOut[2]));
	Register Reg3(.clk(clk), .rst(rst), .write(wri[3]), .wdata(writedata), .rdata(regOut[3]));
	Register Reg4(.clk(clk), .rst(rst), .write(wri[4]), .wdata(writedata), .rdata(regOut[4]));
	Register Reg5(.clk(clk), .rst(rst), .write(wri[5]), .wdata(writedata), .rdata(regOut[5]));
	Register Reg6(.clk(clk), .rst(rst), .write(wri[6]), .wdata(writedata), .rdata(regOut[6]));
	Register Reg7(.clk(clk), .rst(rst), .write(wri[7]), .wdata(writedata), .rdata(regOut[7]));
	
	assign read1data = read1regsel[2] ? (read1regsel[1] ? (read1regsel[0] ? regOut[7] : regOut[6]) : (read1regsel[0] ? regOut[5] : regOut[4])) : (read1regsel[1] ? (read1regsel[0] ? regOut[3]: regOut[2]) : (read1regsel[0] ? regOut[1] : regOut[0]));
	
	assign read2data = read2regsel[2] ? (read2regsel[1] ? (read2regsel[0] ? regOut[7] : regOut[6]) : (read2regsel[0] ? regOut[5] : regOut[4])) : (read2regsel[1] ? (read2regsel[0] ? regOut[3]: regOut[2]) : (read2regsel[0] ? regOut[1] : regOut[0]));

endmodule
// DUMMY LINE FOR REV CONTROL :1:
