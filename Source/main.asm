;*****************************************************************************************************;

SECTION "Header", ROM0[$100]

EntryPoint::
    di                      ; Disables interrupts
    jp Game                 ; Jumps to start
REPT $150 - $104
    db 0                    ; Fills all addresses from 0x104 to 0x150 with 0
ENDR

;*****************************************************************************************************;

SECTION "Application", ROM0

Game::
    call Begin
    call Graphics
    call End

;*****************************************************************************************************;