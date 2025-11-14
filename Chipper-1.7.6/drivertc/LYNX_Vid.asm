;****************************************************************
;	     Sprite, Video, H/VSYNC and Frame Routines		*
;****************************************************************
; All of these functions use the following ZP Vars:		*
;	-FrameProcDone						*
;	-VBlankProcDone						*
;	-UserVBlank_EN						*
;	-UserVBlank_Lo						*
;	-UserVBlank_Hi						*
;	-PAL_SrcPalLo						*
;	-PAL_SrcPalHi						*
;	-PAL_DestPalLo						*
;	-PAL_DestPalHi						*
;	-PAL_BrightnessAdjust					*
;	-PAL_BlueAdjust						*
;	-PAL_RedAdjust						*
;	-PAL_GreenAdjust					*
;****************************************************************
;****************************************************************
; LoadandAdjustPalette::					*
;	Copies a palette to the specified destination while	*
;	performing user-specified adjustments on its brightness *
;	and RGB phase values.					*
;****************************************************************
LoadandAdjustPalette::
; Personal Notes:
;	Colors are stored in an 32-Byte array with the last
; 16 bytes set as B7-B4 Blue and B3-B0 Red. The first 16 bytes
; are simply B3-B0 Green. So we must do some shifting, and trash
; both X and Y.
	LDX#0
	LDY#0
.Palloop00
	jsr .GetKey00
	INY
	CPX#2
	beq .Palloop10
	TYA
	AND#$F
	bne .Palloop00
	INX
	CPX#2
	bne .Palloop00
	LDY#16
.Palloop10
	CPY#32
	bne .Palloop00
	rts

;***************************
; Get the next palette key *
;***************************
.GetKey00
	LDA (PAL_SrcPalLo),Y
	PHY
	LDY PAL_LSShift,X
.GetKey01
	beq .GetKey10
	ROR
	DEY
	bra .GetKey01
.GetKey10
	PLY
	AND#$0F
;******************************
; Adjust a single palette key *
;******************************
.AdjustSingleKey00
	clc
	ADC PAL_GreenAdjust,X
	clc
	ADC PAL_BrightnessAdjust
	bmi .AdjustSingleKey01
	CMP#$10
	bcc .AdjustSingleKey02
	LDA#$F
	bra .AdjustSingleKey02
.AdjustSingleKey01
	LDA#0
.AdjustSingleKey02
;********************************
; Store the current palette key *
;********************************
.StoreKey00
	CPX#2
	bne .StoreKey21

	ROL
	ROL
	ROL
	ROL
	AND#$F0
	ORA (PAL_DestPalLo),Y

.StoreKey21
	STA (PAL_DestPalLo),Y
	rts
;*************************
; Table for shift values *
;*************************
PAL_LSShift dc.b 0,0,4
;****************************************************************
; ClearBuffer::							*
;	Clears the framebuffer to contain all zeros.		*
;****************************************************************
ClearBuffer::
	LDA $fc04
	STA ZPixel_x
	LDA $fc06
	STA ZPixel_y
	JSHOW ZPixel_SCB

ZPixel_SCB      dc.b $01,$10,$00
                dc.w 0
                dc.w ZPixel_data
ZPixel_x        dc.w 0
ZPixel_y        dc.w 0
ZPixel_scx      dc.w $100 * 160
ZPixel_scy      dc.w $100 * 102
                dc.b $00
;****************************************************************
; ClearBufferBB::						*
;	Clears the framebuffer to contain all $BB.		*
;****************************************************************
ClearBufferBB::
	LDA $fc04
	STA BPixel_x
	LDA $fc06
	STA BPixel_y
	JSHOW BPixel_SCB

BPixel_SCB      dc.b $01,$10,$00
                dc.w 0
                dc.w ZPixel_data
BPixel_x        dc.w 0
BPixel_y        dc.w 0
BPixel_scx      dc.w $100 * 160
BPixel_scy      dc.w $100 * 102
                dc.b $BB
;****************************************************************
; DrawSprite::							*
;	Draws a sprite whose SCB address is in AY.		*
;****************************************************************
DrawSprite::
	pha
	sta $fc10
	sty $fc11
	MOVE ScreenBase,$fc08
	lda #1
	STA $FC91
	STZ $FD90
.WAIT
	STZ $FD91
	lda $fc92
	lsr
	bcs .WAIT
	STZ $FD90
	pla
	rts
;****************************************************************
; VBlank_Updates::						*
;	Switches the current Framebuffer if FrameProcDone != 0,	*
; and executes any user functions followed by a HandyMusic jsr.	*
;****************************************************************
VBlank_Updates::
echo "Engine VBL IRQ Address: %HVBlank_Updates"
	PHP
	PHA
	PHX
	PHY
; Copy Flip state to "safe" variable
	LDA FlipMode
	STA HBlank_FlipState
; Did we finish the frame?
	LDA FrameProcDone
	beq .FrameLag
	STZ FrameProcDone
; Ok, let's swap the buffers
	ldx ScreenBase
	ldy ScreenBase+1

	lda ScreenBase2
	sta ScreenBase
	lda ScreenBase2+1
	sta ScreenBase+1

	stx ScreenBase2
	sty ScreenBase2+1

	lda _VIDEODMA
	and #2
	beq .okFLIP
	clc
	txa
	adc #$df
	tax
	tya
	adc #$1f
	tay
.okFLIP	stx $fd94
	sty $fd95
	INC VBlankProcDone
.FrameLag
; Any user calls?
	LDA UserVBlank_EN
	beq .nousercall
	LDA UserVBlank_Lo
	STA .usercalljsr + 1
	LDA UserVBlank_Hi
	STA .usercalljsr + 2
.usercalljsr
	jsr $3000
.nousercall
; Call HandyMusic before we leave
;;;	jsr HandyMusic_Main ;;; Moved to it own interrupt
	PLY
	PLX
	PLA
	PLP
	rts
