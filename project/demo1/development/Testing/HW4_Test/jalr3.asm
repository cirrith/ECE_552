//JALR Test 4

LBI r1, 0x00
SLBI r1, 0x0C //R1 = 0x000A
j 0x06
nop
halt
nop
jalr r1, -4