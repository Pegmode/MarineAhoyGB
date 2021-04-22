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