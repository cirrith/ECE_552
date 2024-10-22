/********************************************************************************************************
/		MODULE: Register_File_Input
/		PURPOSE: Select which portion of the instruction is used as the destination register
/
/		INPUTS: 
/				Poss_Des - Possible Destination encoded in instruction
/					00 - Rd (Immediate) [7:5] or [5:3]
/					01 - Rd (Register) [4:2] or [2:0]
/					10 - Rs [10:8] or [8:6]
/					11 - R7
/					
/				Write_Reg_Sel - Input from Processor Control, which one is passed through
/
/		OUTPUTS: 
/				Write_Reg - Register to be written to
********************************************************************************************************/
module Register_File_Input (Poss_Des, Write_Reg_Sel, Write_Reg);

input [8:0] Poss_Des; 
input [1:0] Write_Reg_Sel; //Destination select

output [2:0] Write_Reg; //Destination to be written to

reg [2:0] case_out;

assign Write_Reg = case_out;

always @ * begin
	case(Write_Reg_Sel)
		2'h0: begin
			case_out = Poss_Des[5:3];
		end
		
		2'h1: begin
			case_out = Poss_Des[2:0];
		end
		
		2'h2: begin
			case_out = Poss_Des[8:6];
		end
		
		3'h3: begin
			case_out = 3'h7;
		end
	endcase
end

endmodule 
		