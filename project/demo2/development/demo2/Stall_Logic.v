/********************************************************************************************************
/		MODULE: Stall_Logic (DEPRECATED)
/		PURPOSE: Given the stage of the processor determine if a stall needs to occur and if so which stages
/					should be stalled
/
/		INPUTS:
/				Forward_Mem - Forwarding from Memory stage
/				halt_Dec - Halt command present in Decode stage
/				halt_Exe - Halt command present in Execute stage
/				halt_Mem - Halt command present in Memory stage
/				halt_WB - Halt command present in Writeback stage
/				Mem_Read_Mem - Whether the memory stage is going to read some data
/				
/		OUTPUTS: 
/				Stall_Fetch - Dont' Write back to PC, should be the same as Stall_IFDE
/				Stall_IFDE - Don't write info from Instruction Fetch Stage
/				Stall_DEEX - Don't write info from Decode Stage
/				Stall_EXME - Don't write info from Execute Stage (Don't know if will have to use this ever)
/				Stall_MEWB - Don't write info from Memory Stage (Don't know if will have to use this ever)
/
/				Flush_EXME - Flush the Execute/Memory Blade in the event of a load stall
/
/		INTERNAL:
/				Stall_Load - If there should be a stall due to a load dependency
/				Stall_Halt - If there should be a stall due to a halt instruction
********************************************************************************************************/
module Stall_Logic(Forward_Mem, halt_Dec, halt_Exe, halt_Mem, halt_WB, Mem_Read_Mem, Stall_Fetch, Stall_IFDE, Stall_DEEX, Stall_EXME, Stall_MEWB, Flush_EXME);
	
	input Forward_Mem;
	input halt_Dec;
	input halt_Exe;
	input halt_Mem;
	input halt_WB;
	input Mem_Read_Mem;
	
	output Stall_Fetch;
	output Stall_IFDE;
	output Stall_DEEX;
	output Stall_EXME;
	output Stall_MEWB;
	output Flush_EXME; //You have been given the power to end it all, choose wisely from now on, every action that you take will have a far wider impact than anything you could intisipate.
	
	wire Stall_Load; //Stall Fetch, Decode, Execute Stages and Nuke EXME Blade (No infinite loops)
	wire Stall_Halt;
	
	assign Stall_Load = Forward_Mem & Mem_Read_Mem;
	assign Stall_Halt = halt_Dec | halt_Exe | halt_Mem | halt_WB;
	
	assign Stall_Fetch = Stall_Load | Stall_Halt;
	assign Stall_IFDE = Stall_Load;
	assign Stall_DEEX = Stall_Load;
	assign Stall_EXME = 1'b0;
	assign Stall_MEWB = 1'b0;
	
	assign Flush_EXME = Stall_Load;
	
endmodule