/********************************************************************************************************
/		MODULE: PC_Logic
/		PURPOSE: Given the a PC code from the processor controller determine what signals to output to get
/			the correct next PC
/
/		INPUTS: PC_Code[2:0] - Control code from the processor controller
/				Comp_Code[1:0] - Compare code for which conditions signify a branch
/				Curr_PC[15:0] - Current PC
/				EQ - Equal flag from ALU
/				LT - Less than flag from ALU
/				GTE - Greater than or equal from ALU
/				Rs[2:0] - For LBI & SLBI instructions (NEED TO SIGN EXTEND)
/				Im8[15:0] - Extended Immediate
/				Dis[15:0] - Displacement for Jump instructions
/
/		OUTPUTS: PC2[15:0] - Increment PC for ALU
/				 Nxt_PC[15:0] - Current PC for Instruction Memory
/				 
********************************************************************************************************/
module PC_Logic (PC_Code, Comp_Code, Curr_PC, EQ, LT, Rs, Im8, Dis, PC2, Nxt_PC);

input [15:0] Curr_PC;
input [15:0] Im8;
input [15:0] Dis;
input [15:0] Rs;
input [2:0] PC_Code;
input [1:0] Comp_Code;
input EQ;
input LT;

output [15:0] PC2;
output [15:0] Nxt_PC;

reg [15:0] A_in;
reg [15:0] B_in;
reg branch;
wire [15:0] result;

CLA adder(.A(A_in), .B(B_in), .Ci(1'0), .S(result), .Co());
PC_inc pc2(.Curr_PC(Curr_PC), .Inc_PC(PC2));

assign Nxt_PC = case_out;

always @ (PC_Code, PC2, Im8, Dis, Rs) begin
	case(PC_Code)
		3'b000: begin
			case_out = PC2;
		end
		3'b001: begin
			case(Comp_Code) //Compare the conditnal codes
				2'b00: begin //Equal
					branch = ZF ? 1'b1 : 1'b0;
				end
				2'b01: begin //!Equal
					branch = ZF ? 1'b0 : 1'b1;
				end
				2'b10: begin //Less Than
					branch = LT ? 1'b1 : 1'b0;
				end
				2'b11: begin //Greater than or equal
					branch = LT ? 1'b0 : 1'b1;
				end
			endcase
			A_in = PC2;
			B_in = branch ? Im8 : 16'h0000; //If condital code is meet then branch
			case_out = result;
		end
		3'b010: begin
			A_in = Rs;
			B_in = Im8;
			case_out = result;
		end
		3'b011: begin
			A_in = PC2;
			B_in = Dis;
			case_out = result;
		end
		3'b100: begin
			//case_out = EPC !!!!!!!!!!!!!!
		end
		
		default: begin
			$display("Entered a bad PC_Code");
			$stop;
		end
	endcase
end

endmodule



