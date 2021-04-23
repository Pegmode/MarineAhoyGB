CreditsScreenInit:
    ;change to next screen
    call WaitVBlank
    ld a, [rLCDC]
    res 7, a
    ld [rLCDC], a
    ld hl, _VRAM
    ld bc, $2000
    call clearMem
    ld hl, ChillTanFontTile
    ld bc, _VRAM
    ld de, ChillTanTileDataSize
    call MemCopyLong
    call LoadNormalPallet
    ld de, $9821
    call writeCreditsTextToScreen
    ld a, %10010001
    ld [rLCDC], a
    ret

;writes text to the bg from a .txt file 
;end of file = '*'
;lcd must be disabled before calling
;args: de = start map address  creditsText
;de = first address in current row, bc = current map address, ~hl = credits text ptr
writeCreditsTextToScreen:
    ld b , d
    ld c, e
    ld hl, creditsText
.scanChar
    ld a, [hl+]
    cp $2A; end of file ch7ar '*'
    jr z, .exit
    cp $D;newline
    jr nz, .loadCharTile
    ;char is newline
    inc hl
    push hl
    ld hl,$20;newline address distance
    add hl,de
    ld b , h
    ld c, l
    ld d, h
    ld e, l
    pop hl
    jr .scanChar
.loadCharTile
    push hl
    ld hl, ASCIITileTable - $20
    push bc
    ld b, 0
    ld c, a
    add hl, bc
    pop bc
    ld a, [hl]
    ld h, b
    ld l, c
    ld [hl], a
    pop hl
    inc bc
    jr .scanChar
    
.exit
    ret


ASCIITileTable:
    ;CURRENT ORDER A-B, 0-1, a-b
    ;start @ base - 0x20, add offset to start value
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