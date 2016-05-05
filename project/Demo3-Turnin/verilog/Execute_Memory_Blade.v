/********************************************************************************************************
/		MODULE: Execute_Memory_Blade
/		PURPOSE: Pipeline blade between Execute and Memory stages
/
/		INPUTS: Sorted by stage of final consume
/			clk - Clock
/			rst - Reset
/			Flush - Clear all the values
/			Stall - Keep all values, don't load new ones
/					
/			Memory:	
/				Mem_Write_Exe - Memory Write
/				Mem_Read_Exe - Memory Read
/				Reg_2_Data_Exe[15:0] - Value 2 read from register file
/				createdump_Exe - Dump Memory
/				
/			WriteBack:
/				ALU_Result_Exe[15:0] - Result from ALU
/				Reg_Write_Exe - To write or not
/				WB_Sel_Exe - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Exe[2:0] - Which register to write to, pre-calculated
/				halt_Exe - A halt command was passed through
/					0 - No halt
/					1 - Yes halt		
/
/		OUTPUTS: Sorted by stage of final consume	
/			Memory:	
/				Mem_Write_Mem - Memory Write
/				Mem_Read_Mem - Memory Read
/				Reg_2_Data_Mem[15:0] - Value 2 read from register file
/				createdump_Mem - Dump Memory
/				
/			WriteBack:
/				ALU_Result_Mem[15:0] - Result from ALU
/				Reg_Write_Mem - To write or not
/				WB_Sel_Mem - Which thing to write back in WB stage
/					0 = ALU
/					1 = Memory
/				Write_Reg_Mem[2:0] - Which register to write to, pre-calculated	
/				halt_Mem - A halt command was passed through
/					0 - No halt
/					1 - Yes halt			
********************************************************************************************************/
module Execute_Memory_Blade (clk, rst, Flush, Stall, Mem_Write_Exe, Mem_Read_Exe, Reg_2_Data_Exe, createdump_Exe, ALU_Result_Exe, Reg_Write_Exe, WB_Sel_Exe, Write_Reg_Exe, halt_Exe, Mem_Write_Mem, Mem_Read_Mem, Reg_2_Data_Mem, createdump_Mem, ALU_Result_Mem, Reg_Write_Mem, WB_Sel_Mem, Write_Reg_Mem, halt_Mem);

	input 			clk;
	input 			rst;
	input 			Flush;
	input 			Stall;	

//Memory
	input 			Mem_Write_Exe;
	input 			Mem_Read_Exe;
	input [15:0] 	Reg_2_Data_Exe;
	input			createdump_Exe;
	
//WriteBack
	input [15:0] 	ALU_Result_Exe;
	input 			Reg_Write_Exe;
	input 			WB_Sel_Exe;
	input [2:0] 	Write_Reg_Exe;
	input			halt_Exe;
		
//Memory
	output 		 	Mem_Write_Mem;
	output 			Mem_Read_Mem;
	output [15:0] 	Reg_2_Data_Mem;
	output			createdump_Mem;
	
//WriteBack
	output [15:0] ALU_Result_Mem;
	output Reg_Write_Mem;
	output WB_Sel_Mem;
	output [2:0] Write_Reg_Mem;
	output halt_Mem;

//Memory
	dff_pipe mem_write		 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Write_Exe), 	.q(Mem_Write_Mem));
	dff_pipe mem_read		 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Mem_Read_Exe), 		.q(Mem_Read_Mem));
	dff_pipe reg_2_data [15:0]		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_2_Data_Exe), 	.q(Reg_2_Data_Mem));
	dff_pipe createdump				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(createdump_Exe), 	.q(createdump_Mem));
	
//WriteBack
	dff_pipe alu_result [15:0] 		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(ALU_Result_Exe), 	.q(ALU_Result_Mem));
	dff_pipe reg_write 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Reg_Write_Exe), 	.q(Reg_Write_Mem));
	dff_pipe wb_sel 				(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(WB_Sel_Exe), 		.q(WB_Sel_Mem));
	dff_pipe write_reg [2:0]		(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(Write_Reg_Exe), 	.q(Write_Reg_Mem));
	dff_pipe halt					(.clk(clk), .rst(rst), .Flush(Flush), .Stall(Stall), .d(halt_Exe), 			.q(halt_Mem));
	
endmodule