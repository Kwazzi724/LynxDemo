IFD KBD_DELAY
LongDelay	equ KBD_DELAY
ELSE
LongDelay	equ 400 ; ms
ENDIF

IFD KBD_RATE
ShortDelay	equ KBD_RATE
ELSE
ShortDelay	equ 200  ; ms
ENDIF
;**************
InitKey::	stz LastButton
	stz LastCursor
	stz KeyCounter
	stz KeyCounter+1
	lda #<.dummy
	sta PausePtr
	sta PausePtr+2
	lda #>.dummy
	sta PausePtr+1
	sta PausePtr+3
	sei
	
.dummy	rts
;***************
;* Tastendruck mit
;* Delay/Repeat holen
;***************
GetKey::	READKEY	; Taste holen
	lda Button
	ora Cursor
	bne .cont
	stz LastButton
	stz LastCursor
	lda #0
	rts
.cont	lda Button
	cmp LastButton
	bne .cont1
	lda Cursor
	cmp LastCursor
	beq .cont2
;-- neue Taste oder Kombination
.cont1	lda Button
	sta LastButton
	lda Cursor
	sta LastCursor
	SET_KEYCOUNTER LongDelay
	lda #$ff
	rts
;-- gleiche Taste bzw. Kombination
.cont2	lda KeyCounter
	ora KeyCounter+1
	bne .cont3
	SET_KEYCOUNTER ShortDelay
	lda #$ff
	rts
.cont3	lda #0
	stz Button
	stz Cursor
	rts
;***************
;* Taste holen und ev Aktionen ausfÅhren
;***************
ReadKey::	jsr GetKey
	beq .exit1
ReadKey2	lda Button
	beq .exit0
	and #_RESTART	; Pause+Opt 1 => Restart
	cmp #_RESTART
	bne .cont0
	jmp Start
.cont0	lda Button
	and #_FLIP	; Pause+Opt2 => Flip
	cmp #_FLIP
	beq Flip
.cont1	lda Button
	bit #_PAUSE	; Pause ?
	bne Pause
.exit0	lda #$ff
.exit1	rts
;***************
;* auf Button warten
;***************
WaitKey::
WaitButton::	jsr ReadKey
	bne WaitButton
.wait	jsr ReadKey
	beq .wait
	rts
;***************
Flip::	VSYNC
	FLIP
	lda #0
	rts
;***************
Pause::	lda PauseEnable	; Pause mîglich ?
	bne .cont	; <> 0 => PAUSE
	lda #0
	rts

.cont	lda #$80
	tsb PauseFlag	; schon in der Pause-Routine ??
	bne ExitPause
.cont1	lda minutes
	pha
	lda seconds
	pha	; Zeit retten
	tsx
	stx LastSP+1		; SP retten
	lda PausePtr+1
	beq .wait0
	jsr DrawPause
.wait0	  READKEY
	  lda Button		; warten bis
	  bit #1		; Pause
	bne .wait0		; losgelassen wird
.wait1	jsr ReadKey		; und warten
	bra .wait1		; und warten, und ..
	
ExitPause::	stz PauseFlag		; Pause-Flag (Semaphore) lîschen
LastSP	ldx #0
	txs		; Stack zurÅck
	lda PausePtr+3
	beq .ok
	jsr ReDrawPause
.ok	pla
	sta seconds
	pla
	sta minutes
	lda #0		; keine Taste gedrÅckt
	rts
DrawPause	jmp (PausePtr)
ReDrawPause	jmp (PausePtr+2)
