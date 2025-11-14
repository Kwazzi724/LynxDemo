;****************************************************************
;		HandyAudition Main Execution Paths		*
;****************************************************************
; All of these functions use the following ZP Vars:		*
;	-None!							*
;****************************************************************
;****************************************************************
; Initialize::							*
;	Initialize the hardware to a known state, and load	*
;	all file dependencies.					*
;	When the initialization is finished, the video		*
;	hardware will be set to use the display buffers at the	*
;	end of memory, and timer 3 will be usable as a line	*
;	counter ala Zaku.					*
;****************************************************************
Initialize::
	START_UP
	CLEAR_ZP +STACK
	INITMIKEY
	INITSUZY
	FRAMERATE 60
	SCRBASE DispBuff0,DispBuff1

;Set up line counter with timers 1 & 3.
	LDA#$9E
	STA $fd04; Set Timer 1 to "approximate" HBlank
	LDA#$18
	STA $fd05
	LDA $fd02 ; Copy current HCount Value
	STA $fd06

	LDA#$40
	STA $FD0C
	LDA#$07; And timer 3 to clock based on it
	STA $FD0D

;Set up timer 7 for pseudorandom number use.
	LDA#$FF ; Full counting loop
	STA $FD1C
	LDA#%00011000 ; Auto Reload, 1Mhz clock
	STA $FD1D

SND_TIMER	equ	1   ;; 7 Overwrites Random..
                lda #%10011000|_31250Hz
                sta $fd01+SND_TIMER*4
                lda #129
                sta $fd00+SND_TIMER*4           ; set up a 240Hz IRQ

;Clear high coord bits of the display world regs,
;don't set them ever. Please, just don't.
	LDA#0
	STA $fc05
	STA $fc07

;Setup HandyMusic SFX Pointers
	LDA#<HandyMusic_SFX_ATableLo
	STA HandyMusic_SFX_AddressTableLoLo
	LDA#>HandyMusic_SFX_ATableLo
	STA HandyMusic_SFX_AddressTableLoHi
	LDA#<HandyMusic_SFX_ATableHi
	STA HandyMusic_SFX_AddressTableHiLo
	LDA#>HandyMusic_SFX_ATableHi
	STA HandyMusic_SFX_AddressTableHiHi
	LDA#<HandyMusic_SFX_PTable
	STA HandyMusic_SFX_AddressTablePriLo
	LDA#>HandyMusic_SFX_PTable
	STA HandyMusic_SFX_AddressTablePriHi
;Run the HandyMusic initializer
	jsr HandyMusic_Init

;Initialize IRQs, turn on VBlank ops
	jsr InitIRQ
	sei
        SETIRQ 2,VBlank_Updates
        SETIRQ SND_TIMER,SoundIRQ
	cli


;Lazily Set Palette, and jump to main loop
	SETRGB HandyAudPal
	bra MainLoop

HandyAudPal:	DP 000,000,008,00F,171,4A2,6D4,9E8,639,B6F,E5F,000,444,888,CCC,FFF
;****************************************************************
; MainLoop::							*
;	The main frame loop.					*
;****************************************************************
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


