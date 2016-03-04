/********************************************************************************************************
/		MODULE: ALU
/		PURPOSE: Given two 16-bit inputs and an opcode calculate the operation specified by the opcode.
/			The result of the opeation is outputed on result and the status bits are set. ALU has a 
/			total of 8 operations it can perform
/
/				111: Shift Right Logical 	| A >> B (lowest 4 bits)
/				110: Rotate Right 			| A >> (rotate) B (lowest 4 bits)
/				101: Shift Left Logical 	| A << B (lowest 4 bits)
/				100: Rotate Left 			| A << (rotate) B (lowest 4 bits)
/				011: ANDN					| A AND ~B
/				010: XOR					| A XOR B
/				001: Subtract				| B - A
/				000: Add					| A + B
/
/		INPUTS: A[15:0] - First Operand
/				B[15:0] - Second Operand
/				OP_Code[2:0] - Denotes which operation
/
/		OUTPUTS: Result[15:0] - Result of Operation
/				 CF - Carry Flag
/				 ZF - Zero Flag
/				 SF - Sign Flag
********************************************************************************************************/

module ALU (A, B, OP_Code, Result, CF, ZF, SF);

input [15:0] A;
input [15:0] B;
input [3:0]  OP_Code;

output [15:0] Result;
output CF;
output ZF;
output SF;

wire [15:0] Shifter;

reg [15:0] case_out;

always @ (OP_Code, A, B) begin
	case(OP_Code)
		0: begin //Add
			
		end
		
		1: begin //Subtract
		
		end
		
		2: begin //XOR 
		
		end
		
		3: begin //ANDN
		
		end
		
		4: begin //Rotate Left
		
		end
		
		5: begin //Shift Left
		
		end
		
		6: begin //Rotate Right
		
		end
		
		7: begin //Shift Right
		
		end
		
		8: begin //Equal
		
		end
		
		9: begin //Less Than
		
		end
		
		10: begin //Less Than Equal
		
		end
		
		11: begin //Carry Out
		
		end
		
		12: begin //FLip
		
		end
		
		13: begin //B pass through
		
		end
		
		14: begin //Move Bottom
		
		end
		
	endcase
	
end

endmodule