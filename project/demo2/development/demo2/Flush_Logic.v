/********************************************************************************************************
/		MODULE: Flush_Logic (DEPRECATED)
/		PURPOSE: Given the state of the processor determine if a flush needs to occur and if so which stages
/					should be flushed
/				Flush should occur when
/					-The PC changes in a non-uniform way (Branch Taken or Jump Instruction)
/						If PC_Sel is 1 then we are doing a non-uniform change and we should clear the fetch and decode blades and stages (rest should go through)
/					-To ensure that the processor doesn't continue going when a halt instruction is encountered (Not 100% Needed, Stall will also freeze the PC)
/						If a halt is present in stage then the previous blades and stages should be flushed
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
/		OUTPUTS: 
/				Flush_IFDE - Clear info in IFDE Blade
/				Flush_DEEX - Clear info in DEEX Blade
/				Flush_EXME - Clear info in EXME Blade (Don't know if will have to use this ever)
/				Flush_MEWB - Clear info in MEWB Blade (Don't know if will have to use this ever)
********************************************************************************************************/
module Flush_Logic(PC_Sel, halt_Dec, halt_Exe, halt_Mem, halt_WB, Flush_IFDE, Flush_DEEX,  Flush_EXME, Flush_MEWB);

	input PC_Sel;
	input halt_Dec;
	input halt_Exe;
	input halt_Mem;
	input halt_WB;
	
	output Flush_IFDE;
	output Flush_DEEX;
	output Flush_EXME;
	output Flush_MEWB;
	
	assign Flush_IFDE = PC_Sel | halt_Dec | halt_Exe | halt_Mem | halt_WB;
	assign Flush_DEEX = PC_Sel | halt_Exe | halt_Mem | halt_WB;
	assign Flush_EXME = halt_Mem | halt_WB
	assign Flush_MEWB = halt_WB;
	
endmodule

//Should be good to go 3/24


//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES
//I LOVE MODULES