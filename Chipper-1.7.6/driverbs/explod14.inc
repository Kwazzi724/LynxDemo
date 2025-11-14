**********************************************************************
* Data Exploder  Expl_a0 = Source/Dest Buffer (must be size of dest!)
*                          Resource by GROO 1990
**********************************************************************

start_packer equ *

MACRO INCW
	inc \0
	_IFEQ
		inc \0+1
	_ENDIF
ENDM

MACRO DECW
	lda \0
	_IFEQ
		dec \0+1
	_ENDIF
	dec \0
ENDM

MACRO ADDXW      ; b=a+b+Carry
	lda \0
	adc \1
	sta \1
	lda \0+1
	adc \1+1
	sta \1+1
ENDM

MACRO ADDIBW
	clc
	lda #\0
	adc \1
	sta \1
	_IFCS
		inc \1+1
	_ENDIF
ENDM

MACRO SUBIBW
	sec
	lda \1
	sbc #\0
	sta \1
	_IFCC
		dec \1+1
	_ENDIF
ENDM

MACRO	ADD_REG
	clc
	rol \0
ENDM

MACRO	MOVEB_A3D4
	jsr moveb_a3d4
ENDM

MACRO	MOVEB_A3D3X3
	jsr moveb_a3d3x3
ENDM

MACRO	D3D3_MOVEB
	jsr d3d3_moveb_a3d3x3
ENDM

d3d3_moveb_a3d3x3::
	ADD_REG		Expl_d3
	bne .1
	MOVEB_A3D3X3
.1
	rts

moveb_a3d3x3::
	php
	DECW	Expl_a3
	lda (Expl_a3)
	plp
	rol
	sta Expl_d3
	rts

* Übergabe in Expl_a0
* Rückgabe in a: 0=fehler -1=OK
Explode_Data::
		lda Expl_a0
		sta Expl_a3
		sta Expl_a4
; Check_ ID Start
IF 0
		ldy #0
		lda #"I"
		cmp (Expl_a0),y
		bne .fehler
		iny
		lda #"M"
		cmp (Expl_a0),y
		bne .fehler
		iny
		lda #"P"
		cmp (Expl_a0),y
		bne .fehler
		iny
		lda #"!"
		cmp (Expl_a0),y
		beq id_ok
.fehler
		lda #0
		rts
ENDIF
; Check_ID Ende

id_ok
		ldy #7
		clc
		lda (Expl_a0),y
		adc Expl_a0
		sta Expl_a4
		dey
		lda (Expl_a0),y
		adc Expl_a0+1
		sta Expl_a4+1

		ldy #11
		clc
		lda (Expl_a0),y
		adc Expl_a0
		sta Expl_a3
		sta Expl_a2
		dey
		lda (Expl_a0),y
		adc Expl_a0+1
		sta Expl_a3+1
		sta Expl_a2+1

		ADDIBW	8,Expl_a0
		ldx	#3
.l1
			ldy #3
.l2
				lda (Expl_a2),y
				sta (Expl_a0),y
				dey
			bpl .l2
			ADDIBW	4,Expl_a2
			SUBIBW	4,Expl_a0
			dex
		bne .l1
		ADDIBW	4,Expl_a0

		ldy		#2
		lda		(Expl_a2),y
		sta		Expl_d2w+1 ; LE <-> BE
		iny
		lda		(Expl_a2),y
		sta		Expl_d2w
		iny

		lda		(Expl_a2),y
		_IFPL
			DECW	Expl_a3
		_ENDIF
		iny
		lda		(Expl_a2),y
		sta		Expl_d3
		iny

		ADDIBW	6,Expl_a2

		ldy #0
		ldx #28-1
.2
			lda (Expl_a2),y
			sta Expl_TabSP,y
			iny
			dex
		bpl .2

; Expl_a2 ab hier ungenutzt bzw ird neu initialisiert

		stz Expl_d4

Expl1::
		lda Expl_d2w
		ora Expl_d2w+1
		_IFNE
.4
			DECW	Expl_a3
			DECW	Expl_a4
			MOVEB (Expl_a3),(Expl_a4)
			DECW	Expl_d2w
			lda Expl_d2w
			ora Expl_d2w+1
			bne .4
		_ENDIF
		CMPW	Expl_a4,Expl_a0
		bcc Expl2
*		CMPW		Expl_a0,Expl_a3
*		beq Expl_Exit
*NotImplDataErr
*		lda #0
*		rts
*Expl_Exit
*		lda #$FF
		rts		; a = 0 = error

Expl2::
		ldx #0
.111
			D3D3_MOVEB
			_IFCC
				stx	Expl_d0
				txa
				inx
				inx
				stx Expl_d4
				bra Expl7
			_ENDIF
			inx
			cpx #4
		bne .111

		D3D3_MOVEB
		_IFCS
			DECW	Expl_a3
			lda (Expl_a3)
			sta Expl_d4
			bra Expl73
		_ENDIF

		ldx #2
.56
			D3D3_MOVEB
			rol Expl_d4
			dex
		bpl .56

		clc
		lda Expl_d4
		adc #6
		sta Expl_d4
Expl73::
		lda #3
		sta Expl_d0
Expl7::
		sta Expl_d1
		stz	Expl_d5w
		stz	Expl_d5w+1
		D3D3_MOVEB
		_IFCS
			D3D3_MOVEB
			_IFCS
				ldx Expl_d0
				lda Expl_Tab1,x
				sta Expl_d5w
				clc
				lda Expl_d0
				adc #8
				sta Expl_d0
			_ELSE
				lda #2
				sta Expl_d5w
				lda Expl_d0
				adc #4
				sta Expl_d0
			_ENDIF
		_ENDIF
		ldx Expl_d0
		lda Expl_Tab2,x
		sta Expl_d0
.5			D3D3_MOVEB
			rol Expl_d2w
			rol Expl_d2w+1
			dec Expl_d0
		bne .5
		ADDW	Expl_d5w,Expl_d2w
		stz Expl_d5w
		stz Expl_d5w+1
		stz Expl_a2
		stz Expl_a2+1
		MOVEB Expl_d1,Expl_d0
		D3D3_MOVEB
		_IFCS
			ADD_REG		Expl_d1
			D3D3_MOVEB
			ldx		Expl_d1
			_IFCS
				lda		Expl_TabSP+9,x
				sta 	Expl_a2
				ldy		Expl_TabSP+8,x
				lda #8
			_ELSE
				lda		Expl_TabSP+1,x
				sta 	Expl_a2
				ldy		Expl_TabSP,x
				lda #4
			_ENDIF
			sty 	Expl_a2+1
			clc
			adc Expl_d0
			sta Expl_d0
		_ENDIF

		ldx	Expl_d0
		lda	Expl_TabSP+$10,x
		sta Expl_d0

.91			D3D3_MOVEB
			rol Expl_d5w
			rol Expl_d5w+1
			dec Expl_d0
		bne .91

		sec
		ADDXW	Expl_d5w,Expl_a2
		ADDW	Expl_a4,Expl_a2

.93
			DECW	Expl_a2
			DECW	Expl_a4
			MOVEB	(Expl_a2),(Expl_a4)
			dec	Expl_d4
		bne .93
		jmp Expl1

Expl_Tab1	dc.b	$06,$0A,$0A,$12
Expl_Tab2	dc.b	$01,$01,$01,$01
			dc.b	$02,$03,$03,$04
			dc.b	$04,$05,$07,$0E

ende_packer equ *
xxx set ende_packer-start_packer
echo "Exploder Codesize: %Hxxx"

; =========================================================================
