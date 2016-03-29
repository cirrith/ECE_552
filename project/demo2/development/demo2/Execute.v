/********************************************************************************************************
/		MODULE: Execute
/		PURPOSE: Given all the possible inputs to the alu and the corresponding control signals perform
/				the command.
/
/		INPUTS: 
/				Reg_1_Data[15:0] - Data to operate with (Decode)
/				Reg_2_Data[15:0] - Data to operate with (Decode)
/				Immediate[15:0] - Data to operate with (Decode)
/				PC2[15:0] - PC + 2 (Decode)
/				ALU_OP_Code[3:0] - Determine what operation the ALU is doing (Decode)
/				Pass_Thr_Sel - Which Src to pass through when pass through is selected (Decode)
/					0 = Pass through A
/					1 = Pass through B
/				ALU_B_Src - Revamp of Src select system (Decode)
/					0 = Register Source (Forwarding will determine from where)
/					1 = Immediate Source (Already determined in Decode Stage)
/				Comp_Code [1:0] - Comparison Codes (Decode)
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				PC_Code[1:0] - Determine how the jump/branch PC is calculated (Decode)
/					00 - Standard Operation
/					01 - Jump (Rs + Immediate)
/					10 - Branch (PC + 2 + Immediate)
/					11 - Jump (PC + 2 + Immediate)
/				A_Forward - Whether A should pull its register from Blade or forward unit
/				B_Forward - Whether A should pull its register from Blade or forward unit
/				A_Forward_Data [15:0] - Data that should be used in a forward operation
/				B_Forward_Data [15:0] - Data that hsould be used in a forward operation
/
/		OUTPUTS: 
/				ALU_Result[15:0] - Result of ALU
/				PC_Ex[15:0] - Program Counter External
/				PC_Sel - PC modes
/					0 = Standard: PC = PC + 2
/					1 = Jump or Branch: PC = PC_Ex
/
/		INTERNAL:
/				A_in [15:0] - What gets put into the A source of ALU
/				B_in [15:0] - What gets put into the B source of ALU
********************************************************************************************************/
module Execute (ALU_B_Src, Comp_Code, ALU_OP_Code, Pass_Thr_Sel, Reg_1_Data, Reg_2_Data, Reg_1_Src, Reg_2_Src, Immediate, PC_Code, PC2, A_Forward, B_Forward, A_Forward_Data, B_Forward_Data, ALU_Result, PC_Ex, PC_Sel);

	input 			ALU_B_Src;
	input [1:0] 	Comp_Code;
	input [3:0] 	ALU_OP_Code;
	input 			Pass_Thr_Sel;
	input [15:0] 	Reg_1_Data;
	input [15:0] 	Reg_2_Data;
	input [2:0] 	Reg_1_Src;
	input [2:0] 	Reg_2_Src;
	input [15:0] 	Immediate;
	input [1:0]		PC_Code;
	input [15:0] 	PC2;
	input 			A_Forward;
	input 			B_Forward;
	input [15:0] 	A_Forward_Data;
	input [15:0] 	B_Forward_Data;

	output [15:0] 	ALU_Result;
	output [15:0] 	PC_Ex;
	output 				PC_Sel;

	wire [15:0] A_in;
	wire [15:0] B_in;
	
	assign A_in = A_Forward ? A_Forward_Data : Reg_1_Data; //TODO: Create Mux for this?
	assign B_in = ALU_B_Src ? Immediate : (B_Forward ? B_Forward_Data : Reg_2_Data);
	
	ALU alu (
			.A					(A_in), 
			.B					(B_in), 
			.OP_Code		(ALU_OP_Code), 
			.PC2				(PC2), 
			.Result			(ALU_Result), 
			.LT				(LT), 
			.EQ				(EQ), 
			.Pass_Thr_Sel (Pass_Thr_Sel));
	
	PC_Logic pc_logic (
			.PC_Code		(PC_Code), 
			.Reg_1_Data	(Reg_1_Data), 
			.Immediate	(Immediate), 
			.PC2				(PC2), 
			.PC_Ex			(PC_Ex), 
			.PC_Sel			(PC_Sel));

endmodule