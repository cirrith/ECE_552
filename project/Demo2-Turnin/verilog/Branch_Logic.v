/********************************************************************************************************
/		MODULE: Branch_Logic
/		PURPOSE: Given the comparison code and Rs determine if a branch should be taken or not
/
/		INPUTS: 
/				Comp_Code[1:0] - Comparison Codes
/					00 - Equal
/					01 - Not Equal
/					10 - Less Than
/					11 - Greater Than or Equal
/				Reg_1_Data [15:0] - Data to use when determine if a branch should be taken or not.
/				PC_Forward - Use forwarded data for not
/				PC_Forward_Data [15:0] - Data forwarded from memory stage
/				
/		OUTPUTS: 
/				Branch - To branch or not, that is the question
/					
/		INTERNAL:
/				Neg - If data is negative or less than zero or not
/				Zer - If data is zero or not
********************************************************************************************************/
module Branch_Logic(Comp_Code, Reg_1_Data, PC_Det_Forward, PC_Det_Forward_Data, Branch);

	input [1:0] 	Comp_Code;
	input [15:0] 	Reg_1_Data;
	input 			PC_Det_Forward;
	input [15:0]	PC_Det_Forward_Data;
	
	output reg 		Branch;
	
	wire 			Neg;
	wire 			Zer;
	wire [15:0]		Data;
	
	assign Data = PC_Det_Forward ? PC_Det_Forward_Data : Reg_1_Data;
	
	assign Zer = Data == 16'h0000;
	assign Neg = Data[15];
	
	always @ (*) begin
		case(Comp_Code)
			2'h0: begin
				Branch = Zer ? 1'b1 : 1'b0;
			end
			
			2'h1: begin
				Branch = !Zer ? 1'b1 : 1'b0;
			end
			
			2'h2: begin
				Branch = Neg ? 1'b1 : 1'b0;
			end
			
			2'h3: begin
				Branch = Zer ? 1'b1 : (!Neg ? 1'b1 : 1'b0);
			end
		endcase
	end 

endmodule 

//Checked 3/22