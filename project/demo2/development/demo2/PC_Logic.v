/********************************************************************************************************
/		MODULE: PC_Logic
/		PURPOSE: Given the a PC code from the processor controller determine what signals to output to get
/			the correct next PC
/
/		INPUTS:	PC_Code - Determine how the jump/branch PC is calculated
/					0 - Jump/Branch (PC + 2 + Immediate)
/					1 - Jump (RS + Immediate)
/				Reg_1_Data[15:0] - Reg_1_Data
/				Immediate[15:0] - Immediate for calculations
/				PC2[15:0] - PC + 2
/
/		OUTPUTS: PC_Ex[15:0] - External PC to write back to Fetch Stage
/				 
********************************************************************************************************/
module PC_Logic (PC_Code, Reg_1_Data, Immediate, PC2, PC_Ex);

	input PC_Code;
	input [15:0] Reg_1_Data;
	input [15:0] Immediate;
	input [15:0] PC2;

	output [15:0] PC_Ex;

	wire [15:0] A_in;

	assign A_in = PC_Code ? Reg_1_Data : PC2;
	
	CLA adder(.A(A_in), .B(Immediate), .Ci(1'b0), .S(PC_Ex), .Cout());

endmodule



