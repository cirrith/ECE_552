/********************************************************************************************************
/		MODULE: Register_File_Bypass
/		PURPOSE: A modification of the register file that allows you to read the data that you are writing
/
/		INPUTS:
/				clk - Clock 
/				rst - Reset
/				Reg_1_Src [2:0] -	1st Register that is being read from
/				Reg_2_Src [2:0] - 2nd Register that is being read from
/				Write_Reg [2:0] - Register that is being written to
/				Write_Data [15:0] - Data that is being written
/				Write - To Write or not to Write that is the question
/
/		OUTPUTS:
/				Reg_1_Data [15:0] - Data that was read from register set by Reg_1_Src w/ bypass
/				Reg_2_Data [15:0] - Data taht was read from register set by Reg_2_Src w/ bypass
/				err - Basic white girl
/
/		INTERNAL:
/				Read_1_Out [15:0] - Data that was read from the selected register w/o bypass
/				Read_2_Out [15:0] - Data that was read from the selected register w/o bypass
********************************************************************************************************/
module Register_File_Bypass (Reg_1_Data, Reg_2_Data, err, clk, rst, Reg_1_Src, Reg_2_Src, Write_Reg, Write_Data, Write);
	input 			clk;
	input 			rst;
	input [2:0] 	Reg_1_Src;
	input [2:0] 	Reg_2_Src;
	input [2:0] 	Write_Reg;
	input [15:0] 	Write_Data;
	input        	Write;
	
	output [15:0] 	Reg_1_Data;
	output [15:0] 	Reg_2_Data;
	output        	err;
	
	wire [15:0] Read_1_Out;
	wire [15:0] Read_2_Out;
	
	Register_File RF(.Reg_1_Data(Read_1_Out), .Reg_2_Data(Read_2_Out), .err(err), .clk(clk), .rst(rst), .Reg_1_Src(Reg_1_Src), .Reg_2_Src(Reg_2_Src), .Write_Reg(Write_Reg), .Write_Data(Write_Data), .Write(Write));

	assign Reg_1_Data = Write ? (Write_Reg == Reg_1_Src ? Write_Data: Read_1_Out) : Read_1_Out;
	assign Reg_2_Data = Write ? (Write_Reg == Reg_2_Src ? Write_Data: Read_2_Out) : Read_2_Out;
	
endmodule
