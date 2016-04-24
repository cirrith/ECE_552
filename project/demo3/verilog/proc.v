
//Nuke Stage after a stall?
//TODO Clean out Forward, Flush, and Stall logic signals from Decode and Execute stages

module proc (err, clk, rst);

	input 				clk;
	input 				rst;

	output 			err;

	wire [15:0] 		Instruction_Fet;
	wire [15:0] 		Instruction_Dec;
		
	wire [15:0] 		PC2_Fet;
	wire [15:0] 		PC2_Dec;
	wire [15:0] 		PC2_Exe;
	
	wire [1:0]			PC_Code;
		
	wire [15:0] 		Reg_1_Data_Dec;
	wire [15:0] 		Reg_1_Data_Exe;
		
	wire [15:0] 		Reg_2_Data_Dec;
	wire [15:0] 		Reg_2_Data_Exe;
	wire [15:0] 		Reg_2_Data_Mem;
	
	wire [15:0]			Reg_2_Data_For_Exe;
	
	wire [2:0] 			Reg_1_Src_Dec;
	wire [2:0] 			Reg_1_Src_Exe;
				
	wire [2:0] 			Reg_2_Src_Dec;
	wire [2:0] 			Reg_2_Src_Exe;
	
	wire [15:0] 		Immediate_Dec;
	wire [15:0] 		Immediate_Exe;
	
	wire [2:0] 			Write_Reg_Dec;
	wire [2:0] 			Write_Reg_Exe;
	wire [2:0] 			Write_Reg_Mem;
	wire [2:0] 			Write_Reg_WB;
	
	wire [15:0] 		ALU_Result_Exe;
	wire [15:0] 		ALU_Result_Mem;
	wire [15:0] 		ALU_Result_WB;
	
	wire 				Reg_Write_Dec;
	wire 				Reg_Write_Exe;
	wire 				Reg_Write_Mem;
	wire 				Reg_Write_WB;
	
	wire [3:0] 			ALU_OP_Code_Dec;
	wire [3:0] 			ALU_OP_Code_Exe;
	
	wire 				Pass_Thr_Sel_Dec;
	wire 				Pass_Thr_Sel_Exe;
	
	wire 				ALU_B_Src_Dec;
	wire 				ALU_B_Src_Exe;
	
	wire [15:0]			Mem_Data_Mem;
	wire [15:0]			Mem_Data_WB;
	
	wire 				Mem_Write_Dec;
	wire 				Mem_Write_Exe;
	wire 				Mem_Write_Mem;
	
	wire 				Mem_Read_Dec;
	wire 				Mem_Read_Exe;
	wire 				Mem_Read_Mem;

	wire				A_Forward;
	wire				B_Forward;
	wire				PC_Det_Forward;
	
	wire [15:0]			A_Forward_Data;
	wire [15:0]			B_Forward_Data;
	wire [15:0]			PC_Det_Forward_Data;

	wire					Mem_Stall;
	
	wire 				WB_Sel_Dec;
	wire 				WB_Sel_Exe;
	wire 				WB_Sel_Mem;
	wire 				WB_Sel_WB;

	wire 				createdump_Dec;
	wire 				createdump_Exe;
	wire 				createdump_Mem;
	wire				createdump_WB;

	wire 				halt_Dec;
	wire 				halt_Exe;
	wire 				halt_Mem;
	wire 				halt_WB;
	
	wire [15:0] 		WB;
	wire [15:0] 		PC_Ex;
	wire 				PC_Sel;
	
	wire				Check_A_Dec;
	wire				Check_A_Exe;
	
	wire				Check_B_Dec;
	wire				Check_B_Exe;
	
	wire 				Stall_Fetch;
	wire 				Stall_IFDE;
	wire 				Stall_DEEX;
	wire 				Stall_EXME;
	wire 				Stall_MEWB;

	wire 				Flush_IFDE;
	wire 				Flush_DEEX;
	wire 				Flush_EXME;
	wire 				Flush_MEWB;
	
	wire					Mem_err;
	wire					Fet_err;
	
	assign err = Mem_err | Fet_err;
	
