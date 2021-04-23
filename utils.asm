;MemCopyLong
;==========================================================
;Input requirements: hl = Source Address, bc = destination, de = data length
MemCopyLong:
	ld a,[hl+]
	ld [bc],a
	inc bc
	dec de
	xor a
	or e
	jp nz,MemCopyLong
	or d
	jp nz,MemCopyLong
	ret

;MemCopy
;==========================================================
;Input requirements: hl = Source Address, bc = destination, d = data length
MemCopy:
	ld a,[hl+]
	ld [bc],a
	inc bc
	dec d
	jp nz,MemCopy
	ret
;OAMGMemCopy (copy memory when incrementing in OAM space)
;==========================================================
;Input requirements: hl = Source Address, bc = destination, d = data length
OAMGMemCopy:
	ld a,[hl+]
	ld [bc],a
	inc c
	dec d
	jp nz,OAMGMemCopy

;Input requirements: hl = destination, bc = legnth
clearMem:
	xor a
.clearLoop
	ld [hl+], a
	dec bc
	cp c
	jr nz,.clearLoop
	cp b
	jr nz,.clearLoop
	ret

ASCIITileTable:
;CURRENT ORDER A-B, 0-1, a-b
;start @ 0x32 + index in this table
;entries are tile index in vram
; " "  !   "   #   $   %   &   '   (   )   *   +   '   -   .   /
db $00, $1, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, $2, $43
;  0    1   2    3    4    5    6    7    8    9   :    ;    <    =    >    ?
db $3, $4, $5,  $6,  $7,  $8,  $9,  $A,  $B,  $C, $D,  0,   0,    0,   0,   0
;  @   A    B    C    D    E    F    G    H    I    J    K    L    M    N    O
db $E, $F, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D
;  P    Q    R    S    T    U    V    W    X    Y    Z
db $1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $28
;  [   \   ]   ^   _   `
db 00, 00, 00, 00, 00, 00
;  a    b    c    d    e    f    g    h    i   j    k    l    m    n    o    p
db $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $38
;  q    r    s    t    u    v    w    x    y   z
db $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42