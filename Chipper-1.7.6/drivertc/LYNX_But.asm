;****************************************************************
;		   Lynx "Special" Button Routines		*
;****************************************************************
; All of these functions use the following ZP Vars:		*
;	-GLO_GamePaused						*
;****************************************************************
;****************************************************************
; ResetCheck00::						*
;	Checks if the Lynx should be reset.			*
;****************************************************************
ResetCheck00::
	LDA Button ; Has "reset" been pressed?
	CMP#$11
	bne ResetCheck10 ; If so, load user boot file.
ResetCheck01
	LDA Sample_Playing
	bne ResetCheck10
	;
	; Your boot file here
	;
	jsr HandyMusic_UnPause
	jsr HandyMusic_StopAll ; Shut off everything
ResetCheck10
	rts
;****************************************************************
; PauseCheck00::						*
;	Checks if the game is paused, acting appropriately if so*
;****************************************************************
PauseCheck00::
	LDA GLO_GamePaused
	bne .PauseCheck02
	LDA Button
	CMP#1
	bne .PauseCheck01
	LDA GLO_PauseCount
	bne .PauseCheck12
	LDA Sample_Playing
	bne ResetCheck10
	LDA#1
	STA GLO_GamePaused
	jsr HandyMusic_Pause
	rts
.PauseCheck01
	STZ GLO_PauseCount
	rts
.PauseCheck02
	STZ GLO_PauseCount
.PauseCheck10
	dc.b $CB ; WAI?, Says Johnny
	READKEY
	LDA Button
	CMP#$9
	beq FlipCheck01
	CMP#$11
	beq ResetCheck01
	CMP#1
	beq .PauseCheck11
	LDA#1
	STA GLO_PauseCount
	bra .PauseCheck10
.PauseCheck11
	LDA GLO_PauseCount
	beq .PauseCheck10
	STZ GLO_GamePaused
	jsr HandyMusic_UnPause
.PauseCheck12
	rts
;****************************************************************
; FlipCheck00::							*
;	Checks if the Lynx's display should be flipped.		*
;****************************************************************
FlipCheck00::
	LDA Button
	CMP#9
	bne FlipCheck09
	LDA Sample_Playing
	bne FlipCheck10
	LDA FlipPressed
	bne FlipCheck10
FlipCheck01
	LDA FlipMode
	EOR#1
	STA FlipMode
	INC FlipPressed
	INC GLO_PauseCount
	STZ GLO_GamePaused
	jsr HandyMusic_UnPause
	FLIP
	rts
FlipCheck09
	STZ FlipPressed
FlipCheck10
	rts