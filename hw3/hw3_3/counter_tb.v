module counter_tb();

reg clk;

reg data_in_valid;
reg pop_fifo;
reg rst;

wire [3:0] sel;
wire [3:0] wri;
wire fifo_full;
wire fifo_empty;

counter control(.valid(data_in_valid), .pop(pop_fifo), .clk(clk), .rst(rst), .sel(sel), .write(wri), .full(fifo_full), .empty(fifo_empty));

initial begin
	rst = 1;
	data_in_valid = 0;
	pop_fifo = 0;
	@(negedge clk);
	@(negedge clk);
	rst = 0;
	@(negedge clk);
	data_in_valid = 1;
	#50;
	@(negedge clk);
	data_in_valid = 0;
	pop_fifo = 1;
	#50;
	$finish;

end


initial 
	clk = 0;

always
	#5 clk = ~clk;
	
endmodule 