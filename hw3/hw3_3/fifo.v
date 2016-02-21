/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module fifo(/*AUTOARG*/
   // Outputs
   data_out, fifo_empty, fifo_full, data_out_valid, err, 
   // Inputs
   data_in, data_in_valid, pop_fifo, clk, rst
   );
   input [63:0] data_in;
   input        data_in_valid;
   input        pop_fifo;
   
   input        clk;
   input        rst;
   output [63:0] data_out;
   output        fifo_empty;
   output        fifo_full;
   output        data_out_valid;
   output        err;

   wire [3:0] sel;
   wire [3:0] wri;
   
   wire [63:0] wr_reg0;
   wire [63:0] wr_reg1;
   wire [63:0] wr_reg2;
   wire [63:0] wr_reg3;
   
   wire [63:0] rd_reg0;
   wire [63:0] rd_reg1;
   wire [63:0] rd_reg2;
   wire [63:0] rd_reg3;
   
   register #(64) FIFO0(.clk(clk), .rst(rst), .write(wri[0]), .wdata(wr_reg0), .rdata(rd_reg0));
   register #(64) FIFO1(.clk(clk), .rst(rst), .write(wri[1]), .wdata(wr_reg1), .rdata(rd_reg1));
   register #(64) FIFO2(.clk(clk), .rst(rst), .write(wri[2]), .wdata(wr_reg2), .rdata(rd_reg2));
   register #(64) FIFO3(.clk(clk), .rst(rst), .write(wri[3]), .wdata(wr_reg3), .rdata(rd_reg3));
   
   counter control(.valid(data_in_valid), .pop(pop_fifo), .clk(clk), .rst(rst), .sel(sel), .write(wri), .full(fifo_full), .empty(fifo_empty), .datavalid(data_out_valid));
   
   assign wr_reg0 = sel[0] ? rd_reg1 : data_in;
   assign wr_reg1 = sel[1] ? rd_reg2 : data_in;
   assign wr_reg2 = sel[2] ? rd_reg3 : data_in;
   assign wr_reg3 = sel[3] ? 0 : data_in;
   
   assign data_out = rd_reg0;
   
endmodule
// DUMMY LINE FOR REV CONTROL :1:
