module dff_test();

reg d1;
reg clk;
reg Reset;

wire out;

dff DUT(.q(out), .d(d1), .clk(clk), .rst(Reset));

initial begin

d1 = 0;
clk = 0;
Reset = 0;
#50;
Reset = 1;
#20;
Reset = 0;
end


always begin
#5 clk = ~clk;
end

always begin 
#10 d1 = ~d1;
end

endmodule 