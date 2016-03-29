/********************************************************************************************************
/		MODULE: Write_Back
/		PURPOSE: Given the possible things to writeback into the register file and a select line choose 
/				between them.
/
/		INPUTS: 
/				ALU_Result [15:0] - Output from ALU_Result
/				Mem_Data [15:0] - Output from a memory read
/				Sel - Which input to choose from
/					0 - ALU
/					1 - Memory
/
/		OUTPUTS: 
/				WB [15:0] - What to write back
********************************************************************************************************/
module Write_Back (ALU_Result, Mem_Data, Sel, WB);

	input [15:0] 	ALU_Result;
	input [15:0] 	Mem_Data;
	input 			Sel;

	output [15:0] 	WB;

	assign WB = Sel ? Mem_Data : ALU_Result;

endmodule

//Checked 3/22