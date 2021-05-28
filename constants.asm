DMVGM_SYNC_HIGH_ADDRESS EQU $80;address $FFxx that the sync command writes to. Do not implement this as var so that the C conversion side knows this address as well
DMVGM_START_BANK EQU 2
FADE_WAIT_LENGTH EQU 25
BG_ANIM_FRAMERATE equ 40
BIRD_ANIM_FRAMERATE EQU 40

;screens
MAIN_SCREEN EQU 0
FADE_MAIN_TRANSITION EQU 1
CREDITS_SCREEN EQU 2
;eventCommands
EVENT_BOUNCE EQU 2
EVENT_TALK EQU 3
EVENT_SHORT_BOUNCE EQU 4
EVENT_EYES_CLOSED EQU 5;Sprite 
EVENT_EYES_SMUG EQU 6
EVENT_EYES_HAPPY EQU 7
EVENT_EYES_NORMAL EQU 8


BIRDSPRITE_L_INDEX EQU $50

MARINE_INIT_HEIGHT EQU $44

PlaceholderBG_tile_map_size EQU $0400
PlaceholderBG_tile_map_width EQU $20
PlaceholderBG_tile_map_height EQU $20

PlaceholderBG_tile_data_size EQU $0520
PlaceholderBG_tile_count EQU $52

debugSprite_tile_data_size EQU $0140 

debugSprite_tile_count EQU $14

marineSprite1_tile_data_size EQU $0120
marineSprite1_tile_count EQU $12

finalBG_tile_map_size EQU $0400
finalBG_tile_map_width EQU $20
finalBG_tile_map_height EQU $20

finalBG_tile_data_size EQU $0BA0
finalBG_tile_count EQU $BA

;same for every combo of eyes
mEyes_tile_data_size EQU $20
mEyes_tile_count EQU $02
birds_tile_data_size EQU $20
birds_tile_count EQU $02



ChillTanTileSize EQU 68
ChillTanTileDataSize EQU ChillTanTileSize * 16


thanks_tile_map_size EQU $0400
thanks_tile_map_width EQU $20
thanks_tile_map_height EQU $20

thanks_tile_data_size EQU $03C0
thanks_tile_count EQU $3C

;addresses
N_ShadowOAM equ $c100
