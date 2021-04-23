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

;DMA Transfer Code (DO NOT CALL THIS CODE DIRECTLY)
;==========================================================
;Length = 9
DMATransCode:
	ld a,$C1;N_ShadowOAM
	ld [rDMA],a ;initiate DMA Transfer from N_ShadowOAM to OAM
	ld a, $28 ;wait 128 micro seconds while transfer completes
.loop:
	dec a
	jr nz, .loop
	ret
;StartDMATransfer
;==========================================================
;input requirements: Requires data in N_ShadowOAM ($c100) to contain OAM data
;Disables all memory access except HRAM while running
StartDMATransfer:
	push bc
	;pass values to MemCopy
	ld hl,DMATransCode
	ld bc,_HRAM + 1;$FF80
	ld d,10 ;length of DMATransCode
	call MemCopy
	call _HRAM + 1;Start Transfer (no memory access)
	pop bc
	ret
;Wait for VBlank
;==========================================================
;wait for Beginning of vBlank
;holds for a long time
;stat %xxxxxx01
WaitVBlank:
	ld a,[rSTAT]
	bit 0,a
	jr nz,WaitVBlank;wait for non vBlankState
.waitforVBlank;
	ld a,[rSTAT]
	bit 0,a
	jr z,.waitforVBlank
	bit 1,a
	jr nz,.waitforVBlank
	ret