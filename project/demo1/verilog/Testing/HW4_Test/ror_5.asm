// Rotate Right Testing Assembly file 0

//ROR has: ROR Rd, Rs, Rt

lbi	r1, 0x00
slbi	r1, 0x00 //R1 contains 0x0000

lbi	r2, 0
slbi	r2, 0x00 //R2 contains 0x0000

ror	r3, r1, r2 //Make sure it rotates by 0
halt