Extra_Logic2 extra_logic (
	.halt_Dec			(halt_Dec),
	.halt_Exe			(halt_Exe),
	.halt_Mem			(halt_Mem),
	.halt_WB			(halt_WB),
	.PC_Sel				(PC_Sel),
	.Reg_Write_Exe		(Reg_Write_Exe),
	.Reg_Write_Mem		(Reg_Write_Mem),
	.Reg_Write_WB		(Reg_Write_WB),
	.Reg_1_Src_Dec		(Reg_1_Src_Dec),
	.Reg_1_Src_Exe		(Reg_1_Src_Exe),
	.Reg_2_Src_Dec		(Reg_2_Src_Dec),
	.Reg_2_Src_Exe		(Reg_2_Src_Exe),
	.Write_Reg_Exe		(Write_Reg_Exe),
	.Write_Reg_Mem		(Write_Reg_Mem),
	.Write_Reg_WB		(Write_Reg_WB),
	.ALU_Result_Mem		(ALU_Result_Mem),
	.WB					(WB),
	.Mem_Read_Exe		(Mem_Read_Exe),
	.PC_Code			(PC_Code),
	.Check_A_Dec		(Check_A_Dec),
	.Check_B_Dec		(Check_B_Dec),
	.Check_A_Exe		(Check_A_Exe),
	.Check_B_Exe		(Check_B_Exe),
	.Mem_Stall			(Mem_Stall),
	.A_Forward			(A_Forward),
	.A_Forward_Data		(A_Forward_Data),
	.B_Forward			(B_Forward),
	.B_Forward_Data		(B_Forward_Data),
	.PC_Det_Forward		(PC_Det_Forward),
	.PC_Det_Forward_Data(PC_Det_Forward_Data),
	.Stall_Fetch		(Stall_Fetch),
	.Stall_IFDE			(Stall_IFDE),
	.Stall_DEEX			(Stall_DEEX),
	.Stall_EXME			(Stall_EXME),
	.Stall_MEWB			(Stall_MEWB),
	.Flush_IFDE			(Flush_IFDE),
	.Flush_DEEX			(Flush_DEEX),
	.Flush_EXME			(Flush_EXME),
	.Flush_MEWB			(Flush_MEWB));
	
	Fetch fetch (
		.clk					(clk),
		.rst					(rst),
		.Stall					(Stall_Fetch),
		.PC_Ex					(PC_Ex),
		.PC_Sel					(PC_Sel),
		.Instruction			(Instruction_Fet),
		.PC2					(PC2_Fet)
		.Fet_Stall			(Fet_Stall)
		.err					(Fet_err));
	
	Fetch_Decode_Blade if_de_blade (
		.clk					(clk),
		.rst					(rst),
		.Flush					(Flush_IFDE),
		.Stall					(Stall_IFDE),
		.Instruction_Fet		(Instruction_Fet),
		.PC2_Fet				(PC2_Fet),
		.Instruction_Dec		(Instruction_Dec),
		.PC2_Dec				(PC2_Dec));
	
	Decode decode (
		.clk					(clk),
		.rst					(rst),
		.Instruction			(Instruction_Dec),
		.PC2					(PC2_Dec),
		.Write_Reg_In			(Write_Reg_WB),
		.Write_Data				(WB),
		.Reg_Write_In			(Reg_Write_WB),
		.PC_Det_Forward			(PC_Det_Forward),
		.PC_Det_Forward_Data	(PC_Det_Forward_Data),
		.PC_Ex					(PC_Ex),
		.PC_Code				(PC_Code),
		.PC_Sel					(PC_Sel),
		.Reg_1_Data				(Reg_1_Data_Dec),
		.Reg_2_Data				(Reg_2_Data_Dec),
		.Reg_1_Src				(Reg_1_Src_Dec),
		.Reg_2_Src				(Reg_2_Src_Dec),
		.Immediate				(Immediate_Dec),
		.Check_A				(Check_A_Dec),
		.Check_B				(Check_B_Dec),
		.Write_Reg_Out			(Write_Reg_Dec),
		.Reg_Write_Out			(Reg_Write_Dec),
		.ALU_OP_Code			(ALU_OP_Code_Dec),
		.Pass_Thr_Sel			(Pass_Thr_Sel_Dec),
		.ALU_B_Src				(ALU_B_Src_Dec),
		.Mem_Write				(Mem_Write_Dec),
		.Mem_Read				(Mem_Read_Dec),
		.WB_Sel					(WB_Sel_Dec),
		.createdump				(createdump_Dec),
		.halt					(halt_Dec));
   
	Decode_Execute_Blade de_ex_blade (
		.clk					(clk),
		.rst					(rst),
		.Flush					(Flush_DEEX),
		.Stall					(Stall_DEEX),
		.ALU_B_Src_Dec			(ALU_B_Src_Dec),
		.ALU_OP_Code_Dec		(ALU_OP_Code_Dec),
		.Immediate_Dec			(Immediate_Dec),
		.Check_A_Dec			(Check_A_Dec),
		.Check_B_Dec			(Check_B_Dec),
		.Pass_Thr_Sel_Dec		(Pass_Thr_Sel_Dec),
		.PC2_Dec				(PC2_Dec),
		.Reg_1_Data_Dec			(Reg_1_Data_Dec),
		.Reg_2_Data_Dec			(Reg_2_Data_Dec),
		.createdump_Dec			(createdump_Dec),
		.Reg_1_Src_Dec			(Reg_1_Src_Dec),
		.Reg_2_Src_Dec			(Reg_2_Src_Dec),
		.Mem_Write_Dec			(Mem_Write_Dec),
		.Mem_Read_Dec			(Mem_Read_Dec),
		.Reg_Write_Dec			(Reg_Write_Dec),
		.WB_Sel_Dec				(WB_Sel_Dec),
		.Write_Reg_Dec			(Write_Reg_Dec),
		.halt_Dec				(halt_Dec),
		.ALU_B_Src_Exe			(ALU_B_Src_Exe),
		.ALU_OP_Code_Exe		(ALU_OP_Code_Exe),
		.Immediate_Exe			(Immediate_Exe),
		.Check_A_Exe			(Check_A_Exe),
		.Check_B_Exe			(Check_B_Exe),
		.Pass_Thr_Sel_Exe		(Pass_Thr_Sel_Exe),
		.PC2_Exe				(PC2_Exe),
		.Reg_1_Data_Exe			(Reg_1_Data_Exe),
		.Reg_2_Data_Exe			(Reg_2_Data_Exe),
		.createdump_Exe			(createdump_Exe),
		.Reg_1_Src_Exe			(Reg_1_Src_Exe),
		.Reg_2_Src_Exe			(Reg_2_Src_Exe),
		.Mem_Write_Exe			(Mem_Write_Exe),
		.Mem_Read_Exe			(Mem_Read_Exe),
		.Reg_Write_Exe			(Reg_Write_Exe),
		.WB_Sel_Exe				(WB_Sel_Exe),
		.Write_Reg_Exe			(Write_Reg_Exe),
		.halt_Exe				(halt_Exe));
		
	Execute execute (
		.ALU_B_Src				(ALU_B_Src_Exe), 
		.ALU_OP_Code			(ALU_OP_Code_Exe), 
		.Pass_Thr_Sel			(Pass_Thr_Sel_Exe), 
		.Reg_1_Data				(Reg_1_Data_Exe), 
		.Reg_2_Data				(Reg_2_Data_Exe), 
		.Reg_1_Src				(Reg_1_Src_Exe), 
		.Reg_2_Src				(Reg_2_Src_Exe), 
		.Immediate				(Immediate_Exe), 
		.PC2					(PC2_Exe), 
		.A_Forward				(A_Forward), 
		.B_Forward				(B_Forward), 
		.A_Forward_Data			(A_Forward_Data), 
		.B_Forward_Data			(B_Forward_Data), 
		.ALU_Result				(ALU_Result_Exe),
		.Reg_2_Data_For			(Reg_2_Data_For_Exe));
   
	Execute_Memory_Blade ex_me_blade (
		.clk					(clk),
		.rst					(rst),
		.Flush					(Flush_EXME),
		.Stall					(Stall_EXME),
		.Mem_Write_Exe			(Mem_Write_Exe),
		.Mem_Read_Exe			(Mem_Read_Exe),
		.Reg_2_Data_Exe			(Reg_2_Data_For_Exe),
		.createdump_Exe			(createdump_Exe),
		.ALU_Result_Exe			(ALU_Result_Exe),
		.Reg_Write_Exe			(Reg_Write_Exe),
		.WB_Sel_Exe				(WB_Sel_Exe),
		.Write_Reg_Exe			(Write_Reg_Exe),
		.halt_Exe				(halt_Exe),
		.Mem_Write_Mem			(Mem_Write_Mem),
		.Reg_2_Data_Mem			(Reg_2_Data_Mem),
		.createdump_Mem			(createdump_Mem),
		.ALU_Result_Mem			(ALU_Result_Mem),
		.Reg_Write_Mem			(Reg_Write_Mem),
		.Mem_Read_Mem			(Mem_Read_Mem),
		.WB_Sel_Mem				(WB_Sel_Mem),
		.Write_Reg_Mem			(Write_Reg_Mem),
		.halt_Mem				(halt_Mem));
	
	Memory memory (
		.clk					(clk),
		.rst					(rst),
		.createdump				(createdump_WB),
		.Mem_Write				(Mem_Write_Mem),
		.Mem_Read				(Mem_Read_Mem),
		.Address				(ALU_Result_Mem),
		.Data					(Reg_2_Data_Mem),
		.Mem_Data				(Mem_Data_Mem)
		.Mem_Stall				(Mem_Stall)
		.err							(Mem_err));
	
	Memory_Writeback_Blade me_wb_blade (
		.clk					(clk),
		.rst					(rst),
		.Flush					(Flush_MEWB),
		.Stall					(Stall_MEWB),
		.createdump_Mem			(createdump_Mem),
		.ALU_Result_Mem			(ALU_Result_Mem), 
		.Reg_Write_Mem			(Reg_Write_Mem),
		.Mem_Data_Mem			(Mem_Data_Mem), 
		.WB_Sel_Mem				(WB_Sel_Mem), 
		.Write_Reg_Mem			(Write_Reg_Mem), 
		.halt_Mem				(halt_Mem),
		.createdump_WB			(createdump_WB),
		.ALU_Result_WB			(ALU_Result_WB), 
		.Reg_Write_WB			(Reg_Write_WB), 
		.Mem_Data_WB			(Mem_Data_WB), 
		.WB_Sel_WB				(WB_Sel_WB), 
		.Write_Reg_WB			(Write_Reg_WB), 
		.halt_WB				(halt_WB));
	
	Write_Back writeback(
		.ALU_Result				(ALU_Result_WB), 
		.Mem_Data				(Mem_Data_WB), 
		.Sel					(WB_Sel_WB), 
		.WB						(WB));
   
endmodule