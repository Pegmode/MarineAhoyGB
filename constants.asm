DMVGM_SYNC_HIGH_ADDRESS EQU $80;address $FFxx that the sync command writes to. Do not implement this as var so that the C conversion side knows this address as well
DMVGM_START_BANK EQU 2
FADE_WAIT_LENGTH EQU 20

PlaceholderBG_tile_map_size EQU $0400
PlaceholderBG_tile_map_width EQU $20
PlaceholderBG_tile_map_height EQU $20

PlaceholderBG_tile_data_size EQU $0520
PlaceholderBG_tile_count EQU $52

PlaceholderMetaSprite_tile_map_size EQU $0400
PlaceholderMetaSprite_tile_map_width EQU $20
PlaceholderMetaSprite_tile_map_height EQU $20

PlaceholderMetaSprite_tile_data_size EQU $0130
PlaceholderMetaSprite_tile_count EQU $13

ChillTanTileSize EQU 67
ChillTanTileDataSize EQU ChillTanTileSize * 16