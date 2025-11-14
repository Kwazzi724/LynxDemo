;****************************************************************
;     Examples of Directly Declared HandyMusic Sound Effects	*
;****************************************************************
; The following is a set of example sound effects declared
; directly in bytecode. Of course it is suggested that you
; write all of your sound effects in the HandyMusic scripting
; language, but seeing the actual byte script of the sound effects
; may be a good educational tool.

; Sound Effects live at $A6B0-$AFFF

;;;;ORG $A6B0

; Since HandyAudition is using an EQU to check for the
; number of sound effects, we should define it here-
HandyMusic_NumberofSFX	EQU 6

; Sound Effects List:
; 0- Zaku's Rapid Shot, 128
; 1- Zaku's Back Blaster, 130
; 2- Zaku's Charge Up, 132
; 3- Zaku's Charge Shot, 133
; 4- VWF Letter Beep (Buzzy), 160
; 5- VWF Letter Beep (25% Square), 160
;****************************************************************
; Sound Effects Low Table					*
;****************************************************************
HandyMusic_SFX_ATableLo
	dc.b <Example_SFX_RShot,<Example_SFX_BackBlaster
	dc.b <Example_SFX_ChargeUp,<Example_SFX_ChargeShot

	dc.b <Example_SFX_VWFBuzzy,<Example_SFX_VWFSquare25

;****************************************************************
; Sound Effects High Table					*
;****************************************************************
HandyMusic_SFX_ATableHi
	dc.b >Example_SFX_RShot,>Example_SFX_BackBlaster
	dc.b >Example_SFX_ChargeUp,>Example_SFX_ChargeShot

	dc.b >Example_SFX_VWFBuzzy,>Example_SFX_VWFSquare25

;****************************************************************
; Sound Effects Priority Table					*
;****************************************************************
HandyMusic_SFX_PTable
	dc.b 128,130,132,133

	dc.b 160,160

;****************************************************************
; Sound Effects							*
;****************************************************************
;****************
; Effects 00-03 *
;****************
; Sound Effect Table for Zaku's Rapid Shot
Example_SFX_RShot
	dc.b 0,0,0,0 ; No note off, Shift reg zeroed
	dc.b $1A,%10100000 ; Feedback + integrate Register Settings
	dc.b 30      ; Volume
	dc.b -6,0    ; Volume Adjustment
	dc.b $2E,0   ; Frequency
	dc.b $ff,$ff,$70   ; Frequency Adjustment

	dc.b 1,4 ; Wait 4 frames
	dc.b 0 ; stop

; Sound Effect Table for Zaku's Back Blaster
Example_SFX_BackBlaster
	dc.b 0,0,0,0 ; No note off, Shift reg zeroed
	dc.b $54,%10000000 ; Feedback + integrate Register Settings
	dc.b 80      ; Volume
	dc.b -10,0    ; Volume Adjustment
	dc.b $9C,0   ; Frequency
	dc.b 0,0,0   ; Frequency Adjustment

	dc.b 1,3 ; wait 3 frames
	dc.b 4,$A0,0,15,0,0 ; set frequency
	dc.b 3,70,-3,0 ; set volume
	dc.b 1,14 ; wait 14 frames
	dc.b 0 ; stop

; Sound Effect Table for Zaku's Charge Up
Example_SFX_ChargeUp
	dc.b 0,0,1,0 ; No note off, Shift reg
	dc.b $08,%00100000 ; Feedback + integrate Register Settings
	dc.b 70      ; Volume
	dc.b 0,0     ; Volume Adjustment
	dc.b $9C,2   ; Frequency
	dc.b $F8,$FF,0   ; Frequency Adjustment

	dc.b 1,50 ; wait 50 frames
	dc.b 5,3 ; set loop point here, loop 3 times
	dc.b 4,255,2,$A0,$FF,0 ; set frequency
	dc.b 1,5 ; wait 5 frames
	dc.b 6 ; loop
	dc.b 0 ; stop

; Sound Effect Table for Zaku's Charge Shot
Example_SFX_ChargeShot
	dc.b 0,0,1,0 ; No note off, Shift reg
	dc.b $0A,%00000000 ; Feedback + integrate Register Settings
	dc.b 50      ; Volume
	dc.b 5,0     ; Volume Adjustment
	dc.b $00,3   ; Frequency
	dc.b $E0,$FF,$00   ; Frequency Adjustment

	dc.b 1,10 ; wait 10 frames
	dc.b 0 ; stop
;****************
; Effects 04-07 *
;****************
; Sound Effect Table for a VWF Character Beep (Buzzy)
Example_SFX_VWFBuzzy
	dc.b 0,0,0,0 ; No note off, Shift reg zeroed
	dc.b $0A,%00000000 ; Feedback + integrate Register Settings
	dc.b 110      ; Volume
	dc.b -5,0     ; Volume Adjustment
	dc.b $40,2   ; Frequency
	dc.b 0,0,0   ; Frequency Adjustment

	dc.b 1,6 ; wait 6 frames
	dc.b 0 ; stop

; Sound Effect Table for a VWF Character Beep (25% Square)
Example_SFX_VWFSquare25
	dc.b 0,0,1,0 ; No note off, Shift reg
	dc.b $08,%00000000 ; Feedback + integrate Register Settings
	dc.b 90      ; Volume
	dc.b -15,0     ; Volume Adjustment
	dc.b $00,2   ; Frequency
	dc.b 0,0,0   ; Frequency Adjustment

	dc.b 1,4 ; wait 4 frames
	dc.b 0 ; stop
;******************
; SFX Memory Left *
;******************
SGLeft set $7FFF-*
echo "Sound Effects Memory left: %HSGLeft"
    path
*
* EOF
*
