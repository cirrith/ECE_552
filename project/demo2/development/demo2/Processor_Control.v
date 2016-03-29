/********************************************************************************************************
/		MODULE: Processor_Control
/		PURPOSE: Given the instruction code to be performed, create the right control signals to propigate
			through the single cycle processor in order to perform that instruction.
/
/
/		INPUTS: OP_Code - Instruction to be performed
/					00000 xxxxxxxxxxx	HALT	Cease instruction issue, dump memory state to file
/					00001 xxxxxxxxxxx	NOP	None
/					01000 sss ddd iiiii		ADDI Rd, Rs, immediate	Rd <- Rs + I(sign ext.)
/					01001 sss ddd iiiii		SUBI Rd, Rs, immediate	Rd <- I(sign ext.) - Rs
/					01010 sss ddd iiiii		XORI Rd, Rs, immediate	Rd <- Rs XOR I(zero ext.)
/					01011 sss ddd iiiii		ANDNI Rd, Rs, immediate	Rd <- Rs AND ~I(zero ext.)
/					10100 sss ddd iiiii		ROLI Rd, Rs, immediate	Rd <- Rs <<(rotate) I(lowest 4 bits)
/					10101 sss ddd iiiii		SLLI Rd, Rs, immediate	Rd <- Rs << I(lowest 4 bits)
/					10110 sss ddd iiiii		RORI Rd, Rs, immediate	Rd <- Rs >>(rotate) I(lowest 4 bits)
/					10111 sss ddd iiiii		SRLI Rd, Rs, immediate	Rd <- Rs >> I(lowest 4 bits)
/					10000 sss ddd iiiii		ST Rd, Rs, immediate	Mem[Rs + I(sign ext.)] <- Rd
/					10001 sss ddd iiiii		LD Rd, Rs, immediate	Rd <- Mem[Rs + I(sign ext.)]
/					10011 sss ddd iiiii		STU Rd, Rs, immediate	Mem[Rs + I(sign ext.)] <- Rd, Rs <- Rs + I(sign ext.)
/					11001 sss xxx ddd xx	BTR Rd, Rs	Rd[bit i] <- Rs[bit 15-i] for i=0..15
/					11011 sss ttt ddd 00	ADD Rd, Rs, Rt	Rd <- Rs + Rt
/					11011 sss ttt ddd 01	SUB Rd, Rs, Rt	Rd <- Rt - Rs
/					11011 sss ttt ddd 10	XOR Rd, Rs, Rt	Rd <- Rs XOR Rt
/					11011 sss ttt ddd 11	ANDN Rd, Rs, Rt	Rd <- Rs AND ~Rt
/					11010 sss ttt ddd 00	ROL Rd, Rs, Rt	Rd <- Rs << (rotate) Rt (lowest 4 bits)
/					11010 sss ttt ddd 01	SLL Rd, Rs, Rt	Rd <- Rs << Rt (lowest 4 bits)
/					11010 sss ttt ddd 10	ROR Rd, Rs, Rt	Rd <- Rs >> (rotate) Rt (lowest 4 bits)
/					11010 sss ttt ddd 11	SRL Rd, Rs, Rt	Rd <- Rs >> Rt (lowest 4 bits)
/					11100 sss ttt ddd xx	SEQ Rd, Rs, Rt	if (Rs == Rt) then Rd <- 1 else Rd <- 0
/					11101 sss ttt ddd xx	SLT Rd, Rs, Rt	if (Rs < Rt) then Rd <- 1 else Rd <- 0
/					11110 sss ttt ddd xx	SLE Rd, Rs, Rt	if (Rs <= Rt) then Rd <- 1 else Rd <- 0
/					11111 sss ttt ddd xx	SCO Rd, Rs, Rt	if (Rs + Rt) generates carry out then Rd <- 1 else Rd <- 0
/					01100 sss iiiiiiii		BEQZ Rs, immediate	if (Rs == 0) then PC <- PC + 2 + I(sign ext.)
/					01101 sss iiiiiiii		BNEZ Rs, immediate	if (Rs != 0) then PC <- PC + 2 + I(sign ext.)
/					01110 sss iiiiiiii		BLTZ Rs, immediate	if (Rs < 0) then PC <- PC + 2 + I(sign ext.)
/					01111 sss iiiiiiii		BGEZ Rs, immediate	if (Rs >= 0) then PC <- PC + 2 + I(sign ext.)
/					11000 sss iiiiiiii		LBI Rs, immediate	Rs <- I(sign ext.)
/					10010 sss iiiiiiii		SLBI Rs, immediate	Rs <- (Rs << 8) | I(zero ext.)
/					00100 ddddddddddd		J displacement	PC <- PC + 2 + D(sign ext.)
/					00101 sss iiiiiiii		JR Rs, immediate	PC <- Rs + I(sign ext.)
/					00110 ddddddddddd		JAL displacement	R7 <- PC + 2, PC <- PC + 2 + D(sign ext.)
/					00111 sss iiiiiiii		JALR Rs, immediate	R7 <- PC + 2 PC <- Rs + I(sign ext.)
/					00010 siic Rs			produce IllegalOp exception. Must provide one source register.
/					00011 xxxxxxxxxxx		NOP / RTI	PC <- EPC
/
/		OUTPUTS: 
********************************************************************************************************/
module Processor_Control (OP_Code, OP_Min, Write_Reg_Sel, Reg_Write, PC_Code, Comp_Code, ALU_OP_Code, ALU_B_Src, Pass_Thr_Sel, Imm_Sel, Mem_Read, Mem_Write, WB_Sel, createdump, halt);

	input [4:0] OP_Code;
	input [1:0] OP_Min;

	output reg [1:0]	Write_Reg_Sel;
	output reg 			Reg_Write;
	output reg [1:0]	PC_Code;
	output reg [1:0]	Comp_Code;
	output reg [3:0]	ALU_OP_Code;
	output reg 			ALU_B_Src;
	output reg 			Pass_Thr_Sel;
	output reg [1:0]	Imm_Sel;
	output reg 			Mem_Read;
	output reg 			Mem_Write;
	output reg 			WB_Sel;
	output reg 			createdump;
	output reg 			halt;

