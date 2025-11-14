***************
* 
****************

DEBUG			set 1
*BRKuser         set 1
Baudrate        set 9600

SND_TIMER       set 7

  path "driverbs"
					include <hardware.asm>
****************
* macros
					include <help.mac>
					include <if_while.mac>
;;					include <font.mac>
					include <mikey.mac>
					include <suzy.mac>
					include <irq.mac>
					include <newkey.mac>
					include <debug.mac>
					include <handybug.mac>
					include "soundbs.mac"
****************
* variables
					include "soundbs.var"
					include <debug.var>
					include <help.var>
;;					include <font.var>
					include <mikey.var>
					include <suzy.var>
					include <irq.var>
					include <newkey.var>
					include <serial.var>
****************


        MACRO SHOW
        LDAY \0
        jsr DrawSprite
        ENDM

        MACRO JSHOW
        LDAY \0
        jmp DrawSprite
        ENDM


BEGIN_ZP
VBLsema         ds 1

;****************
; Hex Converter *
;****************
HEX_Value ds 1
HEX_XPos ds 1
HEX_YPos ds 1
AReg_YPos ds 1
AReg_Redir ds 2

HandyMusic_RegisterRedirectHi	ds 1

waitvbl		ds	1
flag		ds	1
END_ZP


BEGIN_MEM
                ALIGN 4
screen0         ds SCREEN.LEN
screen1         ds SCREEN.LEN
irq_vektoren    ds 16

END_MEM
                run $5000       ; code directly after variables
*
* system init
Start::         START_UP             ; Start-Label needed for reStart
                CLEAR_MEM
                CLEAR_ZP +STACK ; clear stack ($100) too

                INITMIKEY
                INITSUZY
                FRAMERATE 60
                SETRGB HandyAudPal
                INITIRQ irq_vektoren
                INITBRK                         ; if we're using BRK #X, init handler
                INITKEY ,_FIREA|_FIREB          ; repeat for A & B
;;                INITFONT LITTLEFNT,RED,WHITE
				stz DebugEnable
				jsr InstallLoader
                jsr InitComLynx
				SETIRQ 2,VBL
*                SETIRQ 0,HBL

                cli
                SCRBASE screen0, screen1
;;                SET_MINMAX 0,0,160,102

	stz flag

	LDA #$FD
	STA HandyMusic_RegisterRedirectHi ; Set up register redirection high byte
Main::
                jsr SndInit

;; hier hin springen geht nicht
			jsr SndPauseOn
           LDAY CHANNEL_0
           ldx #0
           jsr SndStartSound
           LDAY CHANNEL_1
           ldx #1
           jsr SndStartSound
           LDAY CHANNEL_2
           ldx #2
           jsr SndStartSound
           LDAY CHANNEL_3
           ldx #3
           jsr SndStartSound
			jsr SndPauseOff

.loop
           ;;     stz CurrX
           ;;     stz CurrY

;*********************
; Display Audio Regs *
;*********************
.loopx
        dc.b $CB ; WAI?, Says Johnny
	lda waitvbl
	bne .loopx

	  SHOW CLSscb
	  jsr UserPlaySFX
	  jsr DisplayAudRegs
	  inc waitvbl
	  lda flag
	  eor #$FF
	  sta flag
	  _IFEQ
                SCRBASE screen0, screen1
	  _ELSE
                SCRBASE screen1, screen0
	  _ENDIF

                jsr ReadKey
                beq .loop
                stz t1
                stz t2
                lda CurrentButton
                bit #_FIREA
				 _IFNE
				  jsr SndPauseOff
				  bra .loop
				_ENDIF
                bit #_FIREB
				 _IFNE
				  jsr SndPauseOn
				  bra .loop
				_ENDIF
                bit #_OPT2
				 _IFNE
				  jsr SndStop
				  bra .loop
				_ENDIF
                bit #_OPT1
				 _IFNE
				  jsr SndStop
				  jmp Main
				_ENDIF
				jmp .loop


HandyAudPal:    DP 000,000,008,00F,171,4A2,6D4,9E8,639,B6F,E5F,000,444,888,CCC,FFF

;********************
; Redirection Table *
;********************
HandyMusic_Redirect_Volume::		dc.b $20,$28,$30,$38
HandyMusic_Redirect_FeedBackReg::	dc.b $21,$29,$31,$39
HandyMusic_Redirect_DirectVol::		dc.b $22,$2A,$32,$3A
HandyMusic_Redirect_ShiftRegLo::	dc.b $23,$2B,$33,$3B
HandyMusic_Redirect_TimerBack::		dc.b $24,$2C,$34,$3C
HandyMusic_Redirect_TimerCont::		dc.b $25,$2D,$35,$3D
HandyMusic_Redirect_AudioExtra::	dc.b $27,$2F,$37,$3F

CLSscb         db $00,$10,00
                dw 0
                dw .CLSdata
                dw 0,0
                dw 10*$100,102*$100
.CLScolor       db $00
.CLSdata        db 2,%01111100,0

;****************************************************************
; MainLoop::                                                    *
;       The main frame loop.                                    *
;****************************************************************
IF 0
MainLoop::
;*********************
;Pre-frame Operations*
;*********************
.PFrameOp00
        READKEY
        INC FrameCounter
        jsr ResetCheck00
        jsr FlipCheck00
        jsr PauseCheck00
        LDA#0
        STA $fc04
        STA $fc06 ; Reset Display coordinates to 0,0
;***************
; Clear Buffer *
;***************
        jsr ClearBuffer
;*********************
; Display Audio Regs *
;*********************
        jsr UserPlaySFX
        jsr DisplayAudRegs
;*******************
;End of Frame Logic*
;*******************
.EndFrame00
        INC FrameProcDone
.EndFrame10
        dc.b $CB ; WAI?, Says Johnny
        LDA VBlankProcDone
        beq .EndFrame10
        STZ VBlankProcDone
        jmp MainLoop
ENDIF

****************
VBL::           lda #$ff
                tsb VBLsema
                _IFEQ
                  cli
                  jsr Keyboard                    ; read buttons
                  stz VBLsema
                _ENDIF
;;                stz $fdb0
		stz waitvbl
                END_IRQ

*HBL::
*                dec $fdb0
*                END_IRQ
****************
* INCLUDES
                include "soundbs.inc"
				include <draw_spr.inc>
;;                include <hexdez.inc>
                include <serial.inc>
                include <debug.inc>
;;                include <font.inc>
                include <irq.inc>
;;                include <font2.hlp>
                include <newkey.inc>

		
	include "HA_AllBs.asm"

****************

  path
	include "tmp_bs.asm"

;; EOF
