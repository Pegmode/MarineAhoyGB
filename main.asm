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

.setTMAMode
	ld a, $04;ahoy tac
    ld [rTAC],a
    ld a, $c4;ahoy tma
    ld [rTMA],a
    ld a, %100;enable timer
.continueInit
    ld [rIE], a
    
    call DMEngineInit
    ld a, 1
    ld [SoundStatus],a
    ei

main:;main loop
.checkSyncEvent
    ldh a,[DMVGM_SYNC_HIGH_ADDRES]
    cp 0
    jr z,.SyncEventExit
    ld b,b;
    xor a
    ldh [DMVGM_SYNC_HIGH_ADDRES],a;reset sync register
.SyncEventExit
    jp main

vBlankRoutine:
    call DMEngineUpdate
    reti

timerRoutine:
    call DMEngineUpdate
    reti

include "DMGBVGM.asm"
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
