/********************************************************************************************************
/		MODULE: Decode
/		PURPOSE: Take in the instruction and create control signals and deal with the register. AHHH COMPLEXA
/
/		INPUTS: 
/					clk - Clock
/					rst - Reset
/					***Stall - Don't do anything this instruction **I think this should be here b/c we don't want to write bad to reg** Maybe if we want WB to continue this should be seperate
/					Instruction[15:0] - Well if you don't know what this is, you are kinda screwed. Gonna be honest (Fetch)
/					PC2[15:0] - PC + 2 (Fetch)
/					Write_Reg_In[2:0] - Register to write to (Writeback)
/					Write_Data[15:0] - Data to write
/					Reg_Write_In - To write or not to write
/					*Branch_Forward - Whether the branch logic should use the register file or the forwarded data
/					*Reg_Forward_Data [15:0] - Data from memory stage for branch logic
/
/		OUTPUTS:
/					Reg_1_Data [15:0] - Data read from Reg_1_Src
/					Reg_2_Data [15:0] - Data read from Reg_2_Src
/					Reg_1_Src [2:0] - Register read from
/					Reg_2_Src [2:0] - Register read from
/					Immediate [15:0] - Selected Extended Immediate
/					Write_Reg_Out [2:0] - Register to Write back to on WB
/					Reg_Write_Out - Whether to write to the register in WB
/					ALU_OP_Code [3:0] - Operation to be performed
/					Pass_Thr_Sel - Which Src to pass through when pass through is selected
/						0 = Pass through A
/						1 = Pass through B
/					ALU_B_Src -
/						0 = Register Source (Forwarding will determine from where)
/						1 = Immediate Source (Already determined in Decode Stage)

/					Mem_Write - Write to memory or not
/					Mem_Read - Read from memory or not
/					WB_Sel - Write back select
/						0 - ALU
/						1 - Memory
/					PC_Code[1:0] - Determine how the jump/branch PC is calculated
/						00 - Standard Operation
/						01 - Jump (Rs + Immediate)
/						10 - Branch (PC + 2 + Immediate)
/						11 - Jump (PC + 2 + Immediate)
/					createdump - Dump Data memory
/					halt - Stop
/
/		INTERNAL:
/					Write_Reg_Sel [1:0] - Which Register is written to on writeback
/						00 - Rd (Immediate) [7:5]
/						01 - Rd (Register) [4:2]
/						10 - Rs [10:8]
/						11 - R7	
/					Imm_Sel[1:0] - Select bits for output
/						00 - 5 Bit Sign Extended
/						01 - 5 Bit Zero Extended
/						10 - 8 Bit Sign Extended
/						11 - 11 Bit Sign Extended
/					PC_Ex[15:0] - Program Counter External
/					PC_Sel - PC modes
/						0 = Standard: PC = PC + 2
/						1 = Jump or Branch: PC = PC_Ex
/					Comp_Code [1:0] - Comparison Codes
/						00 - Equal
/						01 - Not Equal
/						10 - Less Than
/						11 - Greater Than or Equal
********************************************************************************************************/
module Decode (clk, rst, Instruction, PC2, Write_Reg_In, Write_Data, Reg_Write_In, PC_Det_Forward, PC_Det_Forward_Data, PC_Ex, PC_Code, PC_Sel, Reg_1_Data, Reg_2_Data, Reg_1_Src, Reg_2_Src, Immediate, Check_A, Check_B, Write_Reg_Out, Reg_Write_Out, ALU_OP_Code, Pass_Thr_Sel, ALU_B_Src, Mem_Write, Mem_Read, WB_Sel, createdump, halt);

	input 				clk;
	input 				rst;
	input [15:0] 		Instruction;
	input [15:0] 		PC2;
	input [2:0] 		Write_Reg_In;
	input [15:0] 		Write_Data;
	input 				Reg_Write_In;
	input				PC_Det_Forward;
	input [15:0] 		PC_Det_Forward_Data;
	
	output [15:0]	PC_Ex;
	output [1:0]	PC_Code;
	output			PC_Sel;
	output [15:0] 	Reg_1_Data;
	output [15:0] 	Reg_2_Data;
	output [2:0] 	Reg_1_Src;
	output [2:0] 	Reg_2_Src;
	output [15:0] 	Immediate;
	output			Check_A;
	output			Check_B;
	output [2:0] 	Write_Reg_Out;
	output 			Reg_Write_Out;
	output [3:0] 	ALU_OP_Code;
	output 			Pass_Thr_Sel;
	output 			ALU_B_Src;
	output		 	Mem_Write;
	output 			Mem_Read;
	output 			WB_Sel;
	output 			createdump;
	output 			halt;
	
	wire [1:0] Write_Reg_Sel;
	wire [1:0] Imm_Sel;
	wire [1:0] Comp_Code;
	
	assign Reg_1_Src = Instruction[10:8];
	assign Reg_2_Src = Instruction[7:5];
	
	Processor_Control Control(
			.OP_Code		(Instruction[15:11]), 
			.OP_Min			(Instruction[1:0]), 
			.Reg_Write		(Reg_Write_Out), 
			.PC_Code		(PC_Code), 
			.Comp_Code		(Comp_Code), 
			.ALU_OP_Code	(ALU_OP_Code), 
			.ALU_B_Src		(ALU_B_Src), 
			.Pass_Thr_Sel	(Pass_Thr_Sel),
			.Imm_Sel		(Imm_Sel),
			.Check_A		(Check_A),
			.Check_B		(Check_B),
			.Mem_Read		(Mem_Read), 
			.Mem_Write		(Mem_Write), 
			.WB_Sel			(WB_Sel), 
			.createdump		(createdump), 
			.halt			(halt), 
			.Write_Reg_Sel	(Write_Reg_Sel));
	
	Register_File_Input Write_Determine(
			.Poss_Des		(Instruction[10:2]), 
			.Write_Reg_Sel	(Write_Reg_Sel), 
			.Write_Reg		(Write_Reg_Out));
	
	Imm_Selecter Imm (
			.Extend			(Instruction[10:0]), 
			.Imm_Sel		(Imm_Sel), 
			.Immediate		(Immediate));
	
	Register_File_Bypass RFB (
			.clk			(clk), 
			.rst			(rst), 
			.Reg_1_Src		(Reg_1_Src), 
			.Reg_2_Src		(Reg_2_Src), 
			.Write_Reg		(Write_Reg_In), 
			.Write_Data		(Write_Data), 
			.Write			(Reg_Write_In), 
			.Reg_1_Data		(Reg_1_Data), 
			.Reg_2_Data		(Reg_2_Data), 
			.err			());
			
	PC_Logic pc_logic (
			.PC_Code			(PC_Code), 
			.Reg_1_Data			(Reg_1_Data), 
			.Immediate			(Immediate), 
			.PC2				(PC2),
			.Comp_Code			(Comp_Code),
			.PC_Det_Forward		(PC_Det_Forward),
			.PC_Det_Forward_Data(PC_Det_Forward_Data),
			.PC_Ex				(PC_Ex), 
			.PC_Sel				(PC_Sel));
endmodule

//Waiting for rest check before check