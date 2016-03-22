/********************************************************************************************************
/		MODULE: Decode
/		PURPOSE: Take in the instruction and create control signals and deal with the register. AHHH COMPLEXA
/
/		INPUTS: clk - Clock
/				rst - Reset
/				Stall - Don't do anything this instruction **I think this should be here b/c we don't want to write bad to reg** Maybe if we want WB to contineu this should be seperate
/				Instruction[15:0] - Well if you don't know what this is, you are kinda screwed. Gonna be honest
/				PC2[15:0] - PC + 2
/				Write_Reg_In[2:0] - Register to write to (Writeback)
/				Write_Data[15:0] - Data to write
/				Reg_Write_In - To write or not to write				
/
/		OUTPUTS: 
/				 PC2[15:0] - Must be passed to keep everything working. Only needed on Jump and link (Uses PC + 2 & Immediate)
********************************************************************************************************/
module Decode();

	input clk;
	input rst;
	input Stall;
	input [15:0] Instruction;
	input [15:0] PC2;
	input [2:0] Write_Reg_In;
	input [15:0] Write_Data;
	input Reg_Write_In;
	
	output Write_Reg_Out;
	output ALU_B_Src;
	output [3:0] ALU_OP_Code;
	output [1:0] Comp_Code;
	output [15:0] Immediate;
	output Pass_Thr_Sel;
	output [15:0] PC2;
	output [15:0] Reg_1_Data;
	output [15:0] Reg_2_Data;
	output [2:0] Reg_1_Src;
	output [2:0] Reg_2_Src;
	output [1:0] Mem_Data;
	output Reg_Write_Out;

	wire [1:0] Write_Reg_Sel;

Data Hazard
						Register File
						Register File Input
						Extender
Control
	
	//Waiting to get rest set before doing Processor Control - Complex
	
	Register_File_Input Write_Determin(.Poss_Des(Instruction[10:2]), .Write_Reg_Sel(Write_Reg_Sel), .Write_Reg(Write_Reg));
	
	Imm_Selecter Imm (.Extend(Instruction[10:0]), .Imm_Sel(Imm_Sel), .PC2(PC2), .Immediate(Immediate));
	
	Register_File RF (.clk(clk), .rst(rst), .Reg_1_Src(Instruction[10:8]), .Reg_2_Src(Instruction[7:5]), .Write_Reg(Write_Reg_In), .Write_Data(Write_Data), .Write(Reg_Write_In), .Reg_1_Data(Reg_1_Data), .Reg_2_Data(Reg_2_Data), .err());
	
	
endmodule