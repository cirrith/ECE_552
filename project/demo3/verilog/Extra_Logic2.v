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
/				PC_Sel - PC Mode (Comes from Decode Stage)
/					0 - PC + 2
/					1 - PC = PC_Ex
/				*PC_Code [1:0] - Type of Program counter being preformed, looking for 10, or branch instruction
/					00 - Standard Operation
/					01 - Jump (Rs + Immediate)
/					10 - Branch (PC + 2 + Immediate)
/					11 - Jump (PC + 2 + Immediate)
/				*Reg_Src_Dec [2:0] - Register to be used in a branch instruction
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
/				Mem_Stall - Memory is requesting a stall
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
/				*Branch_Forward - Forward from Memory Stage to Decode for branch instructions
/				*Branch_Forward_Data [15:0] - Data for decode stage
/
/		INTERNAL:
/				Forward_Mem - Forwarding from memory stage
/				*Branch_Stall_EXME - Need to stall for Branch, data needed is in execute currently and needs to go to memory
/				*Branch_Stall_Mem_Read - Need to stall for Branch, data needed is not available as it is being read
********************************************************************************************************/
module Extra_Logic2 (halt_Dec, halt_Exe, halt_Mem, halt_WB, PC_Sel, Reg_Write_Exe, Reg_Write_Mem, Reg_Write_WB, Reg_1_Src_Dec, Reg_1_Src_Exe, Reg_2_Src_Dec, Reg_2_Src_Exe, Write_Reg_Exe, Write_Reg_Mem, Write_Reg_WB, ALU_Result_Mem, WB, Mem_Read_Exe, PC_Code, Check_A_Dec, Check_B_Dec, Check_A_Exe, Check_B_Exe, A_Forward, A_Forward_Data, B_Forward, B_Forward_Data, PC_Det_Forward, PC_Det_Forward_Data, Stall_Fetch, Stall_IFDE, Stall_DEEX, Stall_EXME, Stall_MEWB, Flush_IFDE, Flush_DEEX, Flush_EXME, Flush_MEWB);
	
	input 			halt_Dec;
	input 			halt_Exe;
	input 			halt_Mem;
	input 			halt_WB;
	input 			PC_Sel;
	
	input			Reg_Write_Exe;
	input			Reg_Write_Mem;
	input			Reg_Write_WB;
	
	input [2:0]		Reg_1_Src_Dec;
	input [2:0]		Reg_1_Src_Exe;
	
	input [2:0]		Reg_2_Src_Dec;
	input [2:0]		Reg_2_Src_Exe;
	
	input [2:0]		Write_Reg_Exe;
	input [2:0]		Write_Reg_Mem;
	input [2:0]		Write_Reg_WB;
	
	input [15:0]	ALU_Result_Mem;
	input [15:0]	WB;
	
	input			Mem_Read_Exe;
	
	input [1:0]		PC_Code;
	
	input			Check_A_Dec;
	input			Check_B_Dec;
	
	input			Check_A_Exe;
	input			Check_B_Exe;
	
	input			Mem_Stall;
	
	output 			A_Forward;
	output [15:0]	A_Forward_Data;
	
	output 			B_Forward;
	output [15:0]	B_Forward_Data;
	
	output 			PC_Det_Forward;
	output [15:0]	PC_Det_Forward_Data;
	
	output Stall_Fetch;
	output Stall_IFDE;
	output Stall_DEEX;
	output Stall_EXME;
	output Stall_MEWB;
	
	output Flush_IFDE;
	output Flush_DEEX;
	output Flush_EXME;
	output Flush_MEWB;
	
	///////////////////////////////////
	
	wire			A_Forward_DEEX;
	wire			A_Forward_EXME;
	wire			A_Forward_EXWB;
	
	wire			B_Forward_DEEX;
	wire			B_Forward_EXME;
	wire			B_Forward_EXWB;
	
	wire 			Load_Stall;
	wire			Decode_Stall;
	
	wire 			No_Write_PC;
	
	
	assign Decode_Stall = ((Reg_1_Src_Dec == Write_Reg_Exe) & (PC_Code != 2'h0) & Reg_Write_Exe);
	
	assign Load_Stall =  Mem_Read_Exe & ((A_Forward_DEEX & Check_A_Dec) | (B_Forward_DEEX & Check_B_Dec));
	
	assign A_Forward_DEEX = (Reg_1_Src_Dec == Write_Reg_Exe) & Reg_Write_Exe & Check_A_Dec; //Instruction in Decode needs forward from result of Exe
	assign B_Forward_DEEX = (Reg_2_Src_Dec == Write_Reg_Exe) & Reg_Write_Exe & Check_B_Dec; //Instruction in Decode needs forward from result of Exe
	
	assign A_Forward_EXME = (Reg_1_Src_Exe == Write_Reg_Mem) & Reg_Write_Mem & Check_A_Exe; //Instruction in Execute needs forward from result in Mem
	assign B_Forward_EXME = (Reg_2_Src_Exe == Write_Reg_Mem) & Reg_Write_Mem & Check_B_Exe; //Instruction in Execute needs forward from result in Mem
	
	assign A_Forward_EXWB = (Reg_1_Src_Exe == Write_Reg_WB) & Reg_Write_WB & Check_A_Exe;
	assign B_Forward_EXWB = (Reg_2_Src_Exe == Write_Reg_WB) & Reg_Write_WB & Check_B_Exe;
	
	assign A_Forward = A_Forward_EXME | A_Forward_EXWB;
	assign B_Forward = B_Forward_EXME | B_Forward_EXWB;
	
	assign A_Forward_Data = A_Forward_EXME ? ALU_Result_Mem : WB; //Memory has priority
	assign B_Forward_Data = B_Forward_EXME ? ALU_Result_Mem : WB; //Memory has priority
	
	assign PC_Det_Forward = (Reg_1_Src_Dec == Write_Reg_Mem) & (PC_Code == 2'h1 | PC_Code == 2'h2);
	assign PC_Det_Forward_Data = ALU_Result_Mem;
	
	assign No_Write_PC = halt_Dec | halt_Exe | halt_Mem | halt_WB;
	
	assign Stall_Fetch = Load_Stall | No_Write_PC | Decode_Stall | Mem_Stall;
	assign Stall_IFDE = Load_Stall | Decode_Stall | Mem_Stall;
	assign Stall_DEEX = Mem_Stall;
	assign Stall_EXME = Mem_Stall;
	assign Stall_MEWB = Mem_Stall;
	
	assign Flush_IFDE = (PC_Sel | No_Write_PC) & ~(Decode_Stall | Load_Stall); 
	assign Flush_DEEX = Load_Stall | Decode_Stall;
	assign Flush_EXME = 1'b0;
	assign Flush_MEWB = 1'b0;
	
endmodule
