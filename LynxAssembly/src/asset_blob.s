.segment "RODATA"
.export _sprite, _palette

        .align 2
_sprite:  .incbin "../assets/robot2.spr"

        .align 2
_palette: .incbin "../assets/robot2.pal"
