module Processor_Control (OP_Code, PC_Write, PC_Code, Comp_Code, WB_Sel, Mem_Write, Mem_Read, ALU_OP, ALU_Src, Reg_Write, Reg_Dest_Sel);

input [4:0] OP_Code;

output PC_Write;
output []PC_Code;
output []Comp_Code;
output WB_Sel;
output Mem_Write;
output Mem_Read;
output []ALU_OP;
output []ALU_Src; ?
output Reg_Write;
output []Reg_Dest_Sel;