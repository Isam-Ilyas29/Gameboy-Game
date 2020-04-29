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

Text::

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

    ; Sets co-ordinates for top left corner of screem
    xor a                                   ; Equivalent to `ld a, 0`
    ld [rSCY], a
    ld [rSCX], a

    ; Shuts sound down
    ld [rNR52], a

    ; Turns screen on, display background
    ld a, %10000001
    ld [rLCDC], a

.lockup
    jr .lockup


SECTION "Font", ROM0

FontTiles::
INCBIN "Resources/font.chr"
FontTilesEnd::


SECTION "Displayed String", ROM0

StringHelloWorld::
    db "Hello World!", 0

;*****************************************************************************************************;