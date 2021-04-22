;Engine Skeleton ROM
include "hardware.asm"
include "constants.asm"
include "vars.asm"
SECTION "TMA VALUES",ROM0[$1]
;use patcher to change these values, set tmaTac to 0 to disable 
tmaMod: db $C3 
tmaTac: db %100;4096 hz
db "DMGBVGM by Pegmode"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine
SECTION "Timer IRQ",ROM0[$50]
timerIRQ:
    jp timerRoutine

SECTION "MBCDefinition",ROM0[$147]
    dw CART_MBC5

SECTION "EntryPoint",ROM0[$100]
jp codeInit

SECTION "code",ROM0[$150]
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
    ld a, %00010001;diable lcd
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
    ld a, [rLCDC]
    set 7,a;enable lcd
    ld [rLCDC],a
    ei

main:;main loop
.checkSyncEvent
    halt
    jp main

vBlankRoutine:
.checkCurrentBounceFrame
    ld a, [BounceOffset]
    cp 0
    jr z,.checkSyncEvent
    call BounceAdvance
.checkSyncEvent
    ldh a,[DMVGM_SYNC_HIGH_ADDRESS]
    cp 0
    jr z,.SyncEventExit
    cp 2
    jr nz,.SyncEventExit
    ld a, 1
    ld [BounceOffset] ,a
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS],a;reset sync register
.SyncEventExit
    reti

timerRoutine:

    call DMEngineUpdate
    reti


include "utils.asm"
include "videoUtils.asm"
include "DMGBVGM.asm"



BounceAdvance:
    ld b, 0
    ld a,[BounceOffset]
    ld d,a
    ld c,a
    ld hl, bounceTable
    add hl,bc
    ld a,[hl]
    ld [rSCY],a
    cp 0
    jr z,.bounceEnd
    inc d;not end of table
    ld a, d
    ld [BounceOffset], a
    ret
.bounceEnd;end of table
    xor a
    ld [BounceOffset], a
    ret
    
bounceTable:;DO NOT USE THE FIRST VALUE
db    $FF,$8,$F,$15,$1A,$1E,$21,$23,$24,$24,$23,$21,$1E,$1A,$15,$F,$8,$0

;GRAPHICS DATA
;===========================================================================
SECTION "Graphics Data",ROMX,BANK[1]
include "Graphics/PlaceholderBG.asm"

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
