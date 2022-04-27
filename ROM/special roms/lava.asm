
.org 0xfadc
jal 0x2a816c
nop
lui t0, 0x8033
lw t0, 0xd93c (t0)
lw t1, 0x88 (t0)
sw r0, 0x134 (t1)

.org 0x6316c
lui t0, 0x8034
lw t1, 0xb1d8 (t0)
lw t2, 0xb17c (t0)
andi t2, t2, 0x1c0
ori a0, r0, 0x0
beq t2, r0, AfterAction
ori at, r0, 0x40
beq t2, at, AfterAction
ori at, r0, 0x100
beq t2, at, AfterAction
ori at, r0, 0x180
beq t2, at, AfterAction
nop
ori a0, r0, 0x1
AfterAction:
lui t3, 0x803e
lw t4, 0x0 (t3)
beq t4, r0, StoreTri
nop
bne a0, r0, Lava
nop
beq t1, t4, StoreTri
nop
Lava:
ori at, r0, 0x1
sh at, 0x0 (t4)
sw r0, 0x0 (t3)
StoreTri:
bne a0, r0, End
nop
sw t1, 0x0 (t3)
End:
jr ra
nop