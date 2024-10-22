module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);

/* DECLARATIONS */
input [15:0] A;
input [15:0] B;
input [2:0] Op;

input Cin;
input invA;
input invB;
input sign;

output [15:0] Out;
output Ofl;
output Z;

wire [15:0] A_out; //Invert before outputing 
wire [15:0] B_out;

wire [15:0] oper; //Handle lower two bits of opcode

wire [15:0] Shifter_out;
wire [15:0] Add_out;
wire [15:0] Or_out;
wire [15:0] Xor_out;
wire [15:0] And_out;

wire ovfl;
/* END DECLARTIONS */

/*LOGIC*/

assign A_out = invA ? ~A : A; //Invert before Operation
assign B_out = invB ? ~B : B;

shifter Shifter_mod (.In(A_out), .Cnt(B_out[3:0]), .Op(Op[1:0]), .Out(Shifter_out)); //OP 000 - 011

cla cla_mod (.A(A_out), .B(B_out), .Cin(Cin), .Si(sign), .Out(Add_out), .Ofl(ovfl)); //OP 100

Or Or_mod   (.A(A_out), .B(B_out), .Out(Or_out)); //OP 101
Xor Xor_mod (.A(A_out), .B(B_out), .Out(Xor_out)); //OP 110
And And_mod (.A(A_out), .B(B_out), .Out(And_out)); //OP 111

assign Ofl = ovfl;//If adder gave Ofl 

assign Z = ~(|Out); //Check if zero 

assign oper = Op[1] ? (Op[0] ? And_out : Xor_out) : (Op[0] ? Or_out : Add_out); //Mux lower 2 bits for operations

assign Out = Op[2] ? oper : Shifter_out; //Select between shifter and other units

endmodule
