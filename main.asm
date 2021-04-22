;ahoy ROM by Pegmode
;original by Houshou Marine
include "macros.asm"
include "hardware.asm"
include "constants.asm"
include "vars.asm"
SECTION "Header",ROM0[$1]


SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine
SECTION "Timer IRQ",ROM0[$50]
timerIRQ:
    jp timerRoutine

SECTION "Title",ROM0[$134]
db "ahoyGB";15 char
SECTION "Manufacturer",ROM0[$13F]
db "peg"

SECTION "MBCDefinition",ROM0[$147]
    dw CART_MBC5

SECTION "EntryPoint",ROM0[$100]
jp codeInit

SECTION "code",ROM0[$150]
db "AhoyGB code/music by pegmode, Art by Gaplan, Original by Houshou Marine"
codeInit:
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS], a
    ld [BounceOffset], a;init bounce 
.setTMAMode
	ld a, $04;ahoy tac
    ld [rTAC],a
    ld a, $c4;ahoy tma
    ld [rTMA],a
    ld a, %101;enable timer and vblank
.continueInit
    ld [rIE], a
    call DMEngineInit
    ld a, 1
    ld [SoundStatus],a
.loadBG
    call WaitBlank
    ;ld a, %00010001;diable lcd old
    ld a, %00010011;diable lcd
    ld [rLCDC], a
    call LoadNormalPallet
    ld hl, PlaceholderBG_map_data
    ld bc, _SCRN0
    ld de, PlaceholderBG_tile_map_size
    call MemCopyLong
    ld hl, PlaceholderBG_tile_data
    ld bc, $8000
    ld de, PlaceholderBG_tile_data_size
    call MemCopyLong
    ;start 0x8520, tiles 52-65
    ;these values are temp clamped so when the graphics get updated this needs to be seriously changed
    ld hl,PlaceholderMetaSprite_tile_data
    ld bc,$8520
    ld de, PlaceholderMetaSprite_tile_data_size 
    call MemCopyLong
    ld hl, testOAM
    ld bc, $FE00
    ld d, 80
    call MemCopy
    ld hl, testOAM
    ld bc, $C100 ;DMA stuff
    ld d, 80
    call MemCopy
    ;obj pallet
    ld a,$E4
	ld [rOBP0],a
    ld a, [rLCDC]
    set 7,a;enable lcd
    ld [rLCDC],a
    ei

main:;main loop
.checkSyncEvent
    halt
    jp main

vBlankRoutine:
    call StartDMATransfer
.checkCurrentBounceFrame
    ld a, [BounceOffset]
    cp 0
    jr z,.checkSyncEvent
    call BounceAdvance
.checkSyncEvent
    ldh a,[DMVGM_SYNC_HIGH_ADDRESS]
    cp 0
    jr z,.SyncEventExit
.checkBounceEvent
    cp 2
    jr nz,.checkTalkEvent;bounce event
    ld a, 1
    ld [BounceOffset] ,a
    ld hl,$c100+3
    call flipMetaSpiteY
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS],a;reset sync register
    reti 
.checkTalkEvent
    cp 3
    jr nz, .SyncEventExit;talk event
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS],a;reset snyc
    ld a, [$c101]
    ld b, a
    ld a, [TalkEventFlag]
    cp 0
    jr nz, .incTalkEvent
    ld a, 1
    ld [TalkEventFlag], a
    ld a,b
    add a, 4
    ld hl,$c101
    call moveMetaSpriteX
    reti
.incTalkEvent
    xor a
    ld [TalkEventFlag], a
    ld a, b
    sub a, 4
    ld hl,$c101
    call moveMetaSpriteX
    reti
.SyncEventExit
    reti

timerRoutine:
    call DMEngineUpdate
    reti


include "utils.asm"
include "videoUtils.asm"
include "DMGBVGM.asm"
include "metaSpriteUtils.asm"
    
bounceTable:;DO NOT USE THE FIRST VALUE
    db    $FF,$8,$F,$15,$1A,$1E,$21,$23,$24,$24,$23,$21,$1E,$1A,$15,$F,$8,$0
bounceSpriteTable:
    db    $FF,$48,$41,$3B,$36,$32,$2F,$2D,$2C,$2C,$2D,$2F,$32,$36,$3B,$41,$48,$50

testOAM:
    db 80, 16, $52, 0
    db 80, 24, $53, 0
    db 80, 32, $54, 0
    db 80, 40, $55, 0
    db 88, 16, $56, 0
    db 88, 24, $57, 0
    db 88, 32, $58, 0
    db 88, 40, $59, 0
    db 96, 16, $5a, 0
    db 96, 24, $5b, 0
    db 96, 32, $5c, 0
    db 96, 40, $5d, 0
    db 104, 16, $5e, 0
    db 104, 24, $5f, 0
    db 104, 32, $60, 0
    db 104, 40, $61, 0
    db 112, 16, $0, 0;;remove zeroth entries later
    db 112, 24, $62, 0
    db 112, 32, $63, 0
    db 112, 40, $0, 0

;GRAPHICS DATA
;===========================================================================
SECTION "Graphics Data",ROMX,BANK[1]
include "Graphics/PlaceholderBG.asm"
include "Graphics/PlaceholderMetaSprite.asm"

;MUSIC DATA
;===========================================================================
SECTION "SoundData0",ROMX,BANK[2]
incbin "ahoySongData/ahoy0.bin"
SECTION "SoundData1",ROMX,BANK[3]
incbin "ahoySongData/ahoy1.bin"
SECTION "SoundData2",ROMX,BANK[4]
incbin "ahoySongData/ahoy2.bin"
SECTION "SoundData3",ROMX,BANK[5]
incbin "ahoySongData/ahoy3.bin"
SECTION "SoundData4",ROMX,BANK[6]
incbin "ahoySongData/ahoy4.bin"
SECTION "SoundData5",ROMX,BANK[7]
incbin "ahoySongData/ahoy5.bin"
SECTION "SoundData6",ROMX,BANK[8]
incbin "ahoySongData/ahoy6.bin"
SECTION "SoundData7",ROMX,BANK[9]
incbin "ahoySongData/ahoy7.bin"
SECTION "SoundData8",ROMX,BANK[10]
incbin "ahoySongData/ahoy8.bin"
SECTION "SoundData9",ROMX,BANK[11]
incbin "ahoySongData/ahoy9.bin"
SECTION "SoundData10",ROMX,BANK[12]
incbin "ahoySongData/ahoy10.bin"
SECTION "SoundData11",ROMX,BANK[13]
incbin "ahoySongData/ahoy11.bin"
