// Write your assembly program for Problem 1 (a) here.

lbi r0, 10
lbi r1, 20
add r2, r1, r0 //Forwarding one
nop
lbi r0, 10
jalr r0, 2 //Forwarding two
nop
ld r1, r0
addi r3, r1, 0 //Forwarding three
halt