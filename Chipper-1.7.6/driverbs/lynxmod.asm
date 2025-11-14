************************************************************************
*                                                                      *
*                Project #:              LynxMod V.1.40                *
*                                                                      *
*                Programmer: 	         Roland Graf                   *
*                                        Bastian Schick                *
*		 Producer:		 Johannes Graf                 *
*								       *
*                Date:                   03.06.1999                    *
*                                                                      *
*                    COPYRIGHT 1999 - 2001 Duranik 	               *
*          UNAUTHORIZED REPRODUCTION, ADAPTATION, DISTRIBUTION,        *
*          PERFORMANCE OR DISPLAY OF THIS COMPUTER PROGRAM OR          *
*        THE ASSOCIATED AUDIOVISUAL WORK IS STRICTLY PROHIBITED.       *
*                            ALL RIGHTS RESERVED.                      *
*                                                                      *
************************************************************************

; * Player ohne Effekte fÅr 6Khz im HBL
; * Vor und Nachkommaanteil 8Bit
; * 16 Feintunings
; * 31 Samples



************************************************************************
* LynxMod initialisieren                                               *
************************************************************************
; IN:
;		Adresse Module in "module"
;
LynxMod_Init::
	MOVE	module,volume		; Adresse retten
	ldx	#2			; auf 1 Sample setzen
