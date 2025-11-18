@echo off
echo .export _sprite3> sprite3_data.s
echo .segment "RODATA">> sprite3_data.s
echo _sprite3:>> sprite3_data.s
echo .incbin "sprite3.spr">> sprite3_data.s
