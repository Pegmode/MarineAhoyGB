;Load Standard DMG pallet
;============================================================
LoadNormalPallet:
	ld a,$E4
	ld [$FF47],a
	ret
;Copy data to Vram (for tiles and map)
;===========================================================
; Input requirements: de = VRAM address, hl = data start address, c = tile data size
VRamCopyLoop:
		call WaitBlank
		ld a,[hl+] ;Load the data at address hl into a and inc hl
		ld [de],a ;Load the data into ram
		inc de	;increment the VRam address
		dec bc ;Decrement counter     16 BIT OPERATIONS DONT THROW FLAGs
		ld a,b
		or c ;test if counter is zero
		jp nz,VRamCopyLoop
        ret
;Wait for V/HBlank
;==========================================================
;Total time: 52 cycles
;stat %xxxxxx0x
WaitBlank:
	ld a,[rSTAT]    ;16C
	and 2						;8C
	jr	nz,WaitBlank;12 ~ 8C
	ret							;16C

;
;==========================================================
;hl = map address base, bc = length
ChangeMapTileRef:
.l
    ld a,[hl]
    sub 128
    ld [hl+],a
    dec bc
    ld a, c
    cp 0    
    jr nz, .l
    ld a, b
    jr nz, .l
    ret