module shift_tb();

reg [15:0]In;

reg [3:0] cnt;

reg [1:0] op;

reg [16:0] i;

wire [15:0] out;

shift2 sh (.in(In), .sh(cnt[1]), .op(op), .out(out));
//shifter sh (.In(In), .Cnt(cnt), .Op(op), .Out(out));

initial
begin
In = 16'h0000;
cnt = 4'b0000;
op = 2'b00;
end

initial 
begin
#5 for(i = 0; i < 256; i = i + 1)
begin
	# 5In = In + 1;
end

cnt = cnt + 1;

In = 16'h0000;

#5 for(i = 0; i < 256; i = i + 1)
begin
	#5 In = In + 1;
end

cnt = cnt + 1;

In = 16'h0000;

#5 for(i = 0; i < 256; i = i + 1)
begin
	#5 In = In + 1;
end

cnt = cnt + 2;

In = 16'h0000;

#5 for(i = 0; i < 256; i = i + 1)
begin
	#5 In = In + 1;
end

cnt = cnt + 4;

In = 16'h0000;

#5 for(i = 0; i < 256; i = i + 1)
begin
	#5 In = In + 1;
end

end

endmodule 