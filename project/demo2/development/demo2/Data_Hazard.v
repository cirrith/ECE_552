/********************************************************************************************************
/		MODULE: Data_Hazard (DEPRECATED)
/		PURPOSE: Given what the instructions are doing, determine if any stalls/flushes need to occur
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
********************************************************************************************************/
module Data_Hazard();

	input PC_Sel;
	input Stall_Exe;
	input halt_Dec;
	input halt_Exe;
	input halt_Mem;
	input halt_WB;
	
	input Mem_Read_Dec;
	input Mem_Read_Exe;
	input Mem_Read_Mem;
	
	input Reg_Write_Dec;
	input Reg_Write_Exe;
	input Reg_Write_Mem;
	input Reg_Write_WB;
	
	input [2:0] Reg_1_Src_Dec;
	input [2:0] Reg_1_Src_Exe;
	
	input [2:0] Reg_2_Src_Dec;
	input [2:0] Reg_2_Src_Exe;
	
	input [2:0] Write_Reg_Dec;
	input [2:0] Write_Reg_Exe;
	input [2:0] Write_Reg_Mem;
	input [2:0] Write_Reg_WB;
	
	output Stall_Fetch;
	output Stall_IFDE;
	output Stall_DEEX;
	output Stall_EXME;
	output Stall_MEWB;
	
	output Flush_IFDE;
	output Flush_DEEX;
	output Flush_EXME;
	output Flush_MEWB;
	
	//Stall Logic
	//Flush Logic

endmodule






















