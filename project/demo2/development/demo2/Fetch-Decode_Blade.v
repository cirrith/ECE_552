/********************************************************************************************************
/		MODULE: Fetch-Decode_Blade
/		PURPOSE: Pipeline blade between Fetch and Decode stages
/
/		INPUTS: Sorted by stage of final consume
/				clk - Clock
/				rst - Reset
/				Flush - Clear all values
/				Stall - Keep all values, don't load new ones
/			Decode:
/				Instruction_Fet[15:0] - Instruction to be moved through the pipeline
/				PC2_Fet[15:0] - Well, what can I say
/
/		OUTPUTS: Sorted by stage consumed
/			Decode:
/				Instruction_Dec[15:0] - Instruction Fetched
/				PC2_Dec[15:0] - Incremented PC
********************************************************************************************************/
module Fetch-Decode_Blade(clk, rst, Flush, Stall, Instruction_Fet, PC2_Fet, Instruction_Dec, PC2_Dec);

	input clk;
	input rst;
	input Flush;
	input Stall;

	input [15:0] Instruction_Fet;
	input [15:0] PC2_Fet;

	output [15:0] Instruction_Dec;
	output [15:0] PC2_Dec;

	dff_pipe Instrc[15:0](.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Instruction_Fet), .q(Instruction_Dec));
	dff_pipe PC2[15:0](.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(PC2_Fet), .q(PC2_Dec));

endmodule