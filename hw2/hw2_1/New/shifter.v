module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   wire [15:0] tran1_2;
   wire [15:0] tran2_4;
   wire [15:0] tran4_8;
   
   shift1 sh1 (.in(In),      .op(Op), .sh(Cnt[0]), .out(tran1_2));
   shift2 sh2 (.in(tran1_2), .op(Op), .sh(Cnt[1]), .out(tran2_4));
   shift4 sh4 (.in(tran2_4), .op(Op), .sh(Cnt[2]), .out(tran4_8));
   shift8 sh8 (.in(tran4_8), .op(Op), .sh(Cnt[3]), .out(Out));
   
endmodule

