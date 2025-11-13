; src/assets/asset_blob.s
.export _robot2, _palette

.segment "RODATA"


_flag:
    .byte $00,$00,$00,$00         ; placeholder so it links

_palette:
    ; 16-entry (4bpp) palette
    .byte $00,$10,$20,$30,$40,$50,$60,$70
    .byte $80,$90,$A0,$B0,$C0,$D0,$E0,$F0
