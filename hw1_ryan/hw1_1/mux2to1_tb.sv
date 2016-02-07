module mux2to1_tb();

reg clockA, clockB, clockS;
wire out;

mul2to1 Test(.out(out), .InA(clockA), .InB(clockB), .S(clockS));

initial begin
$display("Multiplexer 2-1 Test Bench");
clockA = 0;
clockB = 0;
clockS = 0;
end

always begin
#5 clockA = ~clockA;
end

always begin
#10 clockB = ~clockB;
end

always begin 
#20 clockS = ~clockS;
end
endmodule
