/********************************************************************************************************
/		MODULE: PC_inc
/		PURPOSE: Increment the PC by 2
/
/		INPUTS: PC - Current Program Counter
/
/		OUTPUTS: PC2 - Program Counter + 2
********************************************************************************************************/
module PC_inc (PC, PC2);

	input [15:0] PC;

	output [15:0] PC2;

	CLA Adder(.A(PC), .B(16'h0002), .Ci(1'b0), .S(PC2), .Cout());

endmodule