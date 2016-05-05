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
/				A_Forward - Whether A should pull its register from Blade or forward unit
/				B_Forward - Whether A should pull its register from Blade or forward unit
/				A_Forward_Data [15:0] - Data that should be used in a forward operation
/				B_Forward_Data [15:0] - Data that hsould be used in a forward operation
/
/		OUTPUTS: 
/				ALU_Result[15:0] - Result of ALU
/				Reg_2_Data_For [15:0] - Data for register 2 read w/ forwarding
/
/		INTERNAL:
/				A_in [15:0] - What gets put into the A source of ALU
/				B_in [15:0] - What gets put into the B source of ALU
********************************************************************************************************/
module Execute (ALU_B_Src, ALU_OP_Code, Pass_Thr_Sel, Reg_1_Data, Reg_2_Data, Reg_1_Src, Reg_2_Src, Immediate, PC2, A_Forward, B_Forward, A_Forward_Data, B_Forward_Data, ALU_Result, Reg_2_Data_For);

	input 				ALU_B_Src;
	input [3:0] 		ALU_OP_Code;
	input 				Pass_Thr_Sel;
	input [15:0] 		Reg_1_Data;
	input [15:0] 		Reg_2_Data;
	input [2:0] 		Reg_1_Src;
	input [2:0] 		Reg_2_Src;
	input [15:0] 		Immediate;
	input [15:0] 		PC2;
	input 				A_Forward;
	input 				B_Forward;
	input [15:0] 		A_Forward_Data;
	input [15:0] 		B_Forward_Data;

	output [15:0] 		ALU_Result;
	output [15:0]		Reg_2_Data_For;

	wire [15:0] A_in;
	wire [15:0] B_in;

	assign A_in = A_Forward ? A_Forward_Data : Reg_1_Data; //TODO: Create Mux for this?
	assign B_in = ALU_B_Src ? Immediate : (B_Forward ? B_Forward_Data : Reg_2_Data);
	
	ALU alu (
			.A				(A_in), 
			.B				(B_in), 
			.OP_Code		(ALU_OP_Code), 
			.PC2			(PC2), 
			.Result			(ALU_Result), 
			.Pass_Thr_Sel 	(Pass_Thr_Sel));
	
	assign Reg_2_Data_For = B_Forward ? B_Forward_Data : Reg_2_Data;
	
endmodule