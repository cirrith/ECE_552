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
/		OUTPUTS: Write_Reg - Register to be written to
********************************************************************************************************/
module Processor_Control (OP_Code, OP_Min, PC_Write, PC_Code, Comp_Code, Write_Back_Sel, Mem_Write, Mem_Read, ALU_OP_Code, ALU_B_Src, Reg_Write, Write_Reg_Sel, Imm_Sign, createDump);

input [4:0] OP_Code;
input [1:0] OP_Min;

output PC_Write;
output [2:0] PC_Code; 			//Determine
output [1:0] Comp_Code;
output Write_Back_Sel; 			//Determine
output Mem_Write;
output Mem_Read;
output [3:0] ALU_OP_Code; 			//Determine
output ALU_B_Src;					//Determine
output Reg_Write;
output [1:0] Write_Reg_Sel;		//Confirm
output createDump;
output Imm_Sign;

always @ (OP_Code) begin
	PC_Write = 0;
	PC_Code = 0;
	Comp_Code = 0;
	Write_Back_Sel = 0;
	Mem_Write = 0;
	Mem_Read = 0;
	ALU_OP_Code = 0;
	ALU_B_Src = 0;
	Reg_Write = 0;
	Write_Reg_Sel = 0;
	Imm_Sign = 0;
	
	PC_Code = 0; //PC + 2
	PC_Code = 1; //Branch (PC + 2 + I)
	PC_Code = 2; //JumpI (RS + I)
	PC_Code = 3; //JumpD (PC + 2 + D)
	PC_Code = 4; //EPC
	PC_Code = 5; //Nothing
	PC_Code = 6; //Nothing
	PC_Code = 7; //Nothing
	
	Comp_Code = 0; //Equal
	Comp_Code = 1; //!Equal
	Comp_Code = 2; //Less Than
	Comp_Code = 3; //Greater Than or Equal
	
	Write_Back_Sel = 0; //ALU
	Write_Back_Sel = 1; //Memory
	
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
	ALU_OP_Code = 10 // Less Than or Equal
	ALU_OP_Code = 11 // Carry Out
	ALU_OP_Code = 12 // Flip
	ALU_OP_Code = 13 // Pass Through
	ALU_OP_Code = 14 // SLBI
	ALU_OP_Code = 15 // PC + 2
	
	ALU_B_Src = 0; // Register
	ALU_B_Src = 1; // Immediate
	
	Write_Reg_Sel = 0; //Rd (Immediate)
	Write_Reg_Sel = 1; //Rd (Register)
	Write_Reg_Sel = 2; //Rs (LBI)
	Write_Reg_Sel = 3; //R7
	
	Imm_Sign = 0; //Sign Extend
	Imm_Sign = 1; //Zero Extend
	
	case(OP_Code)
		5'b00000: begin //HALT !!!!!!!
			//PC_Write = 0;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
        5'b00001: begin //NOP
			//PC_Write = 0;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b01000: begin //ADDI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 0;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
        5'b01001: begin //SUBI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 1;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b01010: begin //XORI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 2;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			Imm_Sign = 1;
		end
        5'b01011: begin //ANDNI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 3;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			Imm_Sign = 1;
		end
		5'b10100: begin //ROLI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 4;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
        5'b10101: begin //SLLI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 5;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b10110: begin //RORI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 6;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
        5'b10111: begin //SRLI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 7;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b10000: begin //ST !
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			Mem_Write = 1;
			//Mem_Read = 0;
			ALU_OP_Code = 0;
			ALU_B_Src = 1;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
        5'b10001: begin //LD
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			Write_Back_Sel = 1;
			//Mem_Write = 0;
			Mem_Read = 1;
			ALU_OP_Code = 0;
			ALU_B_Src = 1;
			Reg_Write = 1;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b10011: begin //STU
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			Mem_Write = 1;
			//Mem_Read = 0;
			ALU_OP_Code = 0;
			ALU_B_Src = 1;
			Reg_Write = 1;
			Write_Reg_Sel = 2;
			//Imm_Sign = 0;
		end
        5'b11001: begin //BTR
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 12;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 1;
			//Imm_Sign = 0;
		end
		5'b11011: begin //ADD|SUB|XOR|ANDN
			case(OP_Min)
				2'b00: begin //ADD
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 0;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
				2'b01: begin //SUB
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 1;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
				2'b10: begin //XOR
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 2;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
				2'b11: begin //ANDN
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 3;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
			endcase
		end
		5'b11010: begin //ROL|SLL|ROR|SRL
			case(OP_Min)
				2'b00: begin //ROL
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 4;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
				2'b01: begin //SLL
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 5;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
				2'b10: begin //ROR
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 6;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
				2'b11: begin //SRL
					PC_Write = 1;
					//PC_Code = 0;
					//Comp_Code = 0;
					Write_Back_Sel = 0;
					//Mem_Write = 0;
					//Mem_Read = 0;
					ALU_OP_Code = 7;
					//ALU_B_Src = 0;
					Reg_Write = 1;
					Write_Reg_Sel = 1;
					//Imm_Sign = 0;
				end
			endcase
		end
		5'b11100: begin //SEQ
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 8;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 1;
			//Imm_Sign = 0;
		end
		5'b11101: begin //SLT
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 9;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 1;
			//Imm_Sign = 0;
		end
		5'b11110: begin //SLE
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 10;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 1;
			//Imm_Sign = 0;
		end
		5'b11111: begin //SCO
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code =11;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 1;
			//Imm_Sign = 0;
		end
		5'b01100: begin //BEQZ
			PC_Write = 1;
			PC_Code = 1;
			Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b01101: begin //BNEZ
			PC_Write = 1;
			PC_Code = 1;
			Comp_Code = 1;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b01110: begin //BLTZ
			PC_Write = 1;
			PC_Code = 1;
			Comp_Code = 2;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b01111: begin //BGEZ
			PC_Write = 1;
			PC_Code = 1;
			Comp_Code =3;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b11000: begin //LBI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 13;
			ALU_B_Src = 1;
			Reg_Write = 1;
			Write_Reg_Sel = 2;
			//Imm_Sign = 0;
		end
		5'b10010: begin //SLBI
			PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 14;
			ALU_B_Src = 1;
			Reg_Write = 1;
			Write_Reg_Sel = 2;
			//Imm_Sign = 0;
		end
		5'b00100: begin //J
			PC_Write = 1;
			PC_Code = 3;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b00101: begin //JR
			PC_Write = 1;
			PC_Code = 2;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b00110: begin //JAL
			PC_Write = 1;
			PC_Code = 3;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 15;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 3;
			//Imm_Sign = 0;
		end
		5'b00111: begin //JALR
			PC_Write = 1;
			PC_Code = 2;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			ALU_OP_Code = 15;
			//ALU_B_Src = 0;
			Reg_Write = 1;
			Write_Reg_Sel = 3;
			//Imm_Sign = 0;
		end
		5'b00010: begin //siic FIGURE OUT
			//PC_Write = 1;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
		5'b00011: begin //NOP / RTI FIGURE OUT
			//PC_Write = 0;
			//PC_Code = 0;
			//Comp_Code = 0;
			//Write_Back_Sel = 0;
			//Mem_Write = 0;
			//Mem_Read = 0;
			//ALU_OP_Code = 0;
			//ALU_B_Src = 0;
			//Reg_Write = 0;
			//Write_Reg_Sel = 0;
			//Imm_Sign = 0;
		end
	endcase
end

endmodule
		
		
		
		
		
