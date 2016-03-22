/********************************************************************************************************
/		MODULE: Fetch
/		PURPOSE: First pipeline section of processor, get instruction from instruction memory
/
/		INPUTS: clk - Clock
/				rst - Reset
/				Stall - To Continue or not
/					0 = Write PC2
/					1 = Don't write PC
/				PC_Ex[15:0] - PC in a jump or branch
/				PC_Sel - PC Mode
/					0 - PC + 2
/					1 - PC = PC_Ex				
/				
/		OUTPUTS: Instruction[15:0] - Instruction to be moved through the pipeline
/				 PC2[15:0] - Current PC + 2
********************************************************************************************************/
module Fetch(clk, rst, Stall, PC_Ex, PC_Sel, Instruction, PC2);

	input clk;
	input rst;
	input Stall;
	
	input [15:0] PC_Ex;
	input PC_Sel;
	
	output [15:0] Instruction;
	output [15:0] PC2

	wire [15:0] PC;
	wire [15:0] PC2;

	memory2c Instruction Memory(.data_out(Instruction), .data_in(), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

	PC_inc pc_inc(.PC(PC), .PC2(PC2));
	
	PC program_counter (.clk(clk), .rst(rst), .PC(PC), .PC2(PC2), .PC_Ex(PC_Ex), .PC_Sel(PC_Sel), .Stall(Stall));

endmodule