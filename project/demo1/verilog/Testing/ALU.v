/********************************************************************************************************
/		MODULE: ALU
/		PURPOSE: Given two 16-bit inputs and an opcode calculate the operation specified by the opcode.
/			The Result of the opeation is outputed on Result and the status bits are set. ALU has a 
/			total of 8 operations it can perform
/
/				0000: Add					| A + B
/				0001: Subtract				| B - A
/				0010: XOR					| A XOR B
/				0011: ANDN					| A AND ~B
/				0100: Rotate Left 			| A << (rotate) B (lowest 4 bits)
/				0101: Shift Left Logical 	| A << B (lowest 4 bits)
/				0110: Rotate Right 			| A >> (rotate) B (lowest 4 bits)
/				0111: Shift Right Logical 	| A >> B (lowest 4 bits)
/				1000: Equal					| (A == B) then 1 else 0
/				1001: Less Than				| (A < B) then 1 else 0
/				1010: Less Than or Equal	| (A <= B) then 1 else 0
/				1011: Carry Out				| (A + B) generates carry out then Rd <- 1 else Rd <- 0
/				1100: Flip					| A[bit 15-i] for i=0..15
/				1101: Pass Through			| B
/				1110: SLBI | Move Bottom	| (A << 8) | B
/				1111: PC + 2 CHECK
/
/		INPUTS: A[15:0] - First Operand
/				B[15:0] - Second Operand
/				OP_Code[2:0] - Denotes which operation
/
/		OUTPUTS: Result[15:0] - Result of Operation
/				 LT - Less Than
/				 ZF - Zero Flag
********************************************************************************************************/
module ALU (A, B, OP_Code, PC2, Result, LT, ZF);

	input [15:0] A;
	input [15:0] B;
	input [3:0] OP_Code;
	input [15:0] PC2;

	output [15:0] Result;
	output LT;
	output ZF;

	reg [15:0] case_out;
	reg [15:0] a_i;	//Be able to switch what A is ==
	reg [15:0] b_i;	//Be able to switch what B is ==
	reg c_i;
	reg lt;

	wire [15:0] xor_out;
	wire [15:0] andn_out;
	wire [15:0] shift_out;
	wire [15:0] cla_out;

	wire c_o;

	ALU_XOR Xor(.A(A), .B(B), .Out(xor_out));
	ALU_ANDN Andn(.A(A), .B(B), .Out(andn_out));

	ALU_Shifter Shifter(.In(A), .Cnt(B[3:0]), .Op(OP_Code[1:0]), .Out(shift_out));

	ALU_CLA CLA(.A(a_i), .B(b_i), .Ci(c_i), .S(cla_out), .Co(c_o));

	assign ZF = Result == 0;
	assign LT = lt;

	assign Result = case_out;

	always @ (OP_Code, A, B) begin
		c_i = 1'b0;
		a_i = 1'b0;
		b_i = 1'b0;
		case_out = 16'h0000;
		
		lt = 1'b0;
		
		case(OP_Code)
			4'b0000: begin //Add
				c_i = 1'b0;
				a_i = A;
				b_i = B;
				case_out = cla_out;
			end
			
			4'b0001: begin //Subtract
				c_i = 1'b1;
				a_i = B;
				b_i = ~A;
				case_out = cla_out;
			end
			
			4'b0010: begin //XOR 
				case_out = xor_out;
			end
			
			4'b0011: begin //ANDN
				case_out = andn_out;
			end
			
			4'b0100: begin //Rotate Left
				case_out = shift_out;
			end
			
			4'b0101: begin //Shift Left
				case_out = shift_out;
			end
			
			4'b0110: begin //Rotate Right
				case_out = shift_out;
			end
			
			4'b0111: begin //Shift Right
				case_out = shift_out;
			end
			
			4'b1000: begin //Equal
				case_out = A == B ? 16'h0001 : 16'h0000;
			end
			
			4'b1001: begin //Less Than
				c_i = 1'b1;
				a_i = A;
				b_i = ~B;
				case_out = A[15] == B[15] ? {15'h000, Result[15]} : (A[15] == 1 ? 16'h0001 : 16'h0000);
				lt = 1;
			end
			
			4'b1010: begin //Less Than Equal
				c_i = 1'b1;
				a_i = A;
				b_i = B;
				case_out = A == B ? 16'h0001 : (A[15] == B[15] ? {15'h000, Result[15]} : (A[15] == 1 ? 16'h0001 : 16'h0000));
				lt = A[15] == B[15] ? Result[15] : (A[15] == 1 ? 1 : 0);
			end
			
			4'b1011: begin //Carry Out
				c_i = 1'b0;
				a_i = A;
				b_i = B;
				case_out = c_o ? 16'h0001 : 16'h0000;
			end
			
			4'b1100: begin //FLip
				case_out = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]};
			end
			
			4'b1101: begin //B pass through
				case_out = B;
			end
			
			4'b1110: begin //Move Bottom
				case_out = {A[7:0], B[7:0]};
			end
			
			4'b1111: begin //PC + 2
				case_out = PC2;
			end
		endcase
		
	end

endmodule