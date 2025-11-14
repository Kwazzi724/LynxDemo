;****************************************************************
;    Cartridge IO Routines (Based Upon BLL with some changes)	*
;****************************************************************
; All of these functions use the following ZP Vars:		*
;	-FileBlockHigh						*
;	-CurrBlock						*
;	-BlockByte						*
;	-entry							*
;	-DestPtr						*
;****************************************************************
ECHO "Blocksize : %DBlockSize"
;****************************************************************
; LoadDir::							*
;	Load the Directory Entry (A=File Number).		*
;****************************************************************
LoadDir::
	PHA
	LDA _IOdat ; (Set Audin back to 0 so we're in bank 0)
	AND#%11101111
	STA _IOdat
	PLA

	stz CurrBlock
	stz FileBlockHigh
	jsr SelectBlock
	asl
	ROL FileBlockHigh
	asl
	ROL FileBlockHigh
	asl
	ROL FileBlockHigh; A=Block*8,FileBlockHigh=High Bits
.1
	clc
	adc #<Cart_Loadersize; Add Loader Size to get directory base
	eor #$FF
	tax
	LDA #>Cart_Loadersize
	adc FileBlockHigh
	eor #$ff
	tay

	jsr ReadOver
	ldx #0
	ldy #8
.loopLD
	jsr ReadByte
	sta entry,x
	inx
	dey
	bne .loopLD     
	rts

;****************************************************************
; OpenFile::							*
;	Load a file into memory (A=File Number).		*
;****************************************************************
OpenFile::
	jsr LoadDir
	lda entry+DestAddr
	ora entry+DestAddr+1            ; dest == 0 ?
	bne .cont0                      ; no =>
	lda DestPtr                   ; fetch
	sta entry+DestAddr
	lda DestPtr+1
	sta entry+DestAddr+1
	bra .cont1
.cont0
	lda entry+DestAddr
	sta DestPtr
	lda entry+DestAddr+1
	sta DestPtr+1                 ; dest.
.cont1
	LDA entry+ExecFlag	; Check to see if exec flag bit 0 is set
	AND#1			; in order to toggle AUDIN
	bne .cont1a		; for 1MB Bank control.
	LDA _IOdat		; Remember, Bit 0 is AUDIN, Bit 1 is CART0/1 select
	AND#%11101111
	STA _IOdat
	bra .cont2
.cont1a
	LDA _IOdat
	ORA#%00010000
	STA _IOdat
.cont2
	lda entry+StartBlock
	sta CurrBlock                   ; startblock
	jsr SelectBlock
	ldx entry+BlockOffset
	ldy entry+BlockOffset+1
	jsr ReadOver
	ldx entry+FileLen
	ldy entry+FileLen+1
	rts

****************
* load file (A = number)
****************
LoadFile::      jsr OpenFile
                jsr ReadBytes
                ldx entry+DestAddr
                ldy entry+DestAddr+1
                rts


IFD LoadPrgUser
****************
* load program A
* Y != 0 => execute
****************
LoadPrg::       phy
                jsr OpenFile
                lda entry+ExecFlag
                beq .9
                cmp #$88
                bne .1
                jsr ReadBytes
                pla
                beq .10
                bra .2
IFD LoadPckUser
.1              cmp #$89
                bne .exit
                jsr ReadPackedBytes
                pla
                beq .10         
ENDIF           
.2              jmp (entry+DestAddr)

IFND LoadPckUser
.1
ENDIF
.exit           sec
                rts
                
.9              jsr ReadBytes
                pla
.10             ldx entry+DestAddr
                ldy entry+DestAddr+1
                clc
                rts
ENDIF           

IFD LoadPckUser
****************
* read TPacked file
* length (unpacked) in FileLen
****************
ReadPackedBytes::
                stz temp1       ; clear bit-counter
.loop0          asl temp1       ; next bit
                bne .loop1      ; not last =>
                jsr ReadByte    ; next packed byte
                sta temp1+1     ; save
                dec temp1       ; init bit-counter
.loop1          asl temp1+1     ; pack-byte <<
                bcs .cont0      ; C=1 => sequenz
;---------------
                jsr ReadByte    ; fetch next byte
                sta (DestPtr)   ; and save
                inc DestPtr
                bne .cont3
                inc DestPtr+1
.cont3          inc entry+FileLen
                bne .loop0
                inc entry+FileLen+1
                bne .loop0
                rts
;---------------
.cont0          jsr ReadByte    ; counter and offset
                tay             ; fetch,save
                REPT 4          ; and
                  lsr           ; align
                ENDR
                tax
                jsr ReadByte    ; offset-low-byte  (0..$FFF)
                clc
                sbc DestPtr
                eor #$ff
                sta temp
                txa
                sbc DestPtr+1
                eor #$ff
                sta temp+1
                tya
                ldy #0
                and #$f
                inc
                inc
                tax
.loop2          lda (temp),y
                sta (DestPtr)
                inc DestPtr
                bne .cont
                inc DestPtr+1
.cont           inc entry+FileLen
                bne .cont2
                inc entry+FileLen+1
                beq .ende
.cont2          iny
                dex
                bpl .loop2
                bra .loop0
.ende           rts
ENDIF
****************
* overead bytes
* X:Y count ( EOR $FFFF )
****************
ReadOver::      inx
                bne .cont0
                iny
                beq .exit
.cont0          jsr ReadByte
                bra ReadOver
****************
* load to DestPtr
* X:Y count (EOR $FFFF)
****************
ReadBytes       inx
                bne .cont1
                iny
                beq .exit
.cont1          jsr ReadByte    ; ein Byte von der Karte
                sta (DestPtr)
                inc DestPtr
                bne ReadBytes
                inc DestPtr+1
                bra ReadBytes
;.exit          rts
****************
* fetch byte from card
****************
ReadByte
		LDA entry+ExecFlag
		AND#2
		beq LoROMRead
	        lda $fcb3
		bra IncCartByte
LoROMRead
	        lda $fcb2
IncCartByte
                inc BlockByte
                bne .exit
                inc BlockByte+1
                bne .exit
****************
* Select a block
****************
SelectBlock     pha
                phx
                phy
                lda _IOdat
                and #$fC
                tay
                ora #2
                tax
                lda CurrBlock
                inc CurrBlock
                SEC
                BRA SBL2
SLB0            BCC SLB1
                STX $FD8B
                CLC
SLB1            INX
                STX $FD87
                DEX
SBL2            STX $FD87
                ROL
                STY $FD8B
                BNE SLB0

                lda _IOdat
                sta $fd8b
                stz BlockByte
                lda #$100-(>BlockSize)
                sta BlockByte+1
                ply
                plx
                pla
.exit           RTS

                END

