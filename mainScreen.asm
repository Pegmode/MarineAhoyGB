UpdateMainScreen:
    call StartDMATransfer
.checkCurrentBounceFrame
    ld a, [BounceOffset]
    cp 0
    jr z,.checkSyncEvent
    call  BounceX
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
    ret
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
    ret
.incTalkEvent
    xor a
    ld [TalkEventFlag], a
    ld a, b
    sub a, 4
    ld hl,$c101
    call moveMetaSpriteX
    ret
.SyncEventExit
    ret

UpdateFadeScreen:
    call FadePallet
    cp 0
    jr nz,.endFadeUpdate
    ;when the fade is done
    call CreditsScreenInit
    ld a, 2
    ld [CurrentScreen], a;set the current screen to Credits screeen
.endFadeUpdate
    ret

SLoad:
    ;start 0x8520, tiles 52-65
    ;these values are temp clamped so when the graphics get updated this needs to be seriously changed
    ld hl,debugSprite_tile_data
    ld bc,$8520
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