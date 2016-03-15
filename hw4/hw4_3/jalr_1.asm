//JALR Test 1

LBI r1, 0x00
SLBI r1, 0x02 //R1 = 0x0002
jalr r1, 4
nop
halt