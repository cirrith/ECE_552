/********************************************************************************************************
/		MODULE: Register_File
/		PURPOSE: Contains 8 16-bit registers, two of which can be read from in a single cycle and one which
/		can be written too. 
/
/
/		INPUTS: clk - Clock
/				rst - Reset
/				Reg_1_Src [2:0] - Which register to read for output 1
/				Reg_2_Src [2:0] - Which register to read for output 2
/				Write_Reg [2:0] - Which register to write to when enabled
/				Write_Data [15:0] -  Data to write
/				Write - To write or not to write that is the question
/
/		OUTPUTS: 
/				Reg_1_Data [15:0] - Data from the 1st selected register
/				Reg_2_Data [15:0] - Data from the 2nd selected register
/
/		INTERNAL:
/				wri [7:0] - Which register should be written to
/				regOut [15:0] [0:7] - Outputs of all registers 
********************************************************************************************************/
module Register_File (clk, rst, Reg_1_Src, Reg_2_Src, Write_Reg, Write_Data, Write, Reg_1_Data, Reg_2_Data, err);

	parameter width = 16;
	
	input 			clk;
	input 			rst;
	input [2:0]		Reg_1_Src;
	input [2:0] 	Reg_2_Src;
	input [2:0] 	Write_Reg;
	input [15:0] 	Write_Data;
	input        	Write;

	output [15:0] 	Reg_1_Data;
	output [15:0] 	Reg_2_Data;
	output        	err;
   
	wire [7:0] wri;
	wire [15:0] regOut [0:7];
	
	assign wri[0] = (Write_Reg == 3'h0) & Write;
	assign wri[1] = (Write_Reg == 3'h1) & Write;
	assign wri[2] = (Write_Reg == 3'h2) & Write;
	assign wri[3] = (Write_Reg == 3'h3) & Write;
	assign wri[4] = (Write_Reg == 3'h4) & Write;
	assign wri[5] = (Write_Reg == 3'h5) & Write;
	assign wri[6] = (Write_Reg == 3'h6) & Write;
	assign wri[7] = (Write_Reg == 3'h7) & Write;
   
	Register Reg0(.clk(clk), .rst(rst), .write(wri[0]), .wdata(Write_Data), .rdata(regOut[0]));
	Register Reg1(.clk(clk), .rst(rst), .write(wri[1]), .wdata(Write_Data), .rdata(regOut[1]));
	Register Reg2(.clk(clk), .rst(rst), .write(wri[2]), .wdata(Write_Data), .rdata(regOut[2]));
	Register Reg3(.clk(clk), .rst(rst), .write(wri[3]), .wdata(Write_Data), .rdata(regOut[3]));
	Register Reg4(.clk(clk), .rst(rst), .write(wri[4]), .wdata(Write_Data), .rdata(regOut[4]));
	Register Reg5(.clk(clk), .rst(rst), .write(wri[5]), .wdata(Write_Data), .rdata(regOut[5]));
	Register Reg6(.clk(clk), .rst(rst), .write(wri[6]), .wdata(Write_Data), .rdata(regOut[6]));
	Register Reg7(.clk(clk), .rst(rst), .write(wri[7]), .wdata(Write_Data), .rdata(regOut[7]));
	
	assign Reg_1_Data = Reg_1_Src[2] ? (Reg_1_Src[1] ? (Reg_1_Src[0] ? regOut[7] : regOut[6]) : (Reg_1_Src[0] ? regOut[5] : regOut[4])) : (Reg_1_Src[1] ? (Reg_1_Src[0] ? regOut[3]: regOut[2]) : (Reg_1_Src[0] ? regOut[1] : regOut[0]));
	
	assign Reg_2_Data = Reg_2_Src[2] ? (Reg_2_Src[1] ? (Reg_2_Src[0] ? regOut[7] : regOut[6]) : (Reg_2_Src[0] ? regOut[5] : regOut[4])) : (Reg_2_Src[1] ? (Reg_2_Src[0] ? regOut[3]: regOut[2]) : (Reg_2_Src[0] ? regOut[1] : regOut[0]));

endmodule