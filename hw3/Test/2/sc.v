/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module sc( clk, rst, ctr_rst, out, err);
   input clk;
   input rst;
   input ctr_rst;
   output [2:0] out;
   output err;

   reg error;
   reg [2:0] nxtstate;
   
   wire [2:0] state;
   
   dff dffreg [2:0] (.q(state), .d(nxtstate), .clk(clk), .rst(rst));
   
   assign err = error;
   
   assign out = state;
   
   always@(clk) begin	
	case ({rst,state})
		0: begin
				nxtstate <= !ctr_rst ? 3'b001 : 0;
				error <= 0;
			end
		1: begin
				nxtstate <= !ctr_rst ? 3'b010 : 0;
				error <= 0;
			end
		2: begin
				nxtstate <= !ctr_rst ? 3'b011 : 0;
				error <= 0;
			end
		3: begin
				nxtstate <= !ctr_rst ? 3'b100 : 0;
				error <= 0;
			end
		4: begin
				nxtstate <= !ctr_rst ? 3'b101 : 0;
				error <= 0;
			end
		5: begin
				nxtstate <= !ctr_rst ? state : 0;
				error <= 0;
			end
		6: begin
			error <= 1;
			$display ("Entered Wrong nxtstate");
			end
		7: begin 
			error <= 1;
			$display ("Entered Wrong nxtstate");
			end
		default: begin
			nxtstate <= 0;
		end
	endcase
	end
endmodule

// DUMMY LINE FOR REV CONTROL :1:
