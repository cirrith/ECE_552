/********************************************************************************************************
/		MODULE: Decode-Execute_Blade
/		PURPOSE: Pipeline blade between Decode and Execute stages
/
/		INPUTS: Sorted by stage consumed
/			clk - Clock
/			rst - Reset
/			Flush - Clear all the values
/			Stall - Keep all values, don't load new ones
/
/			Execute:
/				ALU_B_Src_Dec -
/					0 = Register Source (Forwarding will determine from where)
/					1 = Immediate Source (Already determined in Decode Stage)
/				ALU_OP_Code_Dec[3:0] - See ALU for operations
/				Comp_Code_Dec[1:0] - Which comparison requires a branch
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				Immediate_Dec[15:0] - Immediate to be used in an immediate instruction
/				Pass_Thr_Sel_Dec - Which Src to pass through when pass through is selected
/					0 = Pass through A
/					1 = Pass through B
/				PC_Code_Dec[1:0] - Determine how the jump/branch PC is calculated
/					00 - Standard Operation
/					01 - Jump (Rs + Immediate)
/					10 - Branch (PC + 2 + Immediate)
/					11 - Jump (PC + 2 + Immediate)
/				PC2_Dec[15:0] - PC + 2 (Used in Jump instructions)(R7 <- PC + 2 is handled in immediate)
/				Reg_1_Data_Dec[15:0] - Value 1 read from register file
/				*Reg_2_Data_Dec[15:0] - Value 2 read from register file
/				Reg_1_Src_Dec[2:0] - Register that was read from, used in forwarding
/				Reg_2_Src_Dec[2:0] - Register that was read from, used in forwarding
/					
/			Memory:	
/				Mem_Write_Dec - Memory Write
/				Mem_Read_Dec - Memory Read
/				*Reg_2_Data_Dec[15:0] - Value 2 read from register file - Write to memory
/				createdump_Dec - Dump Memory
/				
/			WriteBack:
/				Reg_Write_Dec - To write or not
/				WB_Sel_Dec - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Dec[2:0] - Which register to write to, pre-calculated
/				halt_Dec - A halt command was passed through
/					0 - No halt
/					1 - Yes halt		
/
/		OUTPUTS: Sorted by stage consumed
/			Execute:
/				ALU_B_Src_Exe -
/					0 = Register Source (Forwarding will determine from where)
/					1 = Immediate Source (Already determined in Decode Stage)
/				ALU_OP_Code_Exe[3:0] - See ALU for operations
/				Comp_Code_Exe[1:0] - Which comparison requires a branch
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				Immediate_Exe[15:0] - Immediate to be used in an immediate instruction
/				Pass_Thr_Sel_Exe - Which Src to pass through when pass through is selected
/					0 = Pass through A
/					1 = Pass through B
/				PC_Code[1:0] - Determine how the jump/branch PC is calculated
/					00 - Standard Operation
/					01 - Jump (Rs + Immediate)
/					10 - Branch (PC + 2 + Immediate)
/					11 - Jump (PC + 2 + Immediate)
/				PC2_Exe[15:0] - PC + 2 (Used in Jump instructions)(R7 <- PC + 2 is handled in immediate)
/				Reg_1_Data_Exe[15:0] - Value 1 read from register file
/				*Reg_2_Data_Exe[15:0] - Value 2 read from register file
/				Reg_1_Src_Exe[2:0] - Register that was read from
/				Reg_2_Src_Exe[2:0] - Register that was read from
/					
/			Memory:	
/				Mem_Write_Exe - Memory Write
/				Mem_Read_Exe - Memory Read
/				*Reg_2_Data_Exe[15:0] - Value 2 read from register file
/				createdump_Exe - Dump Memory
/				
/			WriteBack:
/				Reg_Write_Exe - To write or not
/				WB_Sel_Exe - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Exe[2:0] - Which register to write to, pre-calculated
/				halt_Exe - A halt command was passed through
/					0 - No halt
/					1 - Yes halt			
/
/		Yea this complex
********************************************************************************************************/
module Decode-Execute_Blade (clk, rst, Flush, Stall, ALU_B_Src_Dec, ALU_OP_Code_Dec, Comp_Code_Dec, Immediate_Dec, Pass_Thr_Sel_Dec, PC_Code_Dec, PC2_Dec, Reg_1_Data_Dec, Reg_2_Data_Dec, Reg_1_Src_Dec, Reg_2_Src_Dec, Mem_Write_Dec, Mem_Read_Dec, createdump_Dec, Reg_Write_Dec, WB_Sel_Dec, Write_Reg_Dec, halt_Dec, ALU_B_Src_Exe, ALU_OP_Code_Exe, Comp_Code_Exe, Immediate_Exe, Pass_Thr_Sel_Exe, PC_Code_Exe, PC2_Exe, Reg_1_Data_Exe, Reg_2_Data_Exe, Reg_1_Src_Exe, Reg_2_Src_Exe, Mem_Write_Exe, Mem_Read_Exe, createdump_Exe, Reg_Write_Exe, WB_Sel_Exe, Write_Reg_Exe, halt_Exe);

	input clk;
	input rst;
	input Flush;
	input Stall;

//Execute
	input 			ALU_B_Src_Dec;
	input [3:0] 	ALU_OP_Code_Dec;
	input [1:0] 	Comp_Code_Dec;
	input [15:0] 	Immediate_Dec;
	input 			Pass_Thr_Sel_Dec;
	input [1:0]		PC_Code_Dec;
	input [15:0] 	PC2_Dec;
	input [15:0] 	Reg_1_Data_Dec;
	input [2:0] 	Reg_1_Src_Dec;
	input [2:0] 	Reg_2_Src_Dec;

//Memory
	input 			Mem_Write_Dec;
	input 			Mem_Read_Dec;
	input [15:0] 	Reg_2_Data_Dec;
	input			createdump_Dec;
	
//WriteBack
	input 			Reg_Write_Dec;
	input 			WB_Sel_Dec;
	input [2:0] 	Write_Reg_Dec;
	input 			halt_Dec;

//Execute
	output 			ALU_B_Src_Exe;
	output [3:0]	 ALU_OP_Code_Exe;
	output [1:0] 	Comp_Code_Exe;
	output [15:0] 	Immediate_Exe;
	output 			Pass_Thr_Sel_Exe;
	output [1:0]	PC_Code_Exe;
	output [15:0] 	PC2_Exe;
	output [15:0]	Reg_1_Data_Exe;
	output [2:0] 	Reg_1_Src_Exe;
	output [2:0] 	Reg_2_Src_Exe;
	
//Memory
	output 			Mem_Write_Exe;
	output 			Mem_Read_Exe;
	output [15:0]	Reg_2_Data_Exe;
	output			createdump_Exe;
	
//WriteBack
	output 			Reg_Write_Exe;
	output 			WB_Sel_Exe;
	output [2:0] 	Write_Reg_Exe;	
	output 			halt_Exe;

//Execute
	dff_pipe alu_b_src 			(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(ALU_B_Src_Dec), 	.q(ALU_B_Src_Exe));
	dff_pipe alu_op_code [3:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(ALU_OP_Code_Dec),	.q(ALU_OP_Code_Exe));
	dff_pipe comp_code [1:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Comp_Code_Dec),		.q(Comp_Code_Exe));
	dff_pipe immediate [15:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Immediate_Dec),		.q(Immediate_Exe));
	dff_pipe pass_thr_sel 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Pass_Thr_Sel_Dec), 	.q(Pass_Thr_Sel_Exe));
	dff_pipe pc_code [1:0]	 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(PC_Code_Dec),		.q(PC_Code_Exe));
	dff_pipe pc2 [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(PC2_Dec), 			.q(PC2_Exe));
	dff_pipe reg_1_data [15:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_1_Data_Dec),	.q(Reg_1_Data_Exe));
	dff_pipe reg_1_src [2:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_1_Src_Dec),		.q(Reg_1_Src_Exe));
	dff_pipe reg_2_src [2:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_2_Src_Dec),		.q(Reg_2_Src_Exe));
	
//Memory
	dff_pipe mem_write 			(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Write_Dec), 	.q(Mem_Write_Exe));
	dff_pipe mem_read 			(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Read_Dec), 		.q(Mem_Read_Exe));
	dff_pipe reg_2_data [15:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_2_Data_Dec),	.q(Reg_2_Data_Exe));
	dff_pipe createdump		 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(createdump_Dec),	.q(createdump_Exe));
	
//WriteBack
	dff_pipe reg_write 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_Write_Dec), 	.q(Reg_Write_Exe));
	dff_pipe wb_sel 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(WB_Sel_Dec), 		.q(WB_Sel_Exe));
	dff_pipe write_reg [2:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Write_Reg_Dec), 	.q(Write_Reg_Exe));
	dff_pipe halt				 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(halt_Dec), 			.q(halt_Exe));
	
endmodule