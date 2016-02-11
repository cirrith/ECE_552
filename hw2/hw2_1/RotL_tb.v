module RotL_tb();

reg [15:0] In;
reg [3:0] Amt;
wire [15:0] Out;


RotL hey_o(In, Amt, Out);

initial begin

In = 16'hA3A3;
Amt = 4'h0;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

#5;
Amt = Amt + 1'b1;

end


endmodule