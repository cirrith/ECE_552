/**************************************************************************************************
/		MODULE: ALU_Shifter
/		PURPOSE: Given a single 16-bit number, operation code and Amount, perform the specified shift/rotate
			and return the result./
/			
/				00: Rotate Left
/				01: Shift Left Logical
/				10: Rotate Right
/				11: Shift Right Logical
/
/		INPUTS: A[15:0] - First Operand
/				OP[1:0] - Operation to perform
/				Amt[3:0] - Amount to operate by
/
/		OUTPUTS: Result[15:0] - Result of Operation
**************************************************************************************************/
module ALU_Shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   wire [15:0] tran1_2;
   wire [15:0] tran2_4;
   wire [15:0] tran4_8;
   
   ALU_Shifter_1 sBlade1 (.in(In),      .op(Op), .sh(Cnt[0]), .out(tran1_2));
   ALU_Shifter_2 sBlade2 (.in(tran1_2), .op(Op), .sh(Cnt[1]), .out(tran2_4));
   ALU_Shifter_4 sBlade4 (.in(tran2_4), .op(Op), .sh(Cnt[2]), .out(tran4_8));
   ALU_Shifter_8 sBlade8 (.in(tran4_8), .op(Op), .sh(Cnt[3]), .out(Out));
   
endmodule