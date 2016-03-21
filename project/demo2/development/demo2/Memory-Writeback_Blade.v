/********************************************************************************************************
/		MODULE: Memory-Writeback_Blade
/		PURPOSE: Pipeline blade between Memory and Writeback stages 
/
/		INPUTS: Sorted by stage of final consume		
/				ALU_Result_Mem[15:0] - Result from ALU
/				Reg_Write_Mem - To write or not
/				Mem_Read_Mem[15:0] - Information read from a mem read
/				WB_Sel_Mem - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Sel_Mem[2:0] - Which register to write to, pre-calculated	
/
/		OUTPUTS: Sorted by stage of final consume
/				ALU_Result_WB[15:0] - Result from ALU
/				Reg_Write_WB - To write or not
/				Mem_Read_WB[15:0] - Information read from a mem read
/				WB_Sel_WB - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Sel_WB[2:0] - Which register to write to, pre-calculated	
********************************************************************************************************/
module Memory-Writeback_Blade(clk, rst, Flush, Stall, ALU_Result_Mem, Reg_Write_Mem, Mem_Read_Mem, WB_Sel_Mem, Write_Reg_Sel_Mem, ALU_Result_WB, Reg_Write_WB, Mem_Read_WB, WB_Sel_WB, Write_Reg_Sel_WB);

	input clk;
	input rst;
	input Flush;
	input Stall;

	input [15:0] ALU_Result_Mem;
	input Reg_Write_Mem;
	input [15:0] Mem_Read_Mem;
	input WB_Sel_Mem;
	input [2:0] Write_Reg_Sel_Mem;

	output [15:0] ALU_Result_WB;
	output Reg_Write_WB;
	output [15:0] Mem_Read_WB;
	output WB_Sel_WB;
	output [2:0] Write_Reg_Sel_WB;

	dff_pipe alu_result [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(ALU_Result_Mem), 	.q(ALU_Result_WB));
	dff_pipe reg_write 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_Write_Mem), 	.q(Reg_Write_WB));
	dff_pipe mem_read [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Read_Mem), 		.q(Mem_Read_WB));
	dff_pipe wb_sel 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(WB_Sel_Mem), 		.q(WB_Sel_WB));
	dff_pipe write_reg_sel [2:0] 	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Write_Reg_Sel_Mem), .q(Write_Reg_Sel_WB));

endmodule