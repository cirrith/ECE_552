/********************************************************************************************************
/		MODULE: Memory
/		PURPOSE: Contains the Memory unit
/
/		INPUTS: clk - Clock
/				rst - Reset
/				createdump - Dump Memory
/				Mem_Write - To Write or not
/				Mem_Read - To Read or not
/				createdump - Dump Memory
/				Address[15:0] - Address to read/write (ALU_Result)
/				Data[15:0] - Data to write to Memory ()
/
/		OUTPUTS: Mem_Read[15:0] - Data read from Memory on memory read
********************************************************************************************************/
module Memory();

	input clk;
	input rst;
	input createdump;

	input Mem_Write;
	input Mem_Read;

	input [15:0] Address;
	input [15:0] Data;

	output [15:0] Mem_Read;

	memory2c Data_Memory(.data_out(Mem_Read), .data_in(Data), .addr(Address), .enable(Mem_Read ^ Mem_Write), .wr(Mem_Write), .createdump(createdump), .clk(clk), .rst(rst));

endmodule