always @ (OP_Code, OP_Min) begin
	Write_Reg_Sel = 2'h0;
	Reg_Write = 1'h0;
	PC_Code = 2'h0;
	Comp_Code = 2'h0;
	ALU_OP_Code = 4'h0;
	ALU_B_Src = 1'h0;
	Pass_Thr_Sel = 1'h0;
	Imm_Sel = 2'h0;
	Mem_Read = 1'h0;
	Mem_Write = 1'h0;
	WB_Sel = 1'h0;
	createdump = 1'h0;
	halt = 1'h0;
/*	
	Write_Reg_Sel [1:0]
		00 - Rd (Immediate) [7:5]
		01 - Rd (Register) [4:2]
		10 - Rs [10:8]
		11 - R7	
		
	Reg_Write - Write to Register
		0 - No Write
		1 - Write
	
	PC_Code[1:0] - Determine how the jump/branch PC is calculated
		00 - Standard Operation
		01 - Jump (Rs + Immediate)
		10 - Branch (PC + 2 + Immediate)
		11 - Jump (PC + 2 + Immediate)
		
	Comp_Code [1:0] - Comparison Codes
		00 - Equal
		01 - Not Equal
		10 - Less Than
		11 - Greater Than or Equal
		
	ALU_OP_Code = 0 // Add
	ALU_OP_Code = 1 // Subtract
	ALU_OP_Code = 2 // XOR
	ALU_OP_Code = 3 // ANDN
	ALU_OP_Code = 4 // Rotate Left
	ALU_OP_Code = 5 // Shift Left Logical
	ALU_OP_Code = 6 // Rotate Right
	ALU_OP_Code = 7 // Shift Right Logical
	ALU_OP_Code = 8 // Equal
	ALU_OP_Code = 9 // Less Than
	ALU_OP_Code = 10 A // Less Than or Equal
	ALU_OP_Code = 11 B // Carry Out
	ALU_OP_Code = 12 C // Flip
	ALU_OP_Code = 13 D // Pass Through
	ALU_OP_Code = 14 E // SLBI
	ALU_OP_Code = 15 F // PC + 2 Possibly Unused
	
	ALU_B_Src -
		0 = Register Source (Forwarding will determine from where)
		1 = Immediate Source (Already determined in Decode Stage)

	Pass_Thr_Sel - Which Src to pass through when pass through is selected
		0 = Pass through A
		1 = Pass through B
	
	Imm_Sel[1:0] - Select bits for output
		00 - 5 Bit Sign Extended
		01 - 5 Bit Zero Extended
		10 - 8 Bit Sign Extended
		11 - 11 Bit Sign Extended
		
	Mem_Read - Well
		0 - No Read
		1 - Read
		
	Mem_Write - Duh
		0 - No Write
		1 - Write
	
	WB_Sel
		0 - ALU
		1 - Memory
		
	createdump - Dump memory to things
		0 - No dump
		1 - Yes dump
		
	halt - If the processor is halted
		0 - Not halt
		1 - halt (This is complex because we have to let the other stages finish) Put halt signal at end of pipeline
			
	*/
	
	case(OP_Code)
		5'b00000: begin //HALT !!!!!!!
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			//PC_Code = 2'h0; ****Make sure to Stall****
			//Comp_Code = 2'h0;
			//ALU_OP_Code = 4'h0;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			createdump = 1'h1;
			halt = 1'h1;
		end
		
        5'b00001: begin //NOP
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			//ALU_OP_Code = 4'h0;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b01000: begin //ADDI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h0;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
        5'b01001: begin //SUBI			
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h1;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b01010: begin //XORI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h2;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h1;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
        5'b01011: begin //ANDNI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h3;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h1;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b10100: begin //ROLI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h4;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
        5'b10101: begin //SLLI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h5;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b10110: begin //RORI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h6;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
        5'b10111: begin //SRLI
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h7;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b10000: begin //ST TODO: Check
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h0;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			Mem_Write = 1'h1;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
        5'b10001: begin //LD
			Write_Reg_Sel = 2'h0;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h0;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			Mem_Read = 1'h1;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h1;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b10011: begin //STU
			Write_Reg_Sel = 2'h2;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h0;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			Mem_Write = 1'h1;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
        5'b11001: begin //BTR
			Write_Reg_Sel = 2'h1;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hC;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b11011: begin //ADD|SUB|XOR|ANDN
			case(OP_Min)
				2'b00: begin //ADD
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h0;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
				2'b01: begin //SUB
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h1;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
				2'b10: begin //XOR
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h2;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
				2'b11: begin //ANDN
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h3;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
			endcase
		end
		
		5'b11010: begin //ROL|SLL|ROR|SRL
			case(OP_Min)
				2'b00: begin //ROL
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h4;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
				2'b01: begin //SLL
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h5;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
				2'b10: begin //ROR
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h6;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
				2'b11: begin //SRL
					Write_Reg_Sel = 2'h1;
					Reg_Write = 1'h1;
					//PC_Code = 2'h0;
					//Comp_Code = 2'h0;
					ALU_OP_Code = 4'h7;
					ALU_B_Src = 1'h0;
					//Pass_Thr_Sel = 1'h0;
					//Imm_Sel = 2'h0;
					//Mem_Read = 1'h0;
					//Mem_Write = 1'h0;
					WB_Sel = 1'h0;
					//createdump = 1'h0;
					//halt = 1'h0;
				end
				
			endcase
		end
		
		5'b11100: begin //SEQ
			Write_Reg_Sel = 2'h1;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h8;
			ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b11101: begin //SLT
			Write_Reg_Sel = 2'h1;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'h9;
			ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b11110: begin //SLE
			Write_Reg_Sel = 2'h1;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hA;
			ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b11111: begin //SCO
			Write_Reg_Sel = 2'h1;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hB;
			ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b01100: begin //BEQZ
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			PC_Code = 2'h2;
			Comp_Code = 2'h0;
			ALU_OP_Code = 4'hD;
			ALU_B_Src = 1'h0;
			Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b01101: begin //BNEZ
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			PC_Code = 2'h2;
			Comp_Code = 2'h1;
			ALU_OP_Code = 4'hD;
			ALU_B_Src = 1'h0;
			Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b01110: begin //BLTZ
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			PC_Code = 2'h2;
			Comp_Code = 2'h2;
			ALU_OP_Code = 4'hD;
			ALU_B_Src = 1'h0;
			Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b01111: begin //BGEZ
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			PC_Code = 2'h2;
			Comp_Code = 2'h3;
			ALU_OP_Code = 4'hD;
			ALU_B_Src = 1'h0;
			Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b11000: begin //LBI
			Write_Reg_Sel = 2'h2;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hD;
			ALU_B_Src = 1'h1;
			Pass_Thr_Sel = 1'h1;
			Imm_Sel = 2'h2;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b10010: begin //SLBI
			Write_Reg_Sel = 2'h2;
			Reg_Write = 1'h1;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hE;
			ALU_B_Src = 1'h1;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h2;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b00100: begin //J
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			PC_Code = 2'h3;
			//Comp_Code = 2'h0;
			//ALU_OP_Code = 4'h0;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h3;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b00101: begin //JR
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			PC_Code = 2'h1;
			//Comp_Code = 2'h0;
			//ALU_OP_Code = 4'h0;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h2;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b00110: begin //JAL
			Write_Reg_Sel = 2'h3;
			Reg_Write = 1'h1;
			PC_Code = 2'h3;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hF;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h3;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b00111: begin //JALR
			Write_Reg_Sel = 2'h3;
			Reg_Write = 1'h1;
			PC_Code = 2'h1;
			//Comp_Code = 2'h0;
			ALU_OP_Code = 4'hF;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			Imm_Sel = 2'h2;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b00010: begin //siic FIGURE OUT
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			//ALU_OP_Code = 4'h0;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
		
		5'b00011: begin //NOP / RTI FIGURE OUT
			//Write_Reg_Sel = 2'h0;
			//Reg_Write = 1'h0;
			//PC_Code = 2'h0;
			//Comp_Code = 2'h0;
			//ALU_OP_Code = 4'h0;
			//ALU_B_Src = 1'h0;
			//Pass_Thr_Sel = 1'h0;
			//Imm_Sel = 2'h0;
			//Mem_Read = 1'h0;
			//Mem_Write = 1'h0;
			//WB_Sel = 1'h0;
			//createdump = 1'h0;
			//halt = 1'h0;
		end
	endcase
end

endmodule