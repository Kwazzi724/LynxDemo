;****************************************************************
;		     IRQ Mangement Routines			*
;****************************************************************
; All of these functions use the following ZP Vars:		*
;	-SysIRQTable						*
;****************************************************************
;****************************************************************
; InitIRQ::							*
;	Initializes the IRQ table.				*
;****************************************************************
; created : 17.8.92
; last changes : 170796/250296/131293/2406093

; 25.02.96      $FFF9 now %1100 instead of %1000
; 17.07.96      change IRQ-handle
; 28.01.97      special handling for Tx/Rx-IRQ

InitIRQ::       php
                sei
                lda #$c         
                sta $fff9
                lda #<irq
                sta $fffe
                lda #>irq
                sta $ffff
                ldy #<dummy_irq
                ldx #15
.loop           lda #>dummy_irq
                sta SysIRQTable,x
                dex
                tya
                sta SysIRQTable,x
                dex
                bpl .loop
IFD BRKuser
                lda #>dummy_irq
                sta BRKvec+1
                sty BRKvec
ENDIF
                plp
dummy_irq
                rts

INTRST	EQU $FD80	; Interrupt Reset and Set registers
INTSET	EQU $FD81
;****************************************************************
; irq::								*
;	The IRQ entry point.					*
;****************************************************************
irq::
* === =======================================================================
* This code is called whenever a non-NMI interrupt occurs (either a hardware 
* interrupt or execution of a software BRK).  
		PHA
		PHX
		PHY
hardInt
		;------	We had a hardware interrupt.  
		;------	Get the interrupt flags value, reset the bits
		LDA INTSET		; This gets the bits
		STA INTRST		; This clears the bits we just got

		;------	For each set bit in the interrupt value, 
		;------	vector to the routine
		LDX	#0
intLoop		BIT	#$01
		BEQ	intDone
		JSR	jumpIntTable

intDone		
		LSR
		INX
		INX
		CPX	#4*2
		bne	intLoop

		;------	At end of interrupt processing, restore the 
		;------	registers and return from interrupt
		PLY
		PLX
		PLA
		RTI


jumpIntTable
* The above interrupt dispatcher does a JSR to this line of code.  
* This code jumps to the interrupt dispatcher.  The interrupt dispatcher 
* should end with and RTS, which will return control to the above code.  
		JMP	(SysIRQTable,X)