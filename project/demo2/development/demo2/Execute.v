/********************************************************************************************************
/		MODULE: Execute
/		PURPOSE: Given all the possible inputs to the alu and the corresponding control signals perform
/				the command.
/
/		INPUTS: Reg_1_Data[15:0] - Data to operate with
/				Reg_2_Data[15:0] - Data to operate with
/				Reg_1_Src[2:0] - For forwarding unit
/				Reg_2_Src[2:0] - For forwarding unit
/				Immediate[15:0] - Data to operate with
/				PC2[15:0] - PC + 2
/				OP_Code[3:0] - Determine what operation the ALU is doing
/				Pass_Thr_Sel - Which Src to pass through when pass through is selected
/					0 = Pass through A
/					1 = Pass through B
/				ALU_B_Src_Dec - Revamp of Src select system
/					0 = Register Source (Forwarding will determine from where)
/					1 = Immediate Source (Already determined in Decode Stage)
/				Comp_Code [1:0] - Comparison Codes
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				PC_Code - Determine how the jump/branch PC is calculated
/					0 - Jump/Branch (PC + 2 + Immediate)
/					1 - Jump (RS + Immediate)
/				Write_Reg_Mem[2:0] - Register Number that the instruction in Memory stage is writing too
/				Reg_Write_Mem - If the Instruction in the Memory stage is going to write or not
/				Write_Reg_WB[2:0] - Register Number that the instruction in WriteBack stage is writing too
/				Reg_Write_WB - If the Instruciton in the Writeback stage is going to write or not
/
/		OUTPUTS: ALU_Result[15:0] - Result of ALU
/				 PC_Ex[15:0] - Program Counter External
/				 Branch - If Branch operation whether to branch or not
********************************************************************************************************/
module Execute();

	input [1:0] Comp_Code;
	input [3:0] OP_Code;
	input Pass_Thr_Sel;
	input [15:0] Reg_1_Data;
	input [15:0] Reg_2_Data;
	input [2:0] Reg_1_Src;
	input [2:0] Reg_2_Src;
	input [2:0] Write_Reg_Mem;
	input Reg_Write_Mem;
	input [2:0] Write_Reg_WB;
	input Reg_Write_WB;
	input [15:0] Immediate;
	input PC_Code;
	input [15:0] PC2;
	
	output [15:0] ALU_Result;
	output Branch;
	output [15:0] PC_Ex;

	wire [15:0] A_in;
	wire [15:0] B_in;
	wire A_Forward;
	wire B_Forward; 
	wire Branch
	
	assign A_in = A_Forward ? A_Forward_Data : Reg_1_Data; //TODO: Create Mux for this?
	assign B_in = ALU_B_Src ? Immediate : (B_Forward ? B_Forward_Data : Reg_2_Data);
	
	ALU alu (.A(A_in), .B(B_in), .OP_Code(OP_Code), .Result(ALU_Result), .LT(LT), .EQ(EQ), .Pass_Thr_Sel(Pass_Thr_Sel));
	
	Branch_Logic BL (.Comp_Code(Comp_Code), .ZF(ZF), .LT(LT), .Branch(Branch));
	
	PC_Logic PC_Logic (.PC_Code(PC_Code), .Reg_1_Data(Reg_1_Data), .Immediate(Immediate), .PC2(PC2), .PC_Ex(PC_Ex));
	
	Forwarding //TODO

endmodule