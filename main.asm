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
codeInit:;Initalize the ROM and load/init main screen
    di
    ld sp,$FFCC
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS], a
    ld [BounceOffset], a;init bounce
    ld [ShortBounceOffset], a
    ld [CurrentScreen], a ;main screen
    ;wave anim
    ld [BGAnimDir], a
    ld [BGAnimFrame], a
.setTMAMode
	ld a, $04;ahoy tac
    ld [rTAC],a
    ld a, $c4;ahoy tma
    ld [rTMA],a

.continueInit
    ld a, 144-8;last row
    ld [rLYC], a
    ld a, [rSTAT]
    set 6,a
    ld [rSTAT], a
    ld a, %101;enable timer and vblank and lyc
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
    ld hl, finalBG_map_data
    ld bc, _SCRN0
    ld de, finalBG_tile_map_size
    call MemCopyLong
    ld hl, finalBG_tile_data
    ld bc, $8000
    ld de, finalBG_tile_data_size
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
    ;ld bc,$8520 ; bc is already set to the next tile address
    ld de, marineSprite1_tile_data_size
    call MemCopyLong
    ld hl, mClosedEyes_tile_data
    ld d, mEyes_tile_data_size
    call MemCopy
    ld hl, mHappyEyes_tile_data
    ld d, mEyes_tile_data_size
    call MemCopy
    ld hl, mSmugEyes_tile_data
    ld d, mEyes_tile_data_size
    call MemCopy
    ld hl, birds_tile_data
    ld d, birds_tile_data_size
    call MemCopy
    ld hl, waveFrames_tile_data
    ld d, waveFrames_tile_data_size
    call MemCopy;starts at $D4

    ld hl, MarineMetaSprite
    ld bc, $FE00
    ld d, 80
    call MemCopy
    ld hl, MarineMetaSprite
    ld bc, $C100 ;DMA stuff
    ld d, 80
    call MemCopy

.endSpriteLoad; End non special load
    ;load birds
    ld bc, BIRDSPRITE_L_INDEX  + N_ShadowOAM
    ld hl, birdSpriteInitTable
    ld d, 12
    call MemCopy
    ld hl,BirdTimer1
    xor a
    ld [hl+], a
    ld a,30
    ld [hl+], a
    ld a,15
    ld [hl], a
    ld hl, BirdOffset1
    xor a
    ld [hl+], a
    ld a,128
    ld [hl+], a
    ld a,90
    ld [hl], a
    call moveBirds

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
    cp MAIN_SCREEN
    jr nz,.checkFadeScreen
    call UpdateMainScreen
    call updateBirds
    reti
.checkFadeScreen
    cp FADE_MAIN_TRANSITION
    jr nz,.checkCreditsScreen
    call UpdateFadeScreen
    reti
.checkCreditsScreen
    cp CREDITS_SCREEN
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

birdSpriteInitTable:
    db 20,$80,$D2,0
    db 30,$8a,$D3,0
    db 16,$8f,$D3,0

; bounceSpriteTable:;vertical
;     db  $FF,$48,$41,$3B,$36,$32,$2F,$2D,$2C,$2C,$2D,$2F,$32,$36,$3B,$41,$48,$50
 shortBounceSpriteTable:
     db $FF,$4C-$C,$49-$C,$47-$C,$46-$C,$46-$C,$47-$C,$49-$C,$4C-$C,$50-$C
 bounceSpriteTable:;vertical
     db  $FF,$3C,$35,$2F,$2A,$26,$23,$21,$20,$20,$21,$23,$26,$2A,$2F,$35,$3C,$44;Last value must be MARINE_INIT_HEIGHT, first value must be $FF

MarineMetaSprite:
    db 68, 16, $ba, 0
    db 68, 24, $bb, 0
    db 68, 32, $bc, 0
    db 68, 40, $bd, 0
    db 76, 16, $be, 0
    db 76, 24, $bf, 0
    db 76, 32, $c0, 0
    db 76, 40, $c1, 0
    db 84, 16, $c2, 0
    db 84, 24, $c3, 0
    db 84, 32, $c4, 0
    db 84, 40, $c5, 0
    db 92, 16, $c6, 0
    db 92, 24, $c7, 0
    db 92, 32, $c8, 0
    db 92, 40, $c9, 0
    db 100, 16, $0, 0;keep for simplicity
    db 100, 24, $ca, 0
    db 100, 32, $cb, 0
    db 100, 40, $0, 0



DebugMetaSprite:
    db 80, 16, $52+104, 0
    db 80, 24, $53+104, 0
    db 80, 32, $54+104, 0
    db 80, 40, $55+104, 0
    db 88, 16, $56+104, 0
    db 88, 24, $57+104, 0
    db 88, 32, $58+104, 0
    db 88, 40, $59+104, 0
    db 96, 16, $5a+104, 0
    db 96, 24, $5b+104, 0
    db 96, 32, $5c+104, 0
    db 96, 40, $5d+104, 0
    db 104, 16, $5e+104, 0
    db 104, 24, $5f+104, 0
    db 104, 32, $60+104, 0
    db 104, 40, $61+104, 0
    db 112, 16, $62+104, 0
    db 112, 24, $63+104, 0
    db 112, 32, $64+104, 0
    db 112, 40, $65+104, 0

BirdMovementTable:
    db 120, 120, 121, 121, 122, 122, 123, 123, 124, 124, 125, 125, 126, 126, 127, 127, 128
    db 128, 129, 129, 129, 130, 130, 131, 131, 131, 132, 132, 132, 133, 133, 133, 134, 134
    db 134, 134, 135, 135, 135, 135, 135, 135, 135, 136, 136, 136, 136, 136, 136, 136, 136
    db 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 135, 135
    db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 134, 134, 134, 134, 134, 134
    db 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 135, 135, 135, 135
    db 135, 135, 135, 135, 135, 136, 136, 136, 136, 136, 136, 137, 137, 137, 137, 137, 137
    db 138, 138, 138, 138, 138, 139, 139, 139, 139, 140, 140, 140, 140, 140, 140, 141, 141
    db 141, 141, 141, 141, 141, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142
    db 142, 142, 142, 142, 142, 142, 142, 142, 141, 141, 141, 141, 141, 141, 140, 140, 140
    db 140, 139, 139, 139, 138, 138, 138, 137, 137, 137, 136, 136, 136, 135, 135, 135, 134
    db 134, 133, 133, 132, 132, 132, 131, 131, 130, 130, 130, 129, 129, 128, 128, 128, 127
    db 127, 126, 126, 126, 125, 125, 125, 124, 124, 124, 123, 123, 123, 122, 122, 122, 122
    db 121, 121, 121, 121, 121, 120, 120, 120, 120, 120, 120, 120, 119, 119, 119, 119, 119
    db 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119, 119
    db 119

;GRAPHICS DATA
;===========================================================================
SECTION "Graphics Data",ROMX,BANK[1]
include "Graphics/ChillTanFontTiles.asm"
include "Graphics/marineSprite1.asm"
include "Graphics/debugSprite.asm"
include "Graphics/finalBG.asm"
include "Graphics/birds.asm"
include "Graphics/thanks.asm"
include "Graphics/MarineFace/mClosedEyes.asm"
include "Graphics/MarineFace/mHappyEyes.asm"
include "Graphics/MarineFace/mSmugEyes.asm"
include "Graphics/waveFrames.asm"

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
