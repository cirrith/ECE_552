/********************************************************************************************************
/		MODULE: Forward_Logic
/		PURPOSE: Given the state of register reads and writes determine if any data needs to be forwarded
/			FORWARD WHEN: Doesn't matter if a register/immediate operation, execute will use right one no matter what
/				One of the source registers matches the write register in the Memory Stage
/					Only if Reg_Write is true
/				One of the source registers matches the write register in the Writeback Stage
/					Only if Reg_Write is true
/				Memory stage should take priority b/c if the previous instruction (the one in Memory) had to have
/					forwarding it will be the most update value
/		INPUTS: 
/				Reg_1_Src [2:0] - Data being used in Execute Stage
/				Reg_2_Src [2:0] - Date that mgiht be used in Execute Stage (Could be immediate instruciton, don't care)
/				Write_Reg_Mem [2:0] - Register to be written to, if it writes
/				Write_Reg_WB [2:0] - Register to be written to, if it writes
/				Reg_Write_Mem - Whether instruction in Memory stage is writing back to register file
/				Reg_Write_WB - Whether instruciton in  Writeback stage is writing back to register file
/				ALU_Result_Mem [15:0] - Data to write from Memory stage, only valid data in that stage
/				WB [15:0] - Data to write from Writeback stage, preselected
/
/		OUTPUTS: 
/				A_Forward - To forward or not
/				B_Forward - To forward or not
/				Forward_Mem - For stall logic, whether there is forwarding from memory or not
/				A_Forward_Data [15:0] - Data to use instead
/				B_Forward_Data [15:0] - Data to use instead
/
/		INTERNAL:
/				A_Forward_Mem - Forward to A from Memory
/				B_Forward_Mem - Forward to B from Memory
/				A_Forward_WB - Forward to A from Writeback
/				B_Forward_WB - Forward to B from Writeback
********************************************************************************************************/
module Forward_Logic(Reg_1_Src, Reg_2_Src, Write_Reg_Mem, Write_Reg_WB, Reg_Write_Mem, Reg_Write_WB, ALU_Result_Mem, WB, A_Forward, B_Forward, Forward_Mem, A_Forward_Data, B_Forward_Data);
	
	input [2:0] 	Reg_1_Src;
	input [2:0] 	Reg_2_Src;
	
	input [2:0] 	Write_Reg_Mem;
	input [2:0] 	Write_Reg_WB;
	
	input 			Reg_Write_Mem;
	input 			Reg_Write_WB;
	
	input [15:0] 	ALU_Result_Mem;
	input [15:0] 	WB;
	
	output 			A_Forward;
	output 			B_Forward;
	output			Forward_Mem;
	
	output [15:0] 	A_Forward_Data;
	output [15:0] 	B_Forward_Data;	

	wire A_Forward_Mem;
	wire B_Forward_Mem;
	
	wire A_Forward_WB;
	wire B_Forward_WB;
	
	assign Forward_Mem = A_Forward_Mem | B_Forward_Mem;
	
	assign A_Forward_Mem = (Reg_1_Src == Write_Reg_Mem) & Reg_Write_Mem;
	assign B_Forward_Mem = (Reg_2_Src == Write_Reg_Mem) & Reg_Write_Mem;
	
	assign A_Forward_WB = (Reg_1_Src == Write_Reg_WB) & Reg_Write_WB;
	assign B_Forward_WB = (Reg_2_Src == Write_Reg_WB) & Reg_Write_WB;
	
	assign A_Forward = A_Forward_Mem | A_Forward_WB; //If either is writing back then ...
	assign B_Forward = B_Forward_Mem | B_Forward_WB; //If either is writing back then ...
	
	assign A_Forward_Data = A_Forward_Mem ? ALU_Result_Mem : WB; //If instruction is using data from load use WB data else Writing back from Memory use ALU_Result_Mem else use WB
	assign B_Forward_Data = B_Forward_Mem ? ALU_Result_Mem : WB; //If Writing back from Memory use ALU_Result_Mem else use WB
	
endmodule

//Should be good 3/24