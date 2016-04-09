/********************************************************************************************************
/		MODULE: Memory_Writeback_Blade
/		PURPOSE: Pipeline blade between Memory and Writeback stages 
/
/		INPUTS: Sorted by stage of final consume		
/				ALU_Result_Mem[15:0] - Result from ALU
/				Reg_Write_Mem - To write or not
/				Mem_Data_Mem[15:0] - Information read from a mem read
/				WB_Sel_Mem - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Mem[2:0] - Which register to write to, pre-calculated
/				halt_Mem - A halt command was passed through
/					0 - No halt
/					1 - Yes halt
/
/		OUTPUTS: Sorted by stage of final consume
/				ALU_Result_WB[15:0] - Result from ALU
/				Reg_Write_WB - To write or not
/				Mem_Data_WB[15:0] - Information read from a mem read
/				WB_Sel_WB - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_WB[2:0] - Which register to write to, pre-calculated
/				halt_WB - A halt command was passed through (Read from here)
/					0 - No halt
/					1 - Yes halt
********************************************************************************************************/
module Memory_Writeback_Blade (clk, rst, Flush, Stall, ALU_Result_Mem, Reg_Write_Mem, Mem_Data_Mem, WB_Sel_Mem, Write_Reg_Mem, halt_Mem, ALU_Result_WB, Reg_Write_WB, Mem_Data_WB, WB_Sel_WB, Write_Reg_WB, halt_WB);

	input clk;
	input rst;
	input Flush;
	input Stall;

	input [15:0] ALU_Result_Mem;
	input Reg_Write_Mem;
	input [15:0] Mem_Data_Mem;
	input WB_Sel_Mem;
	input [2:0] Write_Reg_Mem;
	input halt_Mem;

	output [15:0] ALU_Result_WB;
	output Reg_Write_WB;
	output [15:0] Mem_Data_WB;
	output WB_Sel_WB;
	output [2:0] Write_Reg_WB;
	output halt_WB;

	dff_pipe alu_result [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(ALU_Result_Mem), 	.q(ALU_Result_WB));
	dff_pipe reg_write 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_Write_Mem), 	.q(Reg_Write_WB));
	dff_pipe mem_data [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Data_Mem), 		.q(Mem_Data_WB));
	dff_pipe wb_sel 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(WB_Sel_Mem), 		.q(WB_Sel_WB));
	dff_pipe write_reg [2:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Write_Reg_Mem), 	.q(Write_Reg_WB));
	dff_pipe halt 					(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(halt_Mem), 			.q(halt_WB));

endmodule