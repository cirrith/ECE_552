module ALU_tb();

logic [15:0] A;
logic [15:0] B;
logic [3:0] OP_Code;
logic [15:0] Result;
logic LT;
logic ZF;

logic [3:0] i;

ALU alu(.A(A), .B(B), .OP_Code(OP_Code), .Result(Result), .LT(LT), .ZF(ZF));

initial begin

A = $random;
B = $random;
OP_Code = 0;

for (i = 0; i < 14; i = i + 1) begin
	#50 OP_Code = OP_Code + 1;
end

end

endmodule	