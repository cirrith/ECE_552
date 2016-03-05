/********************************************************************************************************
/		MODULE: PC
/		PURPOSE: Store the Program Counter and when write is high and at posedge of clk, store the new Program Counter
/
/		INPUTS: clk - Clock
/				rst - Reset
/				New_PC [15:0] - PC to Store
/				Write - To write or not to write
/
/		OUTPUTS: Curr_PC - PC that is currently stored
********************************************************************************************************/
module PC (clk, rst, New_PC, Write, Curr_PC);

	input [15:0] New_PC;
	input Write;

	output [15:0] Curr_PC;

	wire [15:0] q;
	wire [15:0] d;

	dff PC[15:0](.q(q), .d(d), .clk(clk), .rst(rst));

	assign Curr_PC = q;

	assign PC = Write ? New_PC : Curr_PC;

endmodule