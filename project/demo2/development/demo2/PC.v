/********************************************************************************************************
/		MODULE: PC
/		PURPOSE: Store the Program Counter and defaultly store PC + 2, else when stall don't write anything,
/			else on select line write an external PC to the PC.
/
/		INPUTS: clk - Clock
/				rst - Reset
/				PC2 [15:0] - Standard PC increment
/				PC_Ex [15:0] - PC in a jump or branch
/				PC_Sel - PC modes
/					0 = Standard: PC = PC + 2
/					1 = Jump or Branch: PC = PC_Ex
/				Stall - To write or not to write
/
/		OUTPUTS: PC[15:0] - PC that is currently stored
********************************************************************************************************/
module PC (clk, rst, PC, PC2, PC_Ex, PC_Sel, Stall);
	
	input 			clk;
	input 			rst;
	input 			Stall;
	
	input [15:0] 	PC2;
	input [15:0] 	PC_Ex;
	input 			Write;

	output [15:0] 	PC;

	wire [15:0] PC_in;

	assign PC_in = Stall ? PC : (PC_Sel ? PC_Ex : PC2); //If stall: hold PC, else if Jump/Branch mode: PC = PC_Ex, else: PC = PC + 2
	
	dff program_counter [15:0] (.q(PC), .d(PC_in), .clk(clk), .rst(rst));

endmodule

//Checked 3/22/16