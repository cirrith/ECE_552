/********************************************************************************************************
/		MODULE: Memory
/		PURPOSE: Contains the Memory unit
/
/		INPUTS: 
/				clk - Clock
/				rst - Reset
/				createdump - Dump Memory
/				Mem_Write - To Write or not
/				Mem_Read - To Read or not
/				Address[15:0] - Address to read/write (ALU_Result)
/				Data[15:0] - Data to write to Memory (Reg_2_Data)
/
/		OUTPUTS: 
/				Mem_Data[15:0] - Data read from Memory on memory read
********************************************************************************************************/
module Memory (clk, rst, createdump, Mem_Write, Mem_Read, Address, Data, Mem_Data);

	input 			clk;
	input 			rst;
	input 			createdump;

	input 			Mem_Write;
	input 			Mem_Read;

	input [15:0] 	Address;
	input [15:0] 	Data;

	output [15:0] 	Mem_Data;

	memory2c Data_Memory(.data_out(Mem_Data), .data_in(Data), .addr(Address), .enable(Mem_Read ^ Mem_Write), .wr(Mem_Write), .createdump(createdump), .clk(clk), .rst(rst));

endmodule

//Checked 3/22