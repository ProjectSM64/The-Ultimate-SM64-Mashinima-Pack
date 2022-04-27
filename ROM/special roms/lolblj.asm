arch n64.cpu
endian msb
output "lolblj.z64"
origin $861C0
base $0

include "N64.INC"

ADDIU SP, SP, 0xFFE8
SW RA, 0x14(SP)

Checkstate:
LUI T0, 0x8034
LW T1, 0xB17C(T0)
LUI T2, 0x0300
ORI T2, T2, 0x0888
BEQ T1, T2, Checkspd
NOP
LUI T2, 0x0000          // check if longjump on ground state
ORI T2, T2, 0x0479
BNE T1, T2, Exit
NOP

Checkspd:
LWC1 F0, 0xB1C4(T0)     // check mario speed if lower or equal to -16
LUI T3, 0xC180
MTC1 T3, F1
C.LE.S F0, F1
BC1F Exit
LUI T4, 0xC170          // set speed to -15
SW T4, 0xB1C4(T0)

Exit:
LW RA, 0x14(SP)
JR RA
ADDIU SP, SP, 0x18