.loop	ldy	#0			; Y-Register init
	clc				; Carry Flag lîschen
	lda	(module),y		; 1 Byte Startadresse Sample laden
	adc	volume
	sta	sam_start_table,x	; 1 Byte Startadresse Sample schreiben
	iny				; auf 2 Byte Startadresse Sample setzen
	lda	(module),y		; 2 Byte Startadresse Sample laden
	adc	volume+1
	sta	sam_start_table+1,x	; 2 Byte Startadresse Sample schreiben

	iny				; auf 1 Byte Endadresse Sample setzen
	clc				; Carry Flag lîschen
	lda	(module),y		; 1 Byte Endadresse Sample laden
	adc	volume
	sta	sam_end_table,x		; 1 Byte Endadresse Sample schreiben
	iny				; auf 2 Byte Enadresse Sample setzen
	lda	(module),y		; 2 Byte Endadresse Sample laden
	adc	volume+1
	sta	sam_end_table+1,x	; 2 Byte Endadresse Sample schreiben

	iny				; auf 1 Byte Repeat Startadresse Sample setzen
	clc				; Carry Flag lîschen
	lda	(module),y		; 1 Byte Repeat Startadresse Sample laden
	adc	volume
	sta	rep_start_table,x	; 1 Byte Repeat Startadresse Sample schreiben
	iny				; auf 2 Byte Repeat Startadresse Sample setzen
	lda	(module),y		; 2 Byte Repeat Startadresse Sample laden
	adc	volume+1
	sta	rep_start_table+1,x	; 2 Byte Repeat Startadresse Sample schreiben

	iny				; auf 1 Byte Repeat Endadresse Sample setzen
	clc				; Carry Flag lîschen
	lda	(module),y		; 1 Byte Repeat Endadresse Sample laden
	adc	volume
	sta	rep_end_table,x		; 1 Byte Repeat Endadresse Sample schreiben
	iny				; auf 2 Byte Repeat Endadresse Sample setzen
	lda	(module),y		; 2 Byte Repeat Endadresse Sample laden
	adc	volume+1
	sta	rep_end_table+1,x	; 2 Byte Repeat Endadresse Sample schreiben

	iny				; auf Repeat Wert setzen
	lda	(module),y		; Repeat Wert laden
	sta	repeat_table,x		; Repeat Wert schreiben

	iny				; auf 1 Byte LautstÑrke setzen
	lda	(module),y		; 1 Byte LautstÑrke laden
	sta	volume_table,x		; 1 Byte LautstÑrke schreiben
	ADDIW	10,module		; auf nÑchsten Sample setzen
	inx
	inx
	cpx	#64			; Letzter Sample bearbeitet ?
	bne	.loop			; Nein

	MOVE	module,position		; aktuelle Adresse Patterndaten init
	SUBIW	2,position
	ADDIW	256,module		; auf Pattern Daten setzen
	MOVE	module,module1
	lda	#1			; Wert Pattern neu setzen
	sta	pattern			; Pattern werden beim ersten Durchlauf neu gesetzt

	lda	#1			; damit beim ersten Mal die Sampleadressen gefÅllt werden
	sta	bpm			; Beats per Minute init

	sta	ch1_start		; Lo Byte Startadresse Soundkanal 1 init
	stz	ch1_start+1		; Hi Byte Startadresse Soundkanal 1 init
	sta	ch2_start		; Lo Byte Startadresse Soundkanal 2 init
	stz	ch2_start+1		; Hi Byte Startadresse Soundkanal 2 init
	sta	ch3_start		; Lo Byte Startadresse Soundkanal 3 init
	stz	ch3_start+1		; Hi Byte Startadresse Soundkanal 3 init
	sta	ch4_start		; Lo Byte Startadresse Soundkanal 4 init
	stz	ch4_start+1		; Hi Byte Startadresse Soundkanal 4 init

	stz	ch1_repeat		; Lo Byte Repeat Adresse Soundkanal 1 init
	stz	ch1_repeat+1		; Hi Byte Repeat Adresse Soundkanal 1 init
	stz	ch2_repeat		; Lo Byte Repeat Adresse Soundkanal 2 init
	stz	ch2_repeat+1		; Hi Byte Repeat Adresse Soundkanal 2 init
	stz	ch3_repeat		; Lo Byte Repeat Adresse Soundkanal 3 init
	stz	ch3_repeat+1		; Hi Byte Repeat Adresse Soundkanal 3 init
	stz	ch4_repeat		; Lo Byte Repeat Adresse Soundkanal 4 init
	stz	ch4_repeat+1		; Hi Byte Repeat Adresse Soundkanal 4 init

	lda 	#$FF			; Wert alle SoundkanÑle Panning aktivieren
	sta 	$fd44			; alle SoundkanÑle Panning aktivieren

	stz 	$fd20+2			; Soundkanal 1 still schalten
	stz 	$fd20+5			; Soundkanal 1 Audio-Control
	stz 	$fd20+4			; Soundkanal 1 Timer Backup
	stz 	$fd28+2			; Soundkanal 2 still schalten
	stz 	$fd28+5			; Soundkanal 2 Audio-Control
	stz 	$fd28+4			; Soundkanal 2 Timer Backup
	stz 	$fd30+2			; Soundkanal 3 still schalten
	stz 	$fd30+5			; Soundkanal 3 Audio-Control
	stz 	$fd30+4			; Soundkanal 3 Timer Backup
	stz 	$fd38+2			; Soundkanal 4 still schalten
	stz 	$fd38+5			; Soundkanal 4 Audio-Control
	stz 	$fd38+4			; Soundkanal 4 Timer Backup

	stz 	$fd50			; alle SoundkanÑle anschalten
	stz	$fd40			; Soundkanal 1 LautstÑrke init
	stz	$fd41			; Soundkanal 2 LautstÑrke init
	stz	$fd42			; Soundkanal 3 LautstÑrke init
	stz	$fd43			; Soundkanal 4 LautstÑrke init
	MOVEI	$fd40,volume		; Adresse 1 Volume Register festlegen
	rts				; Ende LynxMod init



************************************************************************
* LynxMod beenden                                                      *
************************************************************************
LynxMod_End::
	stz 	$fd20+2			; Soundkanal 1 still schalten
	stz	$fd28+2			; Soundkanal 2 still schalten
	stz	$fd30+2			; Soundkanal 3 still schalten
	stz	$fd38+2			; Soundkanal 4 still schalten
	lda	#$FF			; Wert alle SoundkanÑle ausschalten
	sta 	$fd50			; alle SoundkanÑle ausschalten
	rts				; Ende LynxMod



***********************************************************************
* LynxMod Player (wird 60 mal pro Sekunde im VBL aufgerufen)          *
***********************************************************************
LynxMod_Player::
	dec	bpm			; Beats per Minute - 1
	beq	LynxMod_Player0		; weiter wenn Beats per Minute = 0
	rts				; Ende Player

LynxMod_Player0::
	phy				; Y-Register auf Stack retten
	dec	pattern			; aktuelles Pattern - 1
	bne	.loop1			; weiter solange Pattern nicht zu Ende ist
	lda	#64			; Anzahl Zeilen Pattern init
	sta	pattern			; Anzahl Zeilen Pattern schreiben
	MOVE	module1,module		; Module Adresse auf Anfang setzen
	ADDIW	2,position		; auf nÑchste Songposition setzen
	ldy	#1			; Offset fÅr High Byte Adresse Module
	lda	(position),y		; High Byte Adresse Module laden
	cmp	#$FF			; Letzte Songposition ?
	bne	.loop0			; Nein

	MOVE	module1,position	; auf 1 Songposition setzen
	SUBIW	256,position		; auf Anfang Songpositions setzen

.loop0	lda	(position)		; Low Byte Adresse Module laden
	clc				; Carry Flag lîschen
	adc	module			; Low Byte zur Adresse Module addieren
	sta	module			; Low Byte Adresse Module schreiben
	lda	(position),y		; High Byte Adresse Module laden
	adc	module+1		; High Byte zur Adresse Module addieren
	sta	module+1		; High Byte Adresse Module schreiben

.loop1	ldy	#0			; Anzahl Stimmen initalisieren
	lda	#$40			; Low Byte 1 Volumeregister
	sta	volume			; Adresse Volumeregister anpassen

LynxMod_Player1::
	lda	(module)		; Periodoffset laden
	bne	.loop2			; Weiter wenn Periodenoffset <> 0
	jmp	LynxMod_Player2		; ganze Stimme nicht belegt

.loop2	tax				; Akku in X-Register kopieren
	lda	period_vor,x		; Vorkommaanteil laden
	sta	ch1_off1,y		; Vorkommaanteil schreiben
	lda	period_nach,x		; 1 Byte Nachkommaanteil laden
	sta	ch1_off2,y		; 1 Byte Nachkommaanteil schreiben

	ADDIW	1,module		; auf Samplenummer setzen
	lda	(module)		; Samplenummer laden
	beq	.loop3			; Weiter wenn Samplenummer = 0
	tax				; Akku in X-Register kopieren
	lda	sam_start_table,x	; 1 Byte Startadresse Sample laden
	sta	ch1_start,y		; 1 Byte Startadresse Sample schreiben
	lda	sam_start_table+1,x	; 2 Byte Startadresse Sample laden
	sta	ch1_start+1,y		; 2 Byte Startadresse Sample schreiben
	lda	sam_end_table,x		; 1 Byte Endadresse Sample laden
	sta	ch1_end,y		; 1 Byte Endadresse Sample schreiben
	lda	sam_end_table+1,x	; 2 Byte Endadresse Sample laden
	sta	ch1_end+1,y		; 2 Byte Endadresse Sample schreiben

	lda	volume_table,x		; LautstÑrke laden
	sta	(volume)		; LautstÑrke setzen

	lda	repeat_table,x		; Sample Repeat Wert laden
	sta	ch1_repeat,y		; Sample Repeat Wert schreiben
	beq	.loop3			; Weiter wenn Repeat Wert = 0
	lda	rep_start_table,x	; 1 Byte Repeat Startadresse Sample laden
	sta	ch1_rep_start,y		; 1 Byte Repeat Startadresse Sample schreiben
	lda	rep_start_table+1,x	; 2 Byte Repeat Startadresse Sample laden
	sta	ch1_rep_start+1,y	; 2 Byte Repeat Startadresse Sample schreiben
	lda	rep_end_table,x		; 1 Byte Repeat Endadresse Sample laden
	sta	ch1_rep_end,y		; 1 Byte Repeat Endadresse Sample schreiben
	lda	rep_end_table+1,x	; 2 Byte Repeat Endadresse Sample laden
	sta	ch1_rep_end+1,y		; 2 Byte Repeat Endadresse Sample schreiben

.loop3	ADDIW	1,module		; auf Effekt setzen
	lda	(module)		; Effekt laden
	beq	LynxMod_Player2		; Kein Effekt aktiv

	tax				; Akku in X-Register kopieren
	ADDIW	1,module		; auf Effektparameter setzen
	lda	(module)		; Effektparameter laden
	jmp	(LynxMod_effects,x)	; Effekt Unterprogramm starten

LynxMod_Player2::
	inc	volume			; Adresse Volume Register anpassen
	ADDIW	1,module		; auf nÑchste Stimme setzen
	iny				; auf nÑchste Stimme setzen
	iny				; auf nÑchste Stimme setzen
	cpy	#8			; 4 Stimmen bearbeitet ?
	beq	.loop1			; Ja
	jmp	LynxMod_Player1		; Nein, nÑchste Stimme bearbeiten

