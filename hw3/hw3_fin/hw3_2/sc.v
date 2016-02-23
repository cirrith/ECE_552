/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module sc( clk, rst, ctr_rst, out, err);
   input clk;
   input rst;
   input ctr_rst;
   output [2:0] out;
   output err;

   reg [2:0] state = 0;

   reg error;
   
   assign out = state;
   
   assign err = error;
   
   always@( posedge clk) begin
	case ({rst,state})
		0: begin
				state <= !ctr_rst ? (state + 1) : 0;
				error <= 0;
			end
		1: begin
				state <= !ctr_rst ? (state + 1) : 0;
				error <= 0;
			end
		2: begin
				state <= !ctr_rst ? (state + 1) : 0;
				error <= 0;
			end
		3: begin
				state <= !ctr_rst ? (state + 1) : 0;
				error <= 0;
			end
		4: begin
				state <= !ctr_rst ? (state + 1) : 0;
				error <= 0;
			end
		5: begin
				state <= !ctr_rst ? state : 0;
				error <= 0;
			end
		6: begin
			error <= 1;
			$display ("Entered Wrong State");
			end
		7: begin 
			error <= 1;
			$display ("Entered Wrong State");
			end
		default: begin
			state <= 0;
		end
	endcase
	end
endmodule

// DUMMY LINE FOR REV CONTROL :1:
