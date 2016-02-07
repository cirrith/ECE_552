module mux4to1_tb();

reg InA, InB, InC, InD;
reg [1:0]S;
wire out;

mux4to1 DUT (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S), .out(out));

initial begin

InA = 0;
InB = 0;
InC = 0;
InD = 0;

S = 2'b00;

#80

S = 2'b01;

#80

S = 2'b10;

#80

S = 2'b11;
end

always begin
#5
InA = ~InA;

end

always begin
#10
InB = ~InB;

end

always begin
#20
InC = ~InC;

end

always begin 
#40
InD = ~InD;

end

endmodule 


