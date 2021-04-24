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

;CODE
;===========================================================================
SECTION "code",ROM0[$150]
db "AhoyGB code/music by pegmode, Art by Gaplan, Original song by Houshou Marine"
codeInit:
    di
    ld sp,$FFCC
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS], a
    ld [BounceOffset], a;init bounce
    ld [CurrentScreen], a 
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
    call WaitVBlank
    ld a, %00010011;disable lcd
    ld [rLCDC], a
    ;clear vram
    ld hl,_VRAM
    ld bc, $A000 - $8000
    call clearMem
    ld hl, $c100
    ld bc, $800
    call clearMem
    call LoadNormalPallet
    ld hl, PlaceholderBG_map_data
    ld bc, _SCRN0
    ld de, PlaceholderBG_tile_map_size
    call MemCopyLong
    ld hl, PlaceholderBG_tile_data
    ld bc, $8000
    ld de, PlaceholderBG_tile_data_size
    call MemCopyLong
    ;smode
    ld a, [SMode]
    cp $E3
    jr nz,.normalLoad
    call SLoad
    jr .endSpriteLoad
.normalLoad
    ;start 0x8520, tiles 52-65
    ;these values are temp clamped so when the graphics get updated this needs to be seriously changed
    ld hl,marineSprite1_tile_data
    ld bc,$8520
    ld de, marineSprite1_tile_data_size
    call MemCopyLong
    ld hl, MarineMetaSprite
    ld bc, $FE00
    ld d, 80
    call MemCopy
    ld hl, MarineMetaSprite
    ld bc, $C100 ;DMA stuff
    ld d, 80
    call MemCopy
.endSpriteLoad
    ld a, FADE_WAIT_LENGTH
    ld [FadeCounter], a
    ;obj pallet
    ld a,$E4
	ld [rOBP0],a
    ld a, [rLCDC]
    set 7,a;enable lcd
    ld [rLCDC],a
    ld a, 1;we want even distance so set to 1
    ld [TalkEventFlag],a
    ei

main:;main loop
    halt
    jp main

;INTERRUPTS
;===========================================================================
vBlankRoutine:
    ld a, [CurrentScreen]
    cp 0
    jr nz,.checkFadeScreen
    call UpdateMainScreen
    reti
.checkFadeScreen
    cp 1
    jr nz,.checkCreditsScreen
    call UpdateFadeScreen
    reti
.checkCreditsScreen
    cp 2
    jr nz,.improperScreen
    ld a, [DropBounceState]
    cp 0
    jr z, .notInDropBounce
    call DropBounceCalc
    
.notInDropBounce
    call ReadJoy
    call checkSModeCode
    ld a, [OldJoyData]
    cp $8
    jr nz,.dontRestart
    jp codeInit;RESTART ROM
.dontRestart
    reti
.improperScreen
    BREAKPOINT;something bad happened
    reti

timerRoutine:
    call DMEngineUpdate
    ld bc, 1
    ld a, b
    ld [rROMB1], a
    ld a, c
    ld [rROMB0], a
    reti

;OTHER
;===========================================================================

include "mainScreen.asm"
include "creditsScreen.asm"
include "utils.asm"
include "videoUtils.asm"
include "DMGBVGM.asm"
include "metaSpriteUtils.asm"

bounceSpriteTable:;vertical
    db  $FF,$48,$41,$3B,$36,$32,$2F,$2D,$2C,$2C,$2D,$2F,$32,$36,$3B,$41,$48,$50

MarineMetaSprite:
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
    db 112, 16, $0, 0;keep for simplicity
    db 112, 24, $62, 0
    db 112, 32, $63, 0
    db 112, 40, $0, 0

DebugMetaSprite:
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
    db 112, 16, $62, 0
    db 112, 24, $63, 0
    db 112, 32, $64, 0
    db 112, 40, $65, 0

;GRAPHICS DATA
;===========================================================================
SECTION "Graphics Data",ROMX,BANK[1]
include "Graphics/PlaceholderBG.asm"
include "Graphics/ChillTanFontTiles.asm"
include "Graphics/marineSprite1.asm"
include "Graphics/debugSprite.asm"
creditsText:
incbin "Graphics/creditsText.txt"
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
