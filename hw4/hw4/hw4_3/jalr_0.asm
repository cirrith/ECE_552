//JALR Test 0

LBI r1, 0x00
SLBI r1, 0x00 //R1 = 0x0000
jalr r1, 6
nop
halt