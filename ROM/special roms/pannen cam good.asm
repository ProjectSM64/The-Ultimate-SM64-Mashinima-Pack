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
word    object      0x283
*/
[NormalCamera]:0x8033c718
[MarioPos]:0x8033b1ac

.org 0x42ce0
jal 0x802a816c	// hook into camera code
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

.org 0x6316c
subiu sp, sp, 0x30
sw ra, 0x14(sp)
sw s0, 0x18(sp)
lui S0, @DataAddress
ori S0, S0, @DataAddress
lw t1, 0x0(S0)
addiu at, r0, 0x1
beq t1, at, ObjectMode    //1 = read vector relative to object
addiu at, r0, 0x2
beq t1, at, FixedMode    //2 = read position, point at mario
addiu at, r0, 0x3
beq t1, at, End          //3 = read position and target from program
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
lw t1, 0x1158(t2)
DoCopy:
lh t2, 0x1c(s0)
beq t2, r0, Trig
lhu t3, 0x1e(s0)
lhu t2, 0x1c(t1)
addu t3, t3, t2
andi t3, t3, 0xffff
Trig:
srl t4, t3, 0x4
sll t2, t4, 0x2
lui at, 0x8038
addu at, at, t2
lwc1 f4, 0x6000(at)
lwc1 f5, 0x7000(at)
lwc1 f6, 0x20(s0)
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
jal 0x8037888C		//and add relative
addiu a1, sp, 0x20
beq r0, r0, End

FixedMode:
lui a1, @MarioPos	//get mario's position vector
ori a1, a1, @MarioPos
jal 0x80378800		//copy into target
addiu a0, S0, 0x10

End:
lw s0, 0x18(sp)
lw ra, 0x14(sp)
jr ra
addiu sp, sp, 0x30

.org 0x31440        // skybox
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
jal 0x802cfef4
or a0, r0, r0
nop
nop
nop

//   ***************   VISIBLE PU

.org 0x36f58
addiu sp, sp, 0xff40    //give us more stack space

.org 0x36fc8
lui at, 0x8034      //just made this part a little smaller
lw t3, 0xb06c (at)
lui t5, 0x0101
ori t5, t5, 0x40
sw t5, 0x0 (t3)
lw t7, 0x24 (sp)
lui t5, 0x1fff
ori t5,t5, 0xffff
and t5, t5, t7
sw t5, 0x4 (t3)
addiu t3, t3, 0x8
sw t3, 0xb06c (at)
lw t8, 0x68 (sp)

addiu a0, t8, 0x1c  //call our function
jal 0x2a8258
addiu a1, sp, 0x6c


.org 0x37024
lh t8, 0xbae0 (t9)  //keep the original transform for objects/mario to use
addiu t4, t9, 0xbae8
sll t2, t8, 0x6
addu a2, t2, t4
addiu a0, a2, 0x40
jal 0x379f60
addiu a1, sp, 0x28

lui t5, 0x8034      //increment transform stack index
lh t6, 0xbae0 (t5)
addiu t6, t6, 0x1
sh t6, 0xbae0 (t5)
lw t8, 0x68 (sp)

addiu a0, sp, 0x84
addiu a1, sp, 0x6c
addiu a2, sp, 0x78
jal 0x378f84        //build camera transform from position and target vectors
lh a3, 0x38 (t8)
nop
nop
addiu a1, sp, 0x84  //pass our transform instead

.org 0x37108
addiu sp, sp, 0xc0  //match up with the beginning


.org 0x63258        //a0 points to two vectors we will reduce mod 2^16
addiu t0, a0, 0x14

ProcessFloat:
lw t2, 0x0 (a0)
lui t8, 0x8000
and t7, t8, t2      //store sign bit
lui t5, 0x80
sll t3, t2, 0x1
srl t3, t3, 0x18    //grab just the exponent

CheckValue:
slti at, t3, 0x8e
bnez at, BuildFloat //do we need to make this value smaller?
addiu t6, t5, 0xffff
addiu at, r0, 0x8e
bne t3, at, ShiftMantissa
nop
xor t7,t7,t8        //special stuff for 2^15
xor t2,t2,t6

ShiftMantissa:
sll t2, t2, 0x1
beq t2, r0, StoreFloat
and at, t5, t2
beq r0, at, ShiftMantissa
addiu t3, t3, 0xffff
beq r0, r0, CheckValue
nop

BuildFloat:
and t2, t2, t6      //only keep valid mantissa bits
or t2, t2, t7       //put sign bit back in
sll t3, t3, 0x17
or t2, t2, t3       //put new exponent in

StoreFloat:
sw t2, 0x0 (a1)
addiu a1, a1, 0x4
bne t0, a0, ProcessFloat
addiu a0, a0, 0x4
jr ra
nop
