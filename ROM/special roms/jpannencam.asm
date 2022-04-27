[DataAddress]:0x803e0000 //where to put camera numbers
/*
word 	camera mode	0x0
float	camera x	0x4
float	camera y	0x8
float	camera z	0xc
float	target x	0x10
float	target y	0x14
float	target z	0x18
short   rotate      0x1c
short   angle       0x1e
float   radius	    0x20
float   relative y	0x24
word    object      0x28
float   fov         0x2c
*/
[NormalCamera]:0x8033b3a8

.org 0x426f8
jal 0x802a78f8	// hook into camera code
nop
lw a0, 0x28(sp)
lui a1, @DataAddress
ori a1, a1, @DataAddress
addiu a1, a1, 0x4	// copy in vectors
jal 0x80378800
addiu a0, a0, 0x1c
addiu a1, a1, 0xc
jal 0x80378800
addiu a0, a0, 0xc
nop

//      CAMERA

.org 0x628f8
subiu sp, sp, 0x30
sw ra, 0x14(sp)
sw s0, 0x18(sp)
lui S0, @DataAddress
ori S0, S0, @DataAddress
lw t1, 0x2c (S0)
bne t1, r0, CheckMode
lui t2, 0x4234
sw t2, 0x2c(S0)
CheckMode:
lw t7, 0x0(S0)
addiu at, r0, 0x1
beq t7, at, ObjectMode    //1 = read vector relative to object
addiu at, r0, 0x2
beq t7, at, FixedMode    //2 = read position, point at object
addiu at, r0, 0x3
beq t7, at, End          //3 = read position and target from program
lui a1, @NormalCamera    //0 = just use lakitu
ori a1, a1, @NormalCamera
jal 0x80378800
addiu a0, S0, 0x10
addiu a1, a1, 0xc
jal 0x80378800
addiu a0, S0, 0x4
beq r0, r0, End

ObjectMode:
lw t1, 0x28(s0)
bne t1, r0, DoCopy
lui t2, 0x8036
lw t1, 0xfde8(t2)
DoCopy:
lh t2, 0x1c(s0)
bne t2, r0, Trig
lhu t3, 0x1e(s0)
lhu t2, 0x1c(t1)
addu t3, t3, t2
Trig:
andi t4, t3, 0xfff0
srl t2, t4, 0x2
lui at, 0x8038
addu at, at, t2
lwc1 f4, 0x6000(at)
lwc1 f5, 0x7000(at)
lw t3, 0x20(s0)
bne t3, r0, GoodR
lui t4, 0x447a
sw t4, 0x20(s0)
GoodR:
lwc1 f6, 0x20(s0)
neg.s f6, f6
lwc1 f7, 0x24(s0)
mul.s f8, f4, f6
swc1 f8, 0x20(sp)
swc1 f7, 0x24(sp)
mul.s f9, f5, f6
swc1 f9, 0x28(sp)
addiu a1, t1, 0x20
jal 0x80378800		//copy into target
addiu a0, S0, 0x10
jal 0x80378800		//copy into position
addiu a0, S0, 0x4
jal 0x8037888c		//and add relative
addiu a1, sp, 0x20
beq r0, r0, End

FixedMode:
lw t1, 0x28(s0)
bne t1, r0, FixedCopy
lui t2, 0x8036
lw t1, 0xfde8(t2)
FixedCopy:
addiu a1, t1, 0x20
jal 0x80378800		//copy into target
addiu a0, S0, 0x10

End:
lw s0, 0x18(sp)
lw ra, 0x14(sp)
jr ra
addiu sp, sp, 0x30

.org 0x30e90        // skybox
lui a1, @DataAddress
ori a1, a1, @DataAddress
lw a3, 0x4 (a1)
lw at, 0x8 (a1)
sw at, 0x10 (sp)
lw at, 0xc (a1)
sw at, 0x14 (sp)
addiu a1, a1, 0x10
jal 0x80378800
addiu a0, sp, 0x18
lw t5, 0x38 (sp)
lw a1, 0x1c (t5)
lw t5, 0x30 (sp)
lw a2, 0x1c (t5)
jal 0x802cf414
or a0, r0, r0
nop
nop
nop

// FOV

.org 0x55448
LUI T1, @DataAddress
ORI T1, T1, @DataAddress
LW T3, 0x0 (T1)
BEQ T3, R0, FOVDone
LW A0, 0x24 (SP)
LWC1 F4, 0x2c (T1)
FOVDone:
JAL 0x299db4
SWC1 F4, 0x1c (A0)
LW RA, 0x14 (SP)
ADDIU SP, SP, 0x28
JR RA
OR V0, R0, R0