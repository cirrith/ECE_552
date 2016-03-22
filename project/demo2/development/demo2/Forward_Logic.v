/********************************************************************************************************
/		MODULE: Forward_Logic
/		PURPOSE: Given the state of register reads and writes determine if any data needs to be forwarded
/
/		INPUTS: 
/
/		OUTPUTS: Branch - To branch or not, that is the question
********************************************************************************************************/
If ALU should source the forward lines or not
	
	wire [15:0] A_Forward_Data
	wire [15:0] B_Forward_Data
	
	Reg_1_Src
	Reg_2_Src
	
	Write_Reg_Mem
	Reg_Write_Mem
	
	Write_Reg_WB
	Reg_Write_WB
	
	wire A_Forward;
	wire B_Forward; 