.segment "RODATA"
.export _sprite, _palette

        .align  2          ; make sure next label is even-addressed
_sprite:
        .incbin "sprite.spr"

        .align  2          ; align palette too (good hygiene)
_palette:
        .incbin "sprite.pal"