.loop1	lda	#7			; Beats per Minute neu laden	 War 7
	sta	bpm			; Beats per Minute zurÅckschreiben
	ply				; Y-Register vom Stack holen
	rts				; Ende Player


LynxMod_Effect0::			; 0 - None/Arpeggio
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect1::			; 1 - Portamento Up
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect2::			; 2 - Portamento Down
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect3::			; 3 - TonePortamento
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect4::			; 4 - Vibrato
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect5::			; 5 - ToneP + Volslide
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect6::			; 6 - Vibra + Volslide
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect7::			; 7 - Tremolo
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect8::			; 8 - * NOT USED *
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_Effect9::			; 9 - Sample Offset
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_EffectA::			; A - VolumeSlide
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_EffectB::			; B - Position Jump
	sta	position		; Low Byte neue Songposition setzen
	stz	position+1		; High Byte neue Songposition setzen
	ADDW	module1,position	; auf neue Songposition setzen
	SUBIW	129*2,position		; - Anfang der Songpositions
	lda	#1			; aktuelles pattern = 1
	sta	pattern			; Anzahl Zeilen Pattern schreiben
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_EffectC::			; C - Set Volume
	sta	(volume)		; LautstÑrke setzen
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_EffectD::			; D - Pattern Break
	lda	#1			; aktuelles Pattern = 1
	sta	pattern			; Anzahl Zeilen Pattern schreiben
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_EffectE::			; E - Misc. Cmds
	bra	LynxMod_Player2		; Ende Unterprogramm

LynxMod_EffectF::			; F - Set Speed
	bra	LynxMod_Player2		; Ende Unterprogramm



***********************************************************************
* LynxMod Mixer (wird 6120 mal pro Sekunde im HBL aufgerufen)         *
***********************************************************************
	MACRO	LYNXMOD_MIXER

	IF	ALLOW_INTERRUPT = 1
	cli				; Interrupts erlauben
	ENDIF

LynxMod_Mixer
IFD HALFFREQ
	lda mixer_channel_flag
	_IFEQ
		inc mixer_channel_flag
ENDIF
		CMPW	ch1_start,ch1_end	; Ende Sample erreicht ?
		bpl	.pl0			; Nein
		lda	ch1_repeat		; Sample Wiederholen ?
		beq	LynxMod_Mixer1		; Nein
		MOVE	ch1_rep_start,ch1_start	; Repeat Startadresse setzen
		MOVE	ch1_rep_end,ch1_end	; Repeat Endadresse setzen
.pl0		lda	(ch1_start)		; Samplebyte laden
			sta	$fd20+2			; Samplebyte ausgeben
	        clc				; Carry Flag lîschen
	        lda	ch1_off2		; Nachkomma.lo Periode
	        adc	ch1_off3		; + Nachkomma.lo Sample-Adresse
	        sta	ch1_off3		; = Nachkomma.lo Sample-Adresse
	        lda	ch1_off1		; Vorkomma Periode
	        adc	ch1_start		; + Vorkomma Sample-Adresse
	        sta	ch1_start		; (nur 8 Bit Vorkomma)
	        bcc	LynxMod_Mixer1
	        inc	ch1_start+1

LynxMod_Mixer1
		CMPW	ch2_start,ch2_end	; Ende Sample erreicht ?
		bpl	.pl1			; Nein
		lda	ch2_repeat		; Sample Wiederholen ?
;		beq	LynxMod_Mixer2		; Nein
IFD HALFFREQ
		beq	.pl5		; Nein
ELSE
		beq	LynxMod_Mixer2		; Nein
ENDIF
		MOVE	ch2_rep_start,ch2_start	; Repeat Startadresse setzen
		MOVE	ch2_rep_end,ch2_end	; Repat Endadresse setzen
.pl1		lda	(ch2_start)		; Samplebyte laden
			sta	$fd28+2			; Samplebyte ausgeben
	        clc				; Carry Flag lîschen
	        lda	ch2_off2		; Nachkomma.lo Periode
	        adc	ch2_off3		; + Nachkomma.lo Sample-Adresse
	        sta	ch2_off3		; = Nachkomma.lo Sample-Adresse
	        lda	ch2_off1		; Vorkomma Periode
	        adc	ch2_start		; + Vorkomma Sample-Adresse
	        sta	ch2_start		; (nur 8 Bit Vorkomma)
