/********************************************************************************************************
/		MODULE: Branch_Logic
/		PURPOSE: Given the comparison code and the flags from the ALU determine if a branch should be taken or not
/
/		INPUTS: Comp_Code[1:0] - Comparison Codes
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				ZF - Zero Flag
/				LT - Less Than Flag
/				
/		OUTPUTS: Branch - To branch or not, that is the question
********************************************************************************************************/
module Branch_Logic(Comp_Code, ZF, LT, Branch);

	input [1:0] Comp_Code;
	input ZF;
	input LT;
	
	output reg Branch;
	
	always @ (*) begin
		case(Comp_Code)
			2'h0: begin
				Branch = ZF ? 1'b1 : 1'b0;
			end
			
			2'h1: begin
				Branch = !ZF ? 1'b1 : 1'b0;
			end
			
			2'h2: begin
				Branch = LT ? 1'b1 : 1'b0;
			end
			
			2'h3: begin
				Branch = ZF ? 1'b1 : (!LT ? 1'b1 : 1'b0);
			end
		endcase
	end 

endmodule 