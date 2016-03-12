/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (err, clk, rst);

	input clk;
	input rst;

	output err;
	
	//Implement enable for memory??

////////ALU
	wire [3:0] ALU_OP_Code;
	wire [15:0] ALU_Result;
	wire [15:0] A;
	wire [15:0] B_in;
	wire ALU_B_Src;
	wire LT;
	wire EQ;
	
////////Register File
	wire Reg_Write;
	wire [1:0] Write_Reg_Sel;		//Confirm
	wire [15:0] read1data;	//Rs
	wire [15:0] read2data;	//Rd

////////Data Memory
	wire [15:0] memory_out; //Ouput of memory unit
	wire Mem_Read;
	wire Mem_Write;

////////PC Stuff
	wire [2:0] PC_Code;		//Select Next PC
	wire PC_Write;
	wire [15:0] Nxt_PC;
	wire [15:0] Curr_PC;
	wire [1:0] Comp_Code;	//Compare Code
	wire [15:0] PC2;

////////Extender
	wire [15:0] Imm5S;
	wire [15:0] Imm5Z;
	wire [15:0] Imm8S;
	wire [15:0] Dis11;
	
////////Misc.
	wire [15:0] Instruction;
	wire [15:0] writeback;		//Data to write back to register
	wire Write_Back_Sel;
	wire createDump;
	wire Imm_Sign;
	wire halted;
	wire err;
	
	assign B_in = ALU_B_Src ? (Imm_Sign ? Imm5Z : Imm5S) : read2data; //Mux for ALU input
	
	assign writeback = Write_Back_Sel ? memory_out : ALU_Result;
	
	Processor_Control processor_control(.OP_Code(Instruction[4:0]), .OP_Min(Instruction[1:0]), .PC_Write(PC_Write), .PC_Code(PC_Code), .Comp_Code(Comp_Code), .Write_Back_Sel(Write_Back_Sel), .Mem_Write(Mem_Write), .Mem_Read(Mem_Read), .ALU_OP_Code(ALU_OP_Code), .ALU_B_Src(ALU_B_Src), .Reg_Write(Reg_Write), .Write_Reg_Sel(Write_Reg_Sel), .Imm_Sign(Imm_Sign), .createdump(createDump), .halted(halted));
	
	PC_Logic pc_logic(.PC_Code(PC_Code), .Comp_Code(Comp_Code), .Curr_PC(Curr_PC), .EQ(EQ), .LT(LT), .Rs(read1data), .Im8(Imm8S), .Dis(Dis11), .PC2(PC2), .Nxt_PC(Nxt_PC));
	
	PC pc(.clk(clk), .rst(rst), .New_PC(Nxt_PC), .Write(PC_Write), .Curr_PC(Curr_PC));
	
	Extender extender(.Extend(Instruction[10:0]), .Imm5S(Imm5S), .Imm5Z(Imm5Z), .Imm8S(Imm8S), .Dis11(Dis11));
	
	memory2c instruction_memory(.data_out(Instruction), .data_in(), .addr(Curr_PC), .enable(1'b1), .wr(1'b0), .createdump(createDump), .clk(clk), .rst(rst));
	
	Register_File_Input register_file_input(.Poss_Des(Instruction[10:2]), .Write_Back_Sel(Write_Back_Sel), .Write_Reg(Write_Reg));
	
	Register_File register_file(.clk(clk), .rst(rst), .read1data(read1data), .read2data(read2data), .err(err), .read1regsel(Instruction[10:8]), .read2regsel(Instruction[7:5]), .writeregsel(Write_Reg), .writedata(writeback), .write(Reg_Write));
	
	ALU alu(.A(read1data), .B(B_in), .OP_Code(ALU_OP_Code), .PC2(PC2), .Result(ALU_Result), .LT(LT), .ZF(ZF));
	
	memory2c data_memory(.data_out(memory_out), .data_in(read2data), .addr(ALU_Result), .enable(Mem_Read), .wr(Mem_Write), .createdump(createDump), .clk(clk), .rst(rst));
 
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