;	        bcc	LynxMod_Mixer2
IFD HALFFREQ
	        bcc	.pl4
ELSE
			bcc LynxMod_Mixer2
ENDIF
	        inc	ch2_start+1
IFD HALFFREQ
.pl5
		bra .pl4
	_ELSE
		stz mixer_channel_flag
ENDIF
LynxMod_Mixer2
		CMPW	ch3_start,ch3_end	; Ende Sample erreicht ?
		bpl	.pl2			; Nein
		lda	ch3_repeat		; Sample Wiederholen ?
		beq	LynxMod_Mixer3		; Nein
		MOVE	ch3_rep_start,ch3_start	; Repeat Startadresse setzen
		MOVE	ch3_rep_end,ch3_end	; Repat Endadresse setzen
.pl2		lda	(ch3_start)		; Samplebyte laden
			sta	$fd30+2			; Samplebyte ausgeben
	        clc				; Carry Flag lîschen
	        lda	ch3_off2		; Nachkomma.lo Periode
	        adc	ch3_off3		; + Nachkomma.lo Sample-Adresse
	        sta	ch3_off3		; = Nachkomma.lo Sample-Adresse
	        lda	ch3_off1		; Vorkomma Periode
	        adc	ch3_start		; + Vorkomma Sample-Adresse
	        sta	ch3_start		; (nur 8 Bit Vorkomma)
	        bcc	LynxMod_Mixer3
	        inc	ch3_start+1

LynxMod_Mixer3
		CMPW	ch4_start,ch4_end	; Ende Sample erreicht ?
		bpl	.pl3			; Nein
		lda	ch4_repeat		; Sample wiederholen
		beq	.pl4			; Nein
		MOVE	ch4_rep_start,ch4_start	; Repeat Startadresse setzen
		MOVE	ch4_rep_end,ch4_end	; Repat Endadresse setzen
.pl3		lda	(ch4_start)		; Samplebyte laden
			sta	$fd38+2			; Samplebyte ausgeben
	        clc				; Carry Flag lîschen
	        lda	ch4_off2		; Nachkomma.lo Periode
	        adc	ch4_off3		; + Nachkomma.lo Sample-Adresse
	        sta	ch4_off3		; = Nachkomma.lo Sample-Adresse
	        lda	ch4_off1		; Vorkomma Periode
	        adc	ch4_start		; + Vorkomma Sample-Adresse
	        sta	ch4_start		; (nur 8 Bit Vorkomma)
	        bcc	.pl4
	        inc	ch4_start+1
IFD HALFFREQ
	_ENDIF
ENDIF
.pl4
	ENDM				; Ende LynxMod Mixer



************************************************************************
* LynxMod Variablen                                                    *
************************************************************************
LynxMod_effects:
	dc.w	LynxMod_Effect0		; 0 - None/Arpeggio
	dc.w	LynxMod_Effect1		; 1 - Portamento Up
	dc.w	LynxMod_Effect2		; 2 - Portamento Down
	dc.w	LynxMod_Effect3		; 3 - TonePortamento
	dc.w	LynxMod_Effect4		; 4 - Vibrato
	dc.w	LynxMod_Effect5		; 5 - ToneP + Volslide
	dc.w	LynxMod_Effect6		; 6 - Vibra + Volslide
	dc.w	LynxMod_Effect7		; 7 - Tremolo
	dc.w	LynxMod_Effect8		; 8 - * NOT USED *
	dc.w	LynxMod_Effect9		; 9 - Sample Offset
	dc.w	LynxMod_EffectA		; A - VolumeSlide
	dc.w	LynxMod_EffectB		; B - Position Jump
	dc.w	LynxMod_EffectC		; C - Set Volume
	dc.w	LynxMod_EffectD		; D - PatternBreak
	dc.w	LynxMod_EffectE		; E - Misc. Cmds
	dc.w	LynxMod_EffectF		; F - Set Speed

