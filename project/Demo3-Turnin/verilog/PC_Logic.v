/********************************************************************************************************
/		MODULE: PC_Logic
/		PURPOSE: Given the a PC code from the processor controller determine what signals to output to get
/			the correct next PC
/
/		INPUTS:	
/				PC_Code[1:0] - Determine how the jump/branch PC is calculated
/					00 - Standard Operation
/					01 - Jump (Rs + Immediate)
/					10 - Branch (PC + 2 + Immediate)
/					11 - Jump (PC + 2 + Immediate)
/				Reg_1_Data[15:0] - Reg_1_Data
/				Immediate[15:0] - Immediate for calculations
/				PC2[15:0] - PC + 2
/				Comp_Code [1:0] - Comparison Codes
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				PC_Forward - To use external data from register or not
/				PC_Forward_Data [15:0] - External forwarded data for branch
/
/		OUTPUTS: 
/				PC_Ex[15:0] - External PC to write back to Fetch Stage
/				 PC_Sel - PC modes
/					0 = Standard: PC = PC + 2
/					1 = Jump or Branch: PC = PC_Ex
/				 
/		INTERNAL:
/				A_in [15:0] - Which mode of PC determining we are in
/				Branch - Output from Branch determining logic
********************************************************************************************************/
module PC_Logic (PC_Code, Reg_1_Data, Immediate, PC2, Comp_Code, PC_Det_Forward, PC_Det_Forward_Data, PC_Ex, PC_Sel);

	input [1:0]		PC_Code;
	input [15:0] 	Reg_1_Data;
	input [15:0] 	Immediate;
	input [15:0] 	PC2;
	input [1:0]		Comp_Code;
	input 			PC_Det_Forward;
	input [15:0]	PC_Det_Forward_Data;
	
	output [15:0] 	PC_Ex;
	output 			PC_Sel;

	wire [15:0] A_in;
	wire Branch;

	assign A_in = PC_Code[1] ? PC2 : (PC_Det_Forward ? PC_Det_Forward_Data : Reg_1_Data);
	
	CLA adder(.A(A_in), .B(Immediate), .Ci(1'b0), .S(PC_Ex), .Cout());
	
	Branch_Logic BL(.Comp_Code(Comp_Code), .Reg_1_Data(Reg_1_Data), .PC_Det_Forward(PC_Det_Forward & (PC_Code == 2'h2)), .PC_Det_Forward_Data(PC_Det_Forward_Data), .Branch(Branch));
	
	assign PC_Sel = (PC_Code == 2'h0) ? 1'h0 : ((PC_Code == 2'h2) ? Branch : 1'h1);

endmodule

//Checked 3/22

/*
CHANGELOG
For Revamp, removed ZF and LT, added compare logic

*/