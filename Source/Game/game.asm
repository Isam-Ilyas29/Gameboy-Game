;*****************************************************************************************************;

INCLUDE "Source/hardware.inc"

;*****************************************************************************************************;

SECTION "Game", ROM0

;*****************************************************************************************************;

Begin::

.colourPalette
    ; Sets colour palette
    ld a, %11100100
    ld [rBGP], a   

;*****************************************************************************************************;

Graphics::

;*****************************************************************************************************;

; TEXT

.waitVBlank
    ld a, [rLY]                             ; Sets a to scanline number
    cp 144                                  ; Compares a to scanline
    jr c, .waitVBlank                       

    xor a                                   

    ld [rLCDC], a                           

.initialiseFontData
    ld hl, $9000                            
    ld de, FontTiles                        
    ld bc, FontTilesEnd - FontTiles         

.copyFont
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copyFont                        
    ld hl, $9800 + (32 * 0) + (17)           ; Displays string in top middle of screen

    ld de, StringCoinCount                 

.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a                                   ; Checks if the byte we just copied is zero (Equivalent to `cp a, 0`)
    jr nz, .copyString                      

    ; Sets co-ordinates for top left corner of screen
    xor a                                   
    ld [rSCY], a
    ld [rSCX], a

;*****************************************************************************************************;

; TILES

; GRASS: 
.initialiseTileGrassData
    ld hl, $9010                            
    ld de, TileGrass                        ; Store tile data for grass
    ld bc, TileGrassEnd - TileGrass         ; Store length of TileGrass 

.copyTileGrass
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copyTileGrass                        

    ld a, [rLCDC]
    or LCDCF_BG8800
    ld [rLCDC], a

    ld b, 0
    ld hl, $9800 + (32 * 16)

.setTileGrass
    ; Loops and sets co-ordinates
    ld a, $01

    ld [hli], a

    inc b
    ld a, b
    cp a, 20
    jr nz, .setTileGrass

    ; Removes leftovers from bootup rom
    ld a, $0
    ld [$9904], a


; TREE:
.initialiseTileTreeData
    ld hl, $9020                            
    ld de, TileTree                         ; Store tile data for tree
    ld bc, TileTreeEnd - TileTree           ; Store length of TileTree 

.copyTileTree
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copyTileTree                        

.setTileTree
    ; Sets co-ordinates
    ld a, $2
    ld [$9800 + (32 * 15) + 4], a
    ld a, $3
    ld [$9800 + (32 * 15) + 5], a
    ld a, $4
    ld [$9800 + (32 * 14) + 4], a
    ld a, $5
    ld [$9800 + (32 * 14) + 5], a
    ld a, $6
    ld [$9800 + (32 * 13) + 4], a
    ld a, $7
    ld [$9800 + (32 * 13) + 5], a
    ld a, $8
    ld [$9800 + (32 * 12) + 4], a
    ld a, $9
    ld [$9800 + (32 * 12) + 5], a

    ; Removes leftovers from bootup rom
    ld a, $0
    ld [$9905], a
    ld [$9906], a
    ld [$9907], a
    ld [$9908], a
    ld [$9909], a
    ld [$990A], a
    ld [$990B], a
    ld [$990C], a

;COIN: 
.initialiseTileCoinData
    ld hl, $90A0                            
    ld de, TileCoin                         ; Store tile data for coin
    ld bc, TileCoinEnd - TileCoin           ; Store length of TileCoin 

.copyTileCoin
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copyTileCoin                        

.setTileCoin
    ; Sets co-ordinates
    ld a, $0A
    ld [$9800 + (32 * 0) + 19], a
    ld [$9800 + (32 * 14) + 8], a

    ; Removes leftovers from bootup rom
    ld a, $0
    ld [$990D], a

;*****************************************************************************************************;

; SPRITES

    ld bc, $FEA0                            ; Set to one address above OAM
    xor a
.clearOAM
    dec c
    ld [bc], a
    jr nz, .clearOAM

.initialiseSpriteManData
    ld hl, $8000
    ld de, SpriteMan
    ld bc, SpriteManEnd - SpriteMan

.copySpriteMan
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copySpriteMan

    ld a, 128                               ; Y pos
    ld [$FE00], a
    ld a, 9                                 ; X pos
    ld [$FE01], a
    ld a, %00000000                         ; Tile location
    ld [$FE02], a 
    ld a, %00000000                         ; Attributes
    ld [$FE03], a

    ld a, 136                               ; Y pos
    ld [$FE04], a
    ld a, 9                                 ; X pos
    ld [$FE05], a
    ld a, %00000001                         ; Tile location
    ld [$FE06], a
    ld a, %00000000                         ; Attributes
    ld [$FE07], a

.setSpriteMan
    ld a, %11100100
    ld [rOBP0], a
    ld [rOBP1], a

;*****************************************************************************************************;

.end
    ; Shuts sound down
    ld [rNR52], a

    ; Turns screen on, display background
    ld a, %10000011                         ; Bit 7 to turn lcd on, BIt 1 to enable sprite rendering, Bit 0 to display background
    ld [rLCDC], a 

;*****************************************************************************************************;

End::

.lockup
    jr .lockup

;*****************************************************************************************************;

SECTION "Fonts", ROM0

FontTiles::
INCBIN "Resources/font.chr"
FontTilesEnd::

;*****************************************************************************************************;

SECTION "Strings", ROM0

StringCoinCount::
    db "0X", 0

;*****************************************************************************************************;

SECTION "Tiles", ROM0

TileGrass::
    db $00, $FF, $00, $FF, $44, $FF, $ED, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
TileGrassEnd::

TileTree::
    db $03, $01, $03, $01, $03, $00, $03, $01, $03, $02, $03, $03, $07, $07, $1F, $1F
    db $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $F0, $F0, $F8, $F8
    db $03, $01, $03, $00, $03, $01, $03, $01, $03, $00, $03, $01, $03, $01, $03, $00
    db $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
    db $00, $FF, $00, $FF, $01, $FF, $0A, $7F, $0F, $0D, $07, $05, $03, $00, $03, $01
    db $00, $FE, $84, $FE, $08, $FE, $10, $FC, $F0, $F0, $F0, $F0, $F0, $F0, $E0, $E0
    db $00, $00, $00, $07, $00, $0F, $00, $1F, $00, $3F, $00, $3F, $00, $7F, $00, $7F
    db $00, $00, $00, $C0, $80, $60, $40, $B0, $20, $D8, $10, $EC, $00, $FE, $00, $FE
TileTreeEnd::

TileCoin::
    db $3C, $3C, $42, $7E, $91, $EF, $A1, $DF, $81, $FF, $81, $FF, $42, $7E, $3C, $3C
TileCoinEnd::

;*****************************************************************************************************;

SECTION "Sprites", rom0

SpriteMan::
    db $00, $7E, $00, $7E, $00, $FF, $42, $46, $42, $42, $42, $4E, $3C, $3C, $3C, $3D
    db $2C, $3E, $30, $3C, $3C, $3C, $28, $28, $6C, $6C, $6C, $6C, $C6, $C6, $00, $E7
SpriteManEnd::

;*****************************************************************************************************;