;	dc.w	LynxMod_EffectE0	; E0 - Filter On/Off
;	dc.w	LynxMod_EffectE1	; E1 - Fineslide Up
;	dc.w	LynxMod_EffectE2	; E2 - Fineslide Down
;	dc.w	LynxMod_EffectE3	; E3 - Glissando Control
;	dc.w	LynxMod_EffectE4	; E4 - Vibrato Control
;	dc.w	LynxMod_EffectE5	; E5 - Set Finetune
;	dc.w	LynxMod_EffectE6	; E6 - Patternloop
;	dc.w	LynxMod_EffectE7	; E7 - Tremolo Control
;	dc.w	LynxMod_EffectE8	; E8 - * NOT USED *
;	dc.w	LynxMod_EffectE9	; E9 - Retrig Note
;	dc.w	LynxMod_EffectEA	; EA - FineVol Up
;	dc.w	LynxMod_EffectEB	; EB - FineVol Down
;	dc.w	LynxMod_EffectEC	; EC - NoteCut
;	dc.w	LynxMod_EffectED	; ED - NoteDelay
;	dc.w	LynxMod_EffectEE	; EE - PatternDelay
;	dc.w	LynxMod_EffectEF	; EF - Invert Loop



; Tabellen fÅr 32 Samples
sam_start_table:	ds	64	; Startadressen Samples
sam_end_table:		ds	64	; Endadressen Samples
rep_start_table:	ds	64	; Repeat Startadressen Samples
rep_end_table:		ds	64	; Repeat Endadressen Samples
volume_table:		ds	64	; LautstÑrke fÅr Samples
repeat_table		ds	64	; Wert ob Samples wiederholt werden



; Umrechnung vom 10er ins 2er System von BS42
  MACRO dcw
  dc.w \0*255/100
  dc.w \1*255/100
  dc.w \2*255/100
  dc.w \3*255/100
  dc.w \4*255/100
  dc.w \5*255/100
  dc.w \6*255/100
  dc.w \7*255/100
  dc.w \8*255/100
  dc.w \9*255/100
  dc.w \10*255/100
  dc.w \11*255/100
  ENDM


	SWITCH	TUNING			; nur gewÑhltes Feintuning assemblieren
	CASE	0			; Tuning 0 normal
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,2,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,6,7,7
		dc.w	8,8,9,9,10,10,11,12,12,13,14,15
period_nach:	dc.w	0
		dcw	12,13,14,14,15,16,17,18,19,21,22,23
		dcw	25,26,28,29,31,33,35,37,39,42,44,47
		dcw	50,52,56,59,63,66,70,75,79,84,89,94
		dcw	00,05,12,18,26,33,41,50,59,68,78,89
		dcw	00,11,25,37,51,67,83,99,17,37,56,78
		dcw	00,23,50,75,03,35,70,02,38,79,13,64
		dcw	07,56,10,51,19,70,56,22,96,80,26,28


	CASE	1			; Tuning 1
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,6,7,7
		dc.w	8,8,9,9,10,10,11,12,12,13,14,15
period_nach:	dc.w	0
		dcw	12,13,14,14,15,16,17,18,19,21,22,23
		dcw	25,26,28,29,31,33,35,37,39,42,44,47
		dcw	50,53,56,59,63,67,71,75,80,84,89,95
		dcw	00,06,12,19,27,34,42,50,59,69,79,90
		dcw	00,12,26,39,53,69,85,01,19,39,59,78
		dcw	02,26,51,79,08,38,70,02,38,76,16,60
		dcw	05,53,03,59,16,76,41,05,77,53,32,21


	CASE	2			; Tuning 2
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,6,7,7
		dc.w	8,8,9,9,10,10,11,12,12,13,14,15
period_nach:	dc.w	0
		dcw	12,13,14,15,15,16,17,18,20,21,22,23
		dcw	25,26,28,30,31,33,35,37,40,42,45,47
		dcw	50,53,56,60,63,67,71,76,80,85,90,95
		dcw	01,07,13,20,27,35,43,51,60,70,80,91
		dcw	02,15,27,41,56,70,87,03,21,42,62,82
		dcw	05,30,55,82,11,41,74,07,43,82,22,64
		dcw	11,60,10,64,22,83,48,14,87,64,44,28


	CASE	3			; Tuning 3
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,6,7,7
		dc.w	8,8,9,9,10,10,11,12,12,13,14,15
period_nach:	dc.w	0
		dcw	12,13,14,15,16,17,18,19,20,21,22,24
		dcw	25,27,28,30,32,34,36,38,40,42,45,48
		dcw	51,54,57,60,64,68,72,76,81,85,91,96
		dcw	02,08,14,21,28,36,44,52,62,71,82,92
		dcw	04,16,28,43,57,72,89,05,24,42,62,85
		dcw	08,33,58,86,15,45,78,11,48,87,28,71
		dcw	17,66,17,72,31,90,56,22,96,75,57,42


	CASE	4			; Tuning 4
