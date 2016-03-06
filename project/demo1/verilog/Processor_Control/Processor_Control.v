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
module Processor_Control(OP_Code);

input [4:0] OP_Code;

output PC_Write;
output [2:0] PC_Code; 			//Determine
output [1:0] Comp_Code;
output [1:0] Write_Back_Sel; 	//Determine
output Mem_Write;
output Mem_Read;
output [3:0] ALU_OP; 			//Determine
output ALU_Src;					//Determine
output Reg_Write;
output [1:0] Write_Reg_Sel;		//Confirm

always @ (OP_Code) begin
	case(OP_Code)
		5'b		: begin
		
		end
        5'b		: begin
		
		end
		5'b		: begin
		
		end
        5'b		: begin
		
		end
		5'b		: begin
		
		end
        5'b		: begin

		end
		5'b		: begin

		end
        5'b		: begin

		end
		5'b		: begin

		end
        5'b		: begin

		end
		5'b		: begin

		end
        5'b		: begin

		end
		5'b		: begin

		end
        5'b		: begin

		end
		5'b		: begin

		end
        5'b		: begin

		end
		5'b		: begin

		end
        5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin

		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
		5'b		: begin
		
		end
	endcase
end

endmodule
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		