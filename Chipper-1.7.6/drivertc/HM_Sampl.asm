;****************************************************************
;	    HandyMusic- Audio Sample Playback Routines		*
;****************************************************************
; All of these functions use the following ZP Vars:		*
;	-Sample_Playing						*
;	-Sample_PanBackup					*
;	-FileBlockHigh						*
;	-CurrBlock						*
;	-BlockByte						*
;	-entry							*
;	-DestPtr						*
;****************************************************************
;****************************************************************
; PlayPCMSample::						*
;	Starts playing a PCM Sample (Sample number in A) by	*
;	capturing channel 0 from HandyMusic, and starting the 	*
;	read stream using timer 3. HandyMusic is given back 	*
;	control of channel 0 once the sample is			*
;	finished playing.					*
;****************************************************************
PlayPCMSample::
	PHA
	sei					; Kill IRQs just for a bit to...
	LDA#$FF
	STA HandyMusic_Channel_NoWriteBack	; Capture Channel 0
	STZ $FD25
	STZ $fd0d ; Disable IRQ3 in case sample is already playing
	cli
	LDA $FD40
	STA Sample_PanBackup
	LDA#$FF
	STA $FD40
	STA Sample_Playing ; Sample is playing
	PLA
	clc
;**********************
; Load File Directory *
;**********************
	ADC#FileNum_SampleBase ; Sample File Offsets
	jsr LoadDir ; Load Directory
;***********************
; Parse File Directory *
;***********************
.ParseDir00
	LDA entry+ExecFlag ; Check to see if exec flag is set
	bne .ParseDir01 ; in order to toggle AUDIN
	LDA _IOdat ; (For 1MB Card control)
	AND#%11101111
	STA _IOdat
	bra .ParseDir02
.ParseDir01
	LDA _IOdat
	ORA#%00010000
	STA _IOdat
.ParseDir02
	lda entry+StartBlock
	sta CurrBlock                   ; startblock
	jsr SelectBlock
	ldx entry+BlockOffset
	ldy entry+BlockOffset+1
	jsr ReadOver
;********************
; Setup Timer 3 IRQ *
;********************
	STZ $fd0d
	LDA#<PCMSample_IRQ
	STA irq_vecs+(3)*2
	LDA#>PCMSample_IRQ
	STA irq_vecs+(3)*2+1
	LDA#125
	STA $fd0c; T3 Backup (125)
	STA $fd0e; T3 Current
	LDA#$D8
	STA $fd0d; T3 Mode (~8000Hz Reload)
	rts



;****************************************************************
; PCMSample_IRQ::						*
;	Streams a single sample from the cartridge, playing	*
;	it through the direct volume register of channel 0.	*
;	Automatically disabled when playback is finished.	*
;****************************************************************
PCMSample_IRQ::
echo "HandyMusic PCM IRQ Address: %HPCMSample_IRQ"
***************************
* Read one byte from Cart *
***************************
	PHP
	PHA
	INC entry+FileLen
	bne .KeepReading
	INC entry+FileLen+1
	beq .PlayBackDone
.KeepReading
	jsr .ReadByte	; Read byte
	sta $fd22	; Store to Direct Volume reg
	bra .ExitIRQ
.PlayBackDone
	STZ $fd0d ; Kill IRQ, Sample is finished.
	STZ Sample_Playing ; Sample is not playing
	LDA Sample_PanBackup
	STA $FD40
	STZ HandyMusic_Channel_NoWriteBack
.ExitIRQ
	PLA
	PLP
	rts
**********************************************************
* Fetch one byte from cart, reselecting block if needed. *
**********************************************************
.ReadByte
	LDA entry+ExecFlag
	AND#2
	beq .LoROMRead
	lda $fcb3
	bra .IncCartByte
.LoROMRead
	lda $fcb2
.IncCartByte
	inc BlockByte
	bne .BailOut
	inc BlockByte+1
	bne .BailOut
	jmp SelectBlock
.BailOut
	rts


