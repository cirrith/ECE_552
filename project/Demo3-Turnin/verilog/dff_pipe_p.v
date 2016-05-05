/********************************************************************************************************
/		MODULE: dff_pipe_p
/		PURPOSE: dff for pipeline stages with prst
/
/		INPUTS: 
/				clk - Clock
/				prst - Preset
/				Flush - Clear the register ??Asynchrnous??
/				Stall - Keep values
/				d - Value to store
/
/		OUTPUTS:
/				q - Value stored
/
/		INTERNAL:
/				d_in - Input to d with all stall/flush/rst logic in place
********************************************************************************************************/
module dff_pipe_p(clk, prst, Flush, Stall, d, q);

input clk;
input prst;
input Flush;
input Stall;
input d;

output q;

wire d_in;

assign d_in = (prst | Flush) | (Stall ? q : d);

dff pipe(.q(q), .d(d_in), .clk(clk), .rst(1'b0));   //TODO: Check this logic out, d

endmodule