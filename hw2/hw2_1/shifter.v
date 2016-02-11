module shifter (In, Cnt, Op, Out);
   
input [15:0] In;
input [3:0]  Cnt;
input [1:0]  Op;
output [15:0] Out;

/*
Your code goes here
*/
// Declare wires
wire [15:0] zero, one, two, three;

// Need other modules for hierarchy:
  	// Rotate left module
  	// Shift left module
  	// Shift right arithmetic module
  	// Shift right logical
   
// Need 16 bit, 4-1 mux for the final
  	// 4_1_mux


// Mux for the opcode
	// Each operation has built in shift amount

RotL rotate_left(.In(In), .Amt(Cnt), .Out(zero));
ShL  shift_left(.In(In), .Amt(Cnt), .Out(one));
ShRA shift_right_arithmetic(.In(In), .Amt(Cnt), .Out(two));
ShRL shift_right_logical(.In(In), .Amt(Cnt), .Out(three));

mux4_1 final_choice(.A(zero), .B(one), .C(two), .D(three), .Sel(Op), .Out(Out));


endmodule