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

	;Read Joypad input (from GB cpu man)
;==========================================================
;[OldJoyData] return values:
;$8= start , $80=DOWN
;$4= select,$40=Up
;$2=b , $20=left
;$1=A, $10= right
ReadJoy:
	ld a,%00100000
	ld [rP1],a;Select P14
	ld a,[rP1]
	ld a,[rP1];wait
	cpl ;inv
	and %00001111;get only first 4 bits
	swap a;swap it
	ld b,a; store a in b
	ld a,%00010000
	ld [rP1],a;Select P15
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1];wait
	cpl ;inv
	and %00001111;get first 4 bits
	or b;put a and b together
	ld b,a;store a in d
	ld a,[OldJoyData];read old joy data from RAM
	xor b; toggle w/current button bit backup
	and b; get current button bit backup
	ld [NewJoyData],a;save in new NewJoyData storage
	ld a,b;put original value in a
	ld [OldJoyData],a;store it as old jow Data
	ld a,$30;deslect p14 and P15
	ld [rP1],A;Reset Joypad
	ret

;returns filtered joy state
getJoy:
	ld a, [NewJoyData]
	ld b, a
	ld a, [OldJoyData]
	sub a, b
	jr z,.exit
	xor a
.exit
	ret