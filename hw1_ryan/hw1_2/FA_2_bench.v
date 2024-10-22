module FA_2_bench();

reg [3:0]inputA;
reg [3:0]inputB;

reg cin;

reg [4:0]desired;

reg [4:0]O;

reg error;

wire [3:0]out;
wire co;

FA_2 DUT(.A(inputA), .B(inputB), .CI(cin), .SUM(out), .CO(co));

initial begin
  inputA = 4'b0000;
  inputB = 4'b0000;

  cin = 0;

end

always begin
  #5
  inputA = inputA + 1;
end

always begin
  #10
  inputB = inputB + 1;
end

always begin
  #75
  cin = ~cin;
end

always@(inputA, inputB, cin) begin

assign desired = inputA + inputB + cin;

assign O = {co,out[3:0]} - desired; 

assign error = (|O);

end

endmodule
