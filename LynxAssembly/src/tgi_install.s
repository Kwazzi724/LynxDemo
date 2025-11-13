; minimal _tgi_install replacement:
; call tgi_load(&tgi_stddrv) where tgi_stddrv is provided by lynx\tgi_stddrv.s

        .export _tgi_install
        .import _tgi_load
        .import tgi_stddrv         ; defined by libsrc\lynx\tgi_stddrv.s

_tgi_install:
        lda     #< tgi_stddrv
        ldx     #> tgi_stddrv
        jmp     _tgi_load          ; fastcall A/X -> loads the driver module


