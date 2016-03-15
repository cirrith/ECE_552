// Rotate Right Testing Assembly file 0

//ROR has: ROR Rd, Rs, Rt

lbi	r1, 0x00
slbi	r1, 0x00 //R1 contains 0x0000

lbi	r2, 0
slbi	r2, 0x0F //R2 contains 0x000F

ror	r3, r1, r2 //Make sure it rotates by 15
halt
