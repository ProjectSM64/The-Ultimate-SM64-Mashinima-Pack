.org 0xcccb0
jal 0x2aedc0
nop


.org 0x69dc0
lui t6, 0x8034
lui at, 0xc00
ori at, at, 0x203
sw at, 0xb17c (t6)
lw t6, 0xb20c (t6)
lwc1 f2, 0x8 (t6)
lui at, 0x3e00
mtc1 at, f4
mul.s f6, f2, f4
lui t8, 0x8036
lw t8, 0x1160 (t8)
lwc1 f4, 0xb8 (t8)
add.s f2, f4, f6
swc1 f2, 0x2c (sp)
jr ra
nop
