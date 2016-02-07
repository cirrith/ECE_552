module FA_bench();

reg InA;
reg InB;
reg Cin;

wire S;
wire Cout;

FA DUT(.A(InA), .B(InB), .Cin(Cin), .S(S), .Cout(Cout));

initial begin
InA = 0;
InB = 0;
Cin = 0;
end

always begin
#5 InA = ~InA;
end

always begin 
#10 InB = ~InB;
end

always begin 
#20 Cin = ~Cin;
end

endmodule 