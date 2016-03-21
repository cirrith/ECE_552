/********************************************************************************************************
/		MODULE: dff_pipe
/		PURPOSE: dff for pipeline stages
/
/		INPUTS: clk - Clock
/				rst - Reset
/				Flush - Clear the register ??Asynchrnous??
/				Stall - Keep values
/				d - Value to store
/
/		OUTPUTS: q - Value stored
********************************************************************************************************/
module dff_pipe(clk, rst, Flush, Stall, d, q);

input clk;
input rst;
input Flush;
input Stall;
input d;

output q;

dff pipe(.q(q), .d(Stall ? q : d), .clk(clk), .rst(Flush | rst));   //TODO: Check this logic out, d

endmodule