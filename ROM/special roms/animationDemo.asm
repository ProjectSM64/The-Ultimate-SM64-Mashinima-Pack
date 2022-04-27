.org 0xb9c8
LW T7, 0x88 (A0)
SW T7, 0x1c (SP)
LH T8, 0x38 (T7)
SW T8, 0x24 (SP)
LW T9, 0xa0 (A0)

.org 0xb9f4
BEQ V0, R0, DoneA

.org 0xba40
NOP

.org 0xbae0
DoneA:


.org 0xbb18
LW T7, 0x88 (A0)
SW T7, 0x1c (SP)
LH T8, 0x38 (T7)
SW T8, 0x24 (SP)
LW T9, 0xa0 (A0)

.org 0xbb44
BEQ V0, R0, DoneB

.org 0xbb90
NOP

.org 0xbc4c
DoneB:


.org 0x34098
LW T7, 0x00 (A0)
SW T7, 0x20 (SP)
LW T0, 0x00 (T7)
SLTU AT, A1, T0
BNE AT, R0, DMA
NOP
ORI A1, R0, 0x85
SW A1, 0X2C (SP)
NOP
DMA: