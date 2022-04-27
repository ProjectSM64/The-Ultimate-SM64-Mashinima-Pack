.org 0xe738
nop

.org 0xe7b0
addiu a0, r0, 0x18
addiu a1, r0, 0xa6
lw t3, 0x30 (sp)
lwc1 f16, 0x4c (t3)

.org 0xe808
addiu a0, r0, 0x18
addiu a1, r0, 0x94

.org 0xe7e0
addiu a0, r0, 0x18
addiu a1, r0, 0xb8

.org 0x28b3c
or v0, r0, r0

.org 0xf1420
.asciiz "yspd %d"

.org 0xf1428
.asciiz "hspd %d"

.org 0xf1430
.asciiz "act %x"