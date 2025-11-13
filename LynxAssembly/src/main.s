.export _main
.import _tgi_install, _tgi_init, _tgi_setpalette, _tgi_clear, _tgi_sprite

.import _sprite, _palette

.segment "DATA"
scb:
    .byte  $94
    .byte  $10
    .byte  $01
    .word  0
    .word  0
    .word  80
    .word  51
    .word  $0100
    .word  $0100

.segment "CODE"
_main:
    jsr _tgi_install
    jsr _tgi_init

    lda #< _palette
    ldx #> _palette
    jsr _tgi_setpalette

    lda #< _sprite
    sta scb+5
    lda #> _sprite
    sta scb+6

loop:
    jsr _tgi_clear
    lda #< scb
    ldx #> scb

    ; simple delay
    ldy #$20
d1: ldx #$FF
d2: dex
    bne d2
    dey
    bne d1
    jmp loop
