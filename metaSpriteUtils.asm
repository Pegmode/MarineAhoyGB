;changes a metasprite's y pos
; a = pos , hl = start sprite Y address
moveMetaSpriteY:;smoves a 4x5 sprite,duplicate code for vblank speed write pls no booli
    ld de,4
    ;r1
    call write4WideMetaSprite
    ;r2
    add a,8
    call write4WideMetaSprite
    ;r3
    add a,8
    call write4WideMetaSprite
    ;r4
    add a,8
    call write4WideMetaSprite
    ;r5
    add a,8
    call write4WideMetaSprite
    ret
; a = pos , hl = start sprite ADDRESS
moveMetaSpriteX:;smoves a 4x5 sprite,duplicate code for vblank speed write pls no booli
    ld de,4*4
    ld bc,17
    ;c1
    call write5TallMetaSprite
    ;c2
    add a,8
    ld hl,$c101 + 4
    call write5TallMetaSprite
    ;c3
    add a,8
    ld hl,$c101 + 4*2
    call write5TallMetaSprite
    ;c4
    add a,8
    ld hl,$c101 + 4*3
    call write5TallMetaSprite
    ret

;a = value, hl = start address, de = distance to next row
write5TallMetaSprite:;writes a value by col into meta sprite (move vertically down sprite)
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ret
    
;hl = start address, a = value to write
flipMetaSpiteY:
    ld a, [hl]
    ld b,%00100000
    xor a,b
    ld de,4
    call write4WideMetaSprite
    call write4WideMetaSprite
    call write4WideMetaSprite
    call write4WideMetaSprite
    call write4WideMetaSprite
    ld hl,$C100 + 2
    call flipTiles
    call flipTiles
    call flipTiles
    call flipTiles
    call flipTiles
    ret

;writes an entire row of values for a 4 wide meta sprite
;hl = start address, a = value to write
write4WideMetaSprite:
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ret

;swaps the positions in a 4 wide meta sprite, mirrored on a vertical axis along the center
;hl = current pos in row
flipTiles:
    ;swap pos 3
    push hl;save hl address
    ld de,12
    ld b, [hl];save current
    add hl,de
    ld c, [hl]
    ld [hl],b;save current to advance
    pop hl
    ld [hl],c
    ld de,4
    add hl,de
    ;swap pos 1
    push hl;save hl address
    ld de,4
    ld b, [hl];save current
    add hl,de
    ld c, [hl]
    ld [hl],b;save current to advance
    pop hl
    ld [hl],c
    ld de,3*4
    add hl,de
    ret

BounceX:
    ld a, [$C100 + 3]
    ld hl, $C100 + 1
    bit 5, a
    jr nz,.moveLeft;if bit 5 is 1
    ld a, [hl]
    sub a, 1
    call moveMetaSpriteX
    ret
.moveLeft
    ld a, [hl]
    add a, 1
    call moveMetaSpriteX
    ret

BounceAdvance:
    ld b, 0
    ld a,[BounceOffset]
    ld d,a
    ld c,a
    ld hl, bounceSpriteTable
    add hl,bc
    ld a,[hl]
    push af
    push de
    ld hl, $c100
    call moveMetaSpriteY
    pop de
    pop af
    cp $50;starting position for sprite
    jr z,.bounceEnd
    inc d;not end of table
    ld a, d
    ld [BounceOffset], a
    ret
.bounceEnd;end of table
    xor a
    ld [BounceOffset], a
    ret
    
ShortBounceAdvance:
    ld b, 0
    ld a,[ShortBounceOffset]
    ld d,a
    ld c,a
    ld hl, shortBounceSpriteTable
    add hl,bc
    ld a,[hl]
    push af
    push de
    ld hl, $c100
    call moveMetaSpriteY
    pop de
    pop af
    cp $50;starting position for sprite
    jr z,.bounceEnd
    inc d;not end of table
    ld a, d
    ld [ShortBounceOffset], a
    ret
.bounceEnd;end of table
    xor a
    ld [ShortBounceOffset], a
    ret