/********************************************************************************************************
/		MODULE: Extra_Logic TODO Fix I/0
/		PURPOSE: Given the state of the processor determine if any of the following need to occur
/			FORWARD WHEN:
/						One of the source registers in the execute stage begin written to in either the memory stage or the writeback stage
/
/			STALL WHEN: 
/						Instruction uses data used in a load instruction (1 cycle stall)
/							Wait for memory phase to complete then forward will take data from WB
/
/			FLUSH WHEN: 
/						Branch is taken
/						Jump occurs (Need to let rest of instruction finish)
/							Jump and Branches will only occur in Execute stage, need to flush IFDE and DEEX blades
/								can let fetch go through because instruction will write its PC in that cycle
/
/		INPUTS: 
/				PC_Sel - PC Mode (Comes from Execute Stage)
/					0 - PC + 2
/					1 - PC = PC_Ex
/				
/				Stall_Exe - Execute stages requests a stall for data dependancy
/
/				halt_Dec - Halt instruction has made it to Decode Stage
/				halt_Exe - Halt instruction has made it to Execute Stage
/				halt_Mem - Halt instruction has made it to Memory Stage
/				halt_WB - Halt instruction has made it to Writeback Stage
/				
/				//Not using WB_Sel b/c Mem_Read will give the same information
/				
/				Mem_Read_Dec - Instruction is going to read from memory when it reaches memory stage
/				Mem_Read_Exe - Instruction is going to read from memory when it reaches memory stage
/				Mem_Read_Mem - Instruction is currently reading from memory
/				
/				Reg_Write_Dec - Instruction is going to write to register file when it reaches writeback stage
/				Reg_Write_Exe - Instruction is going to write to register file when it reaches writeback stage
/				Reg_Write_Mem - Instruction is going to write to register file when it reaches writeback stage
/				Reg_Write_WB - Instruction is currently writing to register file
/				
/				Reg_1_Src_Dec [2:0] - Register that register source 1 came from
/				Reg_1_Src_Exe [2:0] - Register that register source 1 came from
/				
/				Reg_2_Src_Dec [2:0] - Register that register source 2 came from (can be inaccurate, immediate instruction)
/				Reg_2_Src_Exe [2:0] - Register that register source 2 came from (can be inaccurate, immediate instruction)
/				
/				Write_Reg_Dec [2:0] - Register that will be written to in writeback if Reg_Write is true
/				Write_Reg_Exe [2:0] - Register that will be written to in writeback if Reg_Write is true
/				Write_Reg_Mem [2:0] - Register that will be written to in writeback if Reg_Write is true
/				Write_Reg_WB [2:0] - Register currently being written to if Reg_Write is true
/				
/		OUTPUTS: 
/				Stall_Fetch - Dont' Write back to PC, should be the same as Stall_IFDE
/				Stall_IFDE - Don't write info from Instruction Fetch Stage
/				Stall_DEEX - Don't write info from Decode Stage
/				Stall_EXME - Don't write info from Execute Stage (Don't know if will have to use this ever)
/				Stall_MEWB - Don't write info from Memory Stage (Don't know if will have to use this ever)
/		
/				Flush_IFDE - Clear info in IFDE Blade
/				Flush_DEEX - Clear info in DEEX Blade
/				Flush_EXME - Clear info in EXME Blade (Don't know if will have to use this ever)
/				Flush_MEWB - Clear info in MEWB Blade (Don't know if will have to use this ever)
/
/				A_Forward - Forward A
/				B_Forward - Forward B, if a register operation
/				A_Forward_Data - Data to forward to A if A_Forward
/				B_Forward_Data - Data to forward to B if B_Forward
/
/		INTERNAL:
/				Forward_Mem - Forwarding from memory stage
********************************************************************************************************/
module Extra_Logic (Reg_1_Src, Reg_2_Src, Write_Reg_Mem, Write_Reg_WB, Reg_Write_Mem, Reg_Write_WB, ALU_Result_Mem, WB, PC_Sel, halt_Dec, halt_Exe, halt_Mem, halt_WB, Mem_Read_Mem, Flush_IFDE, Flush_DEEX, Flush_EXME, Flush_MEWB, Stall_Fetch, Stall_IFDE, Stall_DEEX, Stall_EXME, Stall_MEWB, A_Forward, B_Forward, A_Forward_Data, B_Forward_Data);

	input [2:0] 	Reg_1_Src;
	input [2:0] 	Reg_2_Src;
	
	input [2:0] 	Write_Reg_Mem;
	input [2:0] 	Write_Reg_WB;
	
	input 			Reg_Write_Mem;
	input 			Reg_Write_WB;
	
	input [15:0] 	ALU_Result_Mem;
	input [15:0] 	WB;
	
	input 			PC_Sel;
	input 			halt_Dec;
	input 			halt_Exe;
	input 			halt_Mem;
	input 			halt_WB;
	input 			Mem_Read_Mem;
	
	output 			Flush_IFDE;
	output 			Flush_DEEX;
	output 			Flush_EXME;
	output 			Flush_MEWB;
	output 			Stall_Fetch;
	output 			Stall_IFDE;
	output 			Stall_DEEX;
	output 			Stall_EXME;
	output 			Stall_MEWB;
	output 			A_Forward;
	output 			B_Forward;
	output [15:0] A_Forward_Data;
	output [15:0] B_Forward_Data;	

	wire Forward_Mem;

	Forward_Logic forward (
			.Reg_1_Src				(Reg_1_Src),
			.Reg_2_Src				(Reg_2_Src),
			.Write_Reg_Mem			(Write_Reg_Mem),
			.Write_Reg_WB			(Write_Reg_WB),
			.Reg_Write_Mem			(Reg_Write_Mem),
			.Reg_Write_WB			(Reg_Write_WB),
			.ALU_Result_Mem			(ALU_Result_Mem),
			.WB						(WB),
			.A_Forward				(A_Forward),
			.B_Forward				(B_Forward),
			.Forward_Mem			(Forward_Mem),
			.A_Forward_Data			(A_Forward_Data),
			.B_Forward_Data			(B_Forward_Data));
			
	Stall_Flush_Logic stall_flush (
			.PC_Sel					(PC_Sel), 
			.halt_Dec				(halt_Dec), 
			.halt_Exe				(halt_Exe), 
			.halt_Mem				(halt_Mem), 
			.halt_WB				(halt_WB), 
			.Forward_Mem			(Forward_Mem), 
			.Mem_Read_Mem			(Mem_Read_Mem), 
			.Flush_IFDE				(Flush_IFDE), 
			.Flush_DEEX				(Flush_DEEX), 
			.Flush_EXME				(Flush_EXME), 
			.Flush_MEWB				(Flush_MEWB), 
			.Stall_Fetch			(Stall_Fetch), 
			.Stall_IFDE				(Stall_IFDE), 
			.Stall_DEEX				(Stall_DEEX), 
			.Stall_EXME				(Stall_EXME), 
			.Stall_MEWB				(Stall_MEWB));
			
endmodule