MACRO Write4WideMetaSprite1st
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
ENDM

MACRO Write4WideMetaSpriteNorm
    add a,8
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
    ld [hl],a
    add hl,de
ENDM