period_vor	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,6,7,7
		dc.w	8,8,9,9,10,10,11,12,13,13,14,15
period_nach:	dc.w	0
		dcw	12,13,14,15,16,17,18,19,20,21,22,24
		dcw	25,27,28,30,32,34,36,38,40,43,45,48
		dcw	51,54,57,61,64,68,72,77,81,86,91,97
		dcw	02,09,15,22,29,37,45,53,63,73,83,94
		dcw	05,18,31,44,59,74,91,07,26,45,65,89
		dcw	11,36,62,89,18,48,82,15,53,93,34,78
		dcw	23,73,25,78,37,97,64,31,06,86,69,56


	CASE	5			; Tuning 5
period_vor	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,6,7,7
		dc.w	8,8,9,9,10,11,11,12,13,13,14,15
period_nach:	dc.w	0
		dcw	12,13,14,15,16,17,18,19,20,21,23,24
		dcw	25,27,29,30,32,34,36,38,41,43,46,48
		dcw	51,54,58,61,65,69,73,77,82,87,92,97
		dcw	03,09,16,23,30,38,46,55,64,74,84,95
		dcw	07,19,32,45,60,76,93,10,29,47,68,92
		dcw	14,38,65,93,21,54,86,20,58,98,37,81
		dcw	29,77,30,86,43,08,72,40,16,97,75,63


	CASE	6			; Tuning 6
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,4,5,5,5,6,6,7,7,7
		dc.w	8,8,9,9,10,11,11,12,13,14,14,15
period_nach:	dc.w	0
		dcw	13,13,14,15,16,17,18,19,20,21,23,24
		dcw	26,27,29,31,32,34,36,39,41,43,46,49
		dcw	52,55,58,62,65,69,73,78,82,87,93,98
		dcw	04,10,17,24,31,39,47,56,65,75,86,97
		dcw	08,21,33,48,62,77,95,12,31,50,72,92
		dcw	17,42,69,96,26,57,90,24,63,01,44,88
		dcw	35,84,38,92,53,15,80,49,27,03,88,77


	CASE	7			; Tuning 7
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	1,1,1,1,1,1,1,1,1,1,1,1
		dc.w	2,2,2,2,2,2,2,3,3,3,3,3
		dc.w	4,4,4,5,5,5,5,6,6,7,7,7
		dc.w	8,8,9,10,10,11,11,12,13,14,15,15
period_nach:	dc.w	0
		dcw	13,13,14,15,16,17,18,19,20,22,23,24
		dcw	26,27,29,31,33,35,37,39,41,44,46,49
		dcw	52,55,59,62,66,70,74,78,83,88,93,99
		dcw	05,11,17,25,32,40,48,57,67,76,87,98
		dcw	09,22,36,50,65,81,97,14,34,53,75,96
		dcw	20,45,71,00,30,61,94,29,68,07,50,92
		dcw	41,91,43,01,60,22,88,58,37,14,01,85


	CASE	-8			; Tuning -8
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,2,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,6,7
		dc.w	7,8,8,8,9,10,10,11,12,12,13,14
period_nach:	dc.w	0
		dcw	11,12,13,14,14,15,16,17,18,19,21,22
		dcw	23,25,26,28,29,31,33,35,37,39,42,44
		dcw	47,50,52,56,59,63,66,70,75,79,84,89
		dcw	94,00,05,12,18,26,33,41,50,59,68,78
		dcw	89,00,11,25,37,51,67,83,99,17,37,56
		dcw	77,00,23,49,75,05,35,66,00,36,74,13
		dcw	55,00,47,98,51,10,70,33,01,72,48,26


	CASE	-7			; Tuning -7
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,6,7
		dc.w	7,8,8,9,9,10,10,11,12,12,13,14
period_nach:	dc.w	0
		dcw	11,12,13,14,14,15,16,17,18,19,21,22
		dcw	23,25,26,28,29,31,33,35,37,39,42,44
		dcw	47,50,53,56,59,63,67,71,75,80,84,89
		dcw	95,00,06,12,19,27,34,42,50,59,69,79
		dcw	90,01,14,26,39,53,69,85,01,19,39,59
		dcw	80,02,26,51,79,08,38,70,02,38,76,19
		dcw	60,05,53,03,59,16,76,41,05,77,53,38


