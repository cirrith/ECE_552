module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   always@(Op) 
	begin

	if (Op == 2'b00) //Rotate Left
	   begin
		
	   end
	else if (Op == 2'b01) //Shift Left
	   begin

	   end
	else if (Op == 2'b10) //Shift Right Arithmetic
	   begin

	   end
	else if (Op == 2'b11) //Shift Right Logical
	   begin

	   end
	end
   
endmodule

