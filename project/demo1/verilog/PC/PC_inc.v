/********************************************************************************************************
/		MODULE: PC_inc
/		PURPOSE: Increment the PC by 2
/
/
/		INPUTS: Curr_PC - Current Program Counter
/
/		OUTPUTS: Inc_PC - Program Counter + 2
********************************************************************************************************/
module PC_inc(Curr_PC, Inc_PC);

	input [15:0] Curr_PC;

	output [15:0] Inc_PC;

	ALU_CLA Adder(.A(Curr_PC), .B(16'h0002), .Ci(1'b0), .S(Inc_PC), .Co());

endmodule