CASE	-6				; Tuning -6
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,6,7
		dc.w	7,8,8,9,9,10,10,11,12,12,13,14
period_nach:	dc.w	0
		dcw	11,12,13,14,15,15,16,17,18,20,21,22
		dcw	23,25,26,28,30,31,33,35,37,40,42,45
		dcw	47,50,53,56,60,63,67,71,76,80,85,90
		dcw	95,01,07,13,20,27,35,43,51,60,70,80
		dcw	91,02,15,27,41,56,70,87,03,21,42,62
		dcw	83,05,30,55,82,11,41,74,07,43,82,22
		dcw	66,11,60,10,64,22,83,48,14,87,64,44


	CASE	-5			; Tuning -5
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,6,7
		dc.w	7,8,8,9,9,10,10,11,12,12,13,14
period_nach:	dc.w	0
		dcw	12,12,13,14,15,16,17,18,19,20,21,22
		dcw	24,25,27,28,30,32,34,36,38,40,42,45
		dcw	48,51,54,57,60,64,68,72,76,81,85,91
		dcw	96,02,08,14,21,28,36,44,52,62,71,82
		dcw	92,04,16,28,43,57,72,89,05,24,42,62
		dcw	85,08,33,58,86,15,45,78,11,48,87,28
		dcw	71,17,66,17,72,31,90,56,22,96,75,57


	CASE	-4			; Tuning -4
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,6,7
		dc.w	7,8,8,9,9,10,10,11,12,13,13,14
period_nach:	dc.w	0
		dcw	12,12,13,14,15,16,17,18,19,20,21,22
		dcw	24,25,27,28,30,32,34,36,38,40,43,45
		dcw	48,51,54,57,61,64,68,72,77,81,86,91
		dcw	97,02,09,15,22,29,37,45,53,63,73,83
		dcw	94,05,18,31,44,59,74,91,07,26,47,65
		dcw	88,11,36,62,89,18,48,82,15,53,93,34
		dcw	76,23,73,25,78,37,97,64,31,06,86,69


	CASE	-3			; Tuning -3
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,6,7
		dc.w	7,8,8,9,9,10,11,11,12,13,13,14
period_nach:	dc.w	0
		dcw	12,12,13,14,15,16,17,18,19,20,21,23
		dcw	24,25,27,29,30,32,34,36,38,41,43,46
		dcw	48,51,54,58,61,65,69,73,77,82,87,92
		dcw	97,03,09,16,23,30,38,46,55,64,74,84
		dcw	95,07,19,32,45,60,76,93,10,29,47,68
		dcw	91,14,38,65,93,21,54,86,20,58,98,37
		dcw	83,29,77,30,86,43,08,72,40,16,97,75


	CASE	-2			; Tuning -2
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,4,5,5,5,6,6,7,7
		dc.w	7,8,8,9,9,10,11,11,12,13,14,14
period_nach:	dc.w	0
		dcw	12,13,13,14,15,16,17,18,19,20,21,23
		dcw	24,26,27,29,31,32,34,36,39,41,43,46
		dcw	49,52,55,58,62,65,69,73,78,82,87,93
		dcw	98,04,10,17,24,31,39,47,56,65,75,86
		dcw	97,08,21,33,48,62,77,95,12,31,50,72
		dcw	94,17,42,69,96,26,57,90,24,63,01,44
		dcw	88,35,84,38,92,53,15,80,49,27,03,88


	CASE	-1			; Tuning -1
period_vor:	dc.w	0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,1,1,1,1,1,1,1,1,1,1,1
		dc.w	1,2,2,2,2,2,2,2,3,3,3,3
		dc.w	3,4,4,4,5,5,5,5,6,6,7,7
		dc.w	7,8,8,9,10,10,11,11,12,13,14,15
period_nach:	dc.w	0
		dcw	12,13,13,14,15,16,17,18,19,20,22,23
		dcw	24,26,27,29,31,33,35,37,39,41,44,46
		dcw	49,52,55,59,62,66,70,74,78,83,88,93
		dcw	99,05,11,17,25,32,40,48,57,67,76,87
		dcw	98,10,22,36,50,65,81,97,14,34,53,75
		dcw	97,20,45,71,00,30,61,94,29,68,07,50
		dcw	94,41,91,43,01,60,22,88,58,37,14,01
	ENDS