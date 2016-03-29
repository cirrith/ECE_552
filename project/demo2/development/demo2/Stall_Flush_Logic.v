/********************************************************************************************************
/		MODULE: Stall_Flush_Logic
/		PURPOSE: Given the state of the processor determine if a flush or stall needs to occur and if so which stages
/					should be flushed and or stalled
/				Flush should occur when
/					-The PC changes in a non-uniform way (Branch Taken or Jump Instruction)
/						If PC_Sel is 1 then we are doing a non-uniform change and we should clear the fetch and decode blades and stages (rest should go through)
/					-To ensure that the processor doesn't continue going when a halt instruction is encountered (Not 100% Needed, Stall will also freeze the PC)
/						If a halt is present in stage then the previous blades and stages should be flushed
/				Stall should occur when
/					-We need forwarding from a load instruction, but it hasn't got the data yet
/		INPUTS:
/				PC_Sel - PC Mode (Comes from Execute Stage)
/					0 - PC + 2
/					1 - PC = PC_Ex
/
/				halt_Dec - Halt instruction has made it to Decode Stage
/				halt_Exe - Halt instruction has made it to Execute Stage
/				halt_Mem - Halt instruction has made it to Memory Stage
/				halt_WB - Halt instruction has made it to Writeback Stage
/
/				Forward_Mem - Forwarding from Memory stage
/				Mem_Read_Mem - Whether the memory stage is going to read some data
/				
/		OUTPUTS: 
/				Flush_IFDE - Clear info in IFDE Blade
/				Flush_DEEX - Clear info in DEEX Blade
/				Flush_EXME - Clear info in EXME Blade (Don't know if will have to use this ever)
/				Flush_MEWB - Clear info in MEWB Blade (Don't know if will have to use this ever)
/
/				Stall_Fetch - Dont' Write back to PC, should be the same as Stall_IFDE
/				Stall_IFDE - Don't write info from Instruction Fetch Stage
/				Stall_DEEX - Don't write info from Decode Stage
/				Stall_EXME - Don't write info from Execute Stage (Don't know if will have to use this ever)
/				Stall_MEWB - Don't write info from Memory Stage (Don't know if will have to use this ever)
/
/		INTERNAL:
/				Stall_Load - If there should be a stall due to a load dependency
/				Stall_Halt - If there should be a stall due to a halt instruction
********************************************************************************************************/
module Stall_Flush_Logic(PC_Sel, halt_Dec, halt_Exe, halt_Mem, halt_WB, Forward_Mem, Mem_Read_Mem, Flush_IFDE, Flush_DEEX, Flush_EXME, Flush_MEWB, Stall_Fetch, Stall_IFDE, Stall_DEEX, Stall_EXME, Stall_MEWB);
	
	input PC_Sel;
	input halt_Dec;
	input halt_Exe;
	input halt_Mem;
	input halt_WB;
	input Forward_Mem;
	input Mem_Read_Mem;
	
	output Flush_IFDE;
	output Flush_DEEX;
	output Flush_EXME;
	output Flush_MEWB;
	output Stall_Fetch;
	output Stall_IFDE;
	output Stall_DEEX;
	output Stall_EXME;
	output Stall_MEWB;
	
	wire Stall_Load; //Stall Fetch, Decode, Execute Stages and Nuke EXME Blade (No infinite loops)
	wire Stall_Halt;
	
	assign Flush_IFDE = PC_Sel | halt_Dec | halt_Exe | halt_Mem | halt_WB;   //Flush everything behind a halt or for a PC redirect
	assign Flush_DEEX = PC_Sel | halt_Exe | halt_Mem | halt_WB;   //Flush everything behind a halt or for a PC redirect
	assign Flush_EXME = halt_Mem | halt_WB | Stall_Load;   //Flush everything behind a halt or clear the memory/execute stage for a stall
	assign Flush_MEWB = halt_WB;   //Flush everything behind a halt
	
	assign Stall_Load = Forward_Mem & Mem_Read_Mem; //Need to stall when doing a load and need to forward from the memory stage
	assign Stall_Halt = halt_Dec | halt_Exe | halt_Mem | halt_WB;
	
	assign Stall_Fetch = Stall_Load | Stall_Halt; //Don't write the new PC, i.e. stall
	assign Stall_IFDE = Stall_Load;   //Don't move forward until we have the value from memory
	assign Stall_DEEX = Stall_Load;   //Don't move forward until we have the value from memory
	assign Stall_EXME = 1'b0;
	assign Stall_MEWB = 1'b0;
	
endmodule	
	