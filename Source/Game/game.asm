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

.waitVBlank
    ld a, [rLY]                             ; Sets a to scanline number
    cp 144                                  ; Compares a to scanline
    jr c, .waitVBlank                       ; If carry bit is set then repeats process

    xor a                                   ; Equivalent to `ld a, 0`

    ld [rLCDC], a                           ; Writes back to LCDC

    ld hl, $9000                            ; 0x9000-0x97FF is where the Game Boy PPU reads tile data for tiles 0x00-0x7F.
    ld de, FontTiles                        ; Stores font address
    ld bc, FontTilesEnd - FontTiles         ; Stores length of FontTiles

.copyFont
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copyFont                        ; Repeats if everything hasnt been copied yet
    ld hl, $9800 + (32 * 7) + (4)           ; Displays string in top middle of screen (0x9800-0x9BFF is where the PPU normally reads tilemap data, to determine which tiles to draw)
    ld de, StringHelloWorld                 ; Copies string into de

.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a                                   ; Checks if the byte we just copied is zero (Equivalent to `cp a, 0`)
    jr nz, .copyString                      ; Continues if it's not

    ; Sets co-ordinates for top left corner of screen
    xor a                                   ; Equivalent to `ld a, 0`
    ld [rSCY], a
    ld [rSCX], a

.initialiseTile
    ld hl, $9010                            ; 0x8000 - 0x97FF is where the VRAM is
    ld de, TileMan                          ; Store tile data for man
    ld bc, TileManEnd - TileMan             ; Store length of tile data 

.copyTile
    ld a, [de]                              ; Grabs 1 byte from source
    ld [hli], a                             ; Places it at the destination, incrementing hl
    inc de                                  ; Moves to next byte
    dec bc                                  ; Decrements count
    ld a, b                                 ; Checks if everything was copied, since `dec bc` doesn't update flags
    or c                                    ; Sets z flag if bc is 0
    jr nz, .copyTile                        ; Repeats if everything hasnt been copied yet

    ; Sets co-ordinate
    ld a, $1
    ld [$9800 + (32 * 1) + (1)], a
    ld a, $2
    ld [$9800 + (32 * 2) + (1)], a

    ld a, $0
    ld [$9904], a
    ld [$9905], a

    ; Shuts sound down
    ld [rNR52], a

    ; Turns screen on, display background
    ld a, %10000001                         ; Bit 7 to turn lcd on and Bit 0 to display background
    ld [rLCDC], a
    
;*****************************************************************************************************;

End::

.lockup
    jr .lockup

;*****************************************************************************************************;

SECTION "Font", ROM0

FontTiles::
INCBIN "Resources/font.chr"
FontTilesEnd::

;*****************************************************************************************************;

SECTION "Displayed String", ROM0

StringHelloWorld::
    db "Hello World!", 0

;*****************************************************************************************************;

SECTION "Tiles", ROM0

TileMan::
    db $00, $7E, $00, $7E, $00, $FF, $42, $46, $42, $42, $42, $4E, $3C, $3C, $3C, $3D
    db $2C, $3E, $30, $3C, $3C, $3C, $28, $28, $6C, $6C, $6C, $6C, $C6, $C6, $00, $E7
TileManEnd::

;*****************************************************************************************************;