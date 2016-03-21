/********************************************************************************************************
/		MODULE: Execute-Memory_Blade
/		PURPOSE: Pipeline blade between Execute and Memory stages
/
/		INPUTS: Sorted by stage of final consume
/			clk - Clock
/			rst - Reset
/			Flush - Clear all the values
/			Stall - Keep all values, don't load new ones
/					
/			Memory:	
/				Mem_Data_Exe[1:0] - Mem_Data[1] = Write, Mem_Data[0] = Read
/				Reg_2_Read_Exe[15:0] - Value 2 read from register file
/				
/			WriteBack:
/				ALU_Result_Exe[15:0] - Result from ALU
/				Reg_Write_Exe - To write or not
/				WB_Sel_Exe - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Sel_Exe[2:0] - Which register to write to, pre-calculated				
/
/		OUTPUTS: Sorted by stage of final consume	
/			Memory:	
/				Mem_Data_Mem[1:0] - Mem_Data[1] = Write, Mem_Data[0] = Read
/				Reg_2_Read_Mem[15:0] - Value 2 read from register file
/				
/			WriteBack:
/				ALU_Result_Mem[15:0] - Result from ALU
/				Reg_Write_Mem - To write or not
/				WB_Sel_Mem - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Sel_Mem[2:0] - Which register to write to, pre-calculated				
/
/		
********************************************************************************************************/
module Execute-Memory_Blade(clk, rst, Flush, Stall, Mem_Data_Exe, Reg_2_Read_Exe, ALU_Result_Exe, Reg_Write_Exe, WB_Sel_Exe, Write_Reg_Sel_Exe, Mem_Data_Mem, Reg_2_Read_Mem, ALU_Result_Mem, Reg_Write_Mem, WB_Sel_Mem, Write_Reg_Sel_Mem;);

	input clk;
	input rst;
	input Flush;
	input Stall;	

//Memory
	input [1:0] Mem_Data_Exe;
	input [15:0] Reg_2_Read_Exe;
	
//WriteBack
	input [15:0] ALU_Result_Exe;
	input Reg_Write_Exe;
	input WB_Sel_Exe;
	input [2:0] Write_Reg_Sel_Exe;
		
//Memory
	output [1:0] Mem_Data_Mem;
	output [15:0] Reg_2_Read_Mem;
	
//WriteBack
	output [15:0] ALU_Result_Mem;
	output Reg_Write_Mem;
	output WB_Sel_Mem;
	output [2:0] Write_Reg_Sel_Mem;

//Memory
	dff_pipe mem_data [1:0] (.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Data_Exe), .q(Mem_Data_Mem));
	dff_pipe reg_2_data [15:0]		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_2_Read_Exe), 	.q(Reg_2_Read_Mem));
	
//WriteBack
	dff_pipe alu_result [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(ALU_Result_Exe), 	.q(ALU_Result_Mem));
	dff_pipe reg_write 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_Write_Exe), 	.q(Reg_Write_Mem));
	dff_pipe wb_sel 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(WB_Sel_Exe), 		.q(WB_Sel_Mem));
	dff_pipe write_reg_sel [2:0]	(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Write_Reg_Sel_Exe), .q(Write_Reg_Sel_Mem));
	
endmodule