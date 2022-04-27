//debug drawing function in mario calls 0x80370000
package main

var (
someFlags uint16 //  0x8036fffc
portalType uint16 // 0x8036fffe
)

//0x7d0000
func shootingBehavior() {
    oldFlags = someFlags
	if mario.action != 0x0c000227 {
        return
	}
    val := lhu(0x8033afa0)
    if val & 0x300 != 0 {
        portalType = val & 0x100
    }
    someFlags = val & 0x20
    if someFlags == oldFlags || someFlags == 0{
        return
    }
    child := createChildAtParent(lw(0x80361158), 0xaa, 0x130010b8)
    child.w_0x17c = 0xff
    child.subtype = portalType >> 8
    child.w_0xf0 = portalType >> 8
    child.realPos.y += 116.0
    child.realPitch = lhu(0x8033c536)
    child.heading = mario.heading + lhu(0x8033c538)
    child.realYaw = child.heading

    child.realVel.y = 100*sin(-child.realPitch)
    child.hspeed = 100*cos(child.realPitch)
    createSomething(0x50230081)
}


.org 0x7d1700
!portalposition:
addiu sp, sp, $ffe8
sw ra, $14 (SP)
jal $2a04c0
addiu a0, r0, $00fb
lhu t1, $0002 (v1)
andi t1, t1, $fffb
sh t1, $0002 (V1)
sw r0, $00b8 (V1)
lui at, $3f80
sw at, $002c (V1)
sw at, $0034 (V1)
lui at, $3f80
sw at, $0030 (V1)
lw t2, $0144 (V1)
sw t2, $00f0 (V1)

lw t1, $014c (V1)
addiu at, r0, $1
beq t1, at, !droptoground
nop
lw t0, $0180 (V1)
lui at, $c2c8
mtc1 at, f4
lwc1 f2, $001c (t0)
mul.s f2, f2, f4
lwc1 f12, $00a0 (V1)
add.s f2, f2, f12
swc1 f2, $00a0 (v1)


lwc1 f2, $0024 (t0)
mul.s f2, f2, f4
lwc1 f12, $00a8 (V1)
add.s f2, f2, f12
swc1 f2, $00a8 (V1)
lw t1, $008c (V1)
andi t1, t1, $fffe
//sw t1, $008c (V1)
beq r0, r0, !nopositionrot
nop
!droptoground:
LWC1 F12, $00A0 (V1)
LWC1 F10, $00A4 (V1)
LW A2, $00A8 (V1)
LUI AT, $4300
MTC1 AT, F16
JAL $80381794
ADD.S F14, F10, F16
lwc1 f2, $00a4 (V1)
swc1 f0, $00a4 (V1)


!nopositionrot:
lw ra, $14 (SP)
jr ra
addiu sp, sp, $0018