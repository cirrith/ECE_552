module Control_tb();

logic [4:0] OP_Code;
logic [2:0] OP_Min;
logic PC_Write;
logic [2:0] PC_Code;
logic [1:0] Comp_Code;
logic Write_Back_Sel;
logic Mem_Write;
logic Mem_Read;
logic [3:0] ALU_OP_Code;
logic ALU_B_Src;
logic Reg_Write;
logic [1:0] Write_Reg_Sel;
logic Imm_Sign;
logic createDump;
logic halted;

Processor_Control PC(.OP_Code(OP_Code), .OP_Min(OP_Min), .PC_Write(PC_Write), .PC_Code(PC_Code), .Comp_Code(Comp_Code), .Write_Back_Sel(Write_Back_Sel), .Mem_Write(Mem_Write), .Mem_Read(Mem_Read), .ALU_OP_Code(ALU_OP_Code), .ALU_B_Src(ALU_B_Src), .Reg_Write(Reg_Write), .Write_Reg_Sel(Write_Reg_Sel), .Imm_Sign(Imm_Sign), .createDump(createDump), .halted(halted));

initial begin

OP_Code = 5'h00;
OP_Min 3'b0;

#10;

for(OP_Code = 5'h00; OP_Code = OP_Code + 1; )

