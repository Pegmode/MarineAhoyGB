BG_ANIM_TILE_SIZE equ $13
ANIM_BG_ANIM_FRAMES equ 6
BG_ANIM_MAP_ADR equ $9A20



UpdateMainScreen:
    call updateBGAnimFrame
    call StartDMATransfer
.checkCurrentBounceFrame
    ld a, [BounceOffset]
    cp 0
    jr z,.checkCurrentShortBounceFrame
    call  BounceX
    call BounceAdvance
.checkCurrentShortBounceFrame
    ld a, [ShortBounceOffset]
    cp 0
    jr z,.checkSyncEvent
    call ShortBounceAdvance
.checkSyncEvent
    ldh a,[DMVGM_SYNC_HIGH_ADDRESS]
    cp 0
    jr z,.SyncEventExit
.checkBounceEvent
    cp EVENT_BOUNCE
    jr nz,.checkTalkEvent;bounce event
    ld a, 1
    ld [BounceOffset] ,a
    ld hl,$c100+3
    call flipMetaSpiteY
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS],a;reset sync register
    ret
.checkTalkEvent
    cp EVENT_TALK
    jr nz, .checkShortBounceEvent;
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
    ret
.incTalkEvent
    xor a
    ld [TalkEventFlag], a
    ld a, b
    sub a, 4
    ld hl,$c101
    call moveMetaSpriteX
    ret
.checkShortBounceEvent
    cp EVENT_SHORT_BOUNCE
    jr nz, .checkEyesClosed
    ld a, 1
    ld [ShortBounceOffset] ,a
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRESS],a;reset sync register
.checkEyesClosed
    cp EVENT_EYES_CLOSED
    jr nz, .checkSmugEyes
    ld b, $CC
    ld c, $CD
    call swapEyes
    ret
.checkSmugEyes
    cp EVENT_EYES_SMUG
    jr nz, .checkHappyEyes
    ld b, $D0
    ld c, $D1
    call swapEyes
    ret
.checkHappyEyes
    cp EVENT_EYES_HAPPY
    jr nz, .checkNormalEyes
    ld b, $CE
    ld c, $CF
    call swapEyes
    ret
.checkNormalEyes
    cp EVENT_EYES_NORMAL
    jr nz, .SyncEventExit
    ld b, $BF
    ld c, $C0
    call swapEyes
    ret
.SyncEventExit
    ret

UpdateFadeScreen:
    ld a, %10010011;reset from BG animation
    ld [rLCDC], a
    call FadePallet
    cp 0
    jr nz,.endFadeUpdate
    ;when the fade is done
    call CreditsScreenInit
    ld a, CREDITS_SCREEN
    ld [CurrentScreen], a;set the current screen to Credits screeen
.endFadeUpdate
    ret

SLoad:
    ;start 0x8520, tiles 52-65
    ;these values are temp clamped so when the graphics get updated this needs to be seriously changed
    ld hl,debugSprite_tile_data
    ld bc,$8BA0
    ld de, debugSprite_tile_data_size
    call MemCopyLong
    ld hl, DebugMetaSprite
    ld bc, $FE00
    ld d, 80
    call MemCopy
    ld hl, DebugMetaSprite
    ld bc, $C100 ;DMA stuff
    ld d, 80
    call MemCopy
    ret

updateBGAnimFrame:
    ld a, [BGAnimFrame]
    ld b, BG_ANIM_TILE_SIZE
.writeTile
    ld a, 
.exit
    ret

BGAnimLUT:
    DB $D4, $D4, $D4, $D4, $D4, $D4, $D5, $D5, $D5, $D6, $D6, $D6, $D7, $D7, $D7, $D8
    DB $D8, $D8, $D9, $D9, $D9, $D9, $D9, $D9, $D8, $D8, $D8, $D7, $D7, $D7, $D6, $D6
    DB $D6, $D5, $D5, $D5, $00

updateBirds:
    ;This would be so much nicer with a macro but people got mad at macros :(
    ld a, [BirdTimer1]
    cp BIRD_ANIM_FRAMERATE
    jr z,.updateBird1
    inc a
    ld [BirdTimer1],a
    jr .handleBird2
.updateBird1
    xor a
    ld [BirdTimer1],a
    ld a,[BIRDSPRITE_L_INDEX  + N_ShadowOAM + 2]
    xor 1
    ld [BIRDSPRITE_L_INDEX  + N_ShadowOAM + 2],a
    call moveBirds
.handleBird2
    ld a, [BirdTimer2]
    cp BIRD_ANIM_FRAMERATE
    jr z,.updateBird2
    inc a
    ld [BirdTimer2],a
    jr .handleBird3
.updateBird2
    xor a
    ld [BirdTimer2],a
    ld a,[BIRDSPRITE_L_INDEX  + N_ShadowOAM + 2 + 4]
    xor 1
    ld [BIRDSPRITE_L_INDEX  + N_ShadowOAM + 2 + 4],a
    call moveBirds
.handleBird3
    ld a, [BirdTimer3]
    cp BIRD_ANIM_FRAMERATE
    jr z,.updateBird3
    inc a
    ld [BirdTimer3],a
    ret
.updateBird3
    xor a
    ld [BirdTimer3],a
    ld a,[BIRDSPRITE_L_INDEX  + N_ShadowOAM + 2 + 8]
    xor 1
    ld [BIRDSPRITE_L_INDEX  + N_ShadowOAM + 2 + 8],a
    call moveBirds
    ret

moveBirds:
    ld b, 0
    ;bird 1
    ld a, [BirdOffset1]
    ld c, a
    ld hl, BirdMovementTable
    add hl, bc
    ld a, [hl]
    ld [BIRDSPRITE_L_INDEX  + N_ShadowOAM + 1], a
    inc c
    ld a, c
    ld [BirdOffset1], a
    ;bird2
    ld a, [BirdOffset2]
    ld c, a
    ld hl, BirdMovementTable
    add hl, bc
    ld a, [hl]
    ld [BIRDSPRITE_L_INDEX  + N_ShadowOAM + 1 + 4], a
    inc c
    ld a, c
    ld [BirdOffset2], a
    ;bird3
    ld a, [BirdOffset3]
    ld c, a
    ld hl, BirdMovementTable
    add hl, bc
    ld a, [hl]
    ld [BIRDSPRITE_L_INDEX  + N_ShadowOAM + 1 + 8], a
    inc c
    ld a, c
    ld [BirdOffset3], a
    ret