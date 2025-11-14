;****************************************************************
;     Examples of Directly Declared HandyMusic Music Tracks	*
;****************************************************************
; The following is a simple directly declared music track
; used to test panning.

;Music lives at $B000-$BFFF
ORG $B000
;****************************************************************
; Initial Priorities						*
;****************************************************************
	dc.b 200,200,100,100 ; 4 tracks
;****************************************************************
; Script Low Addresses						*
;****************************************************************
	dc.b <Example_Track0,<Example_Track1,<Example_Track2,<Example_Track3
;****************************************************************
; Script High Addresses						*
;****************************************************************
	dc.b >Example_Track0,>Example_Track1,>Example_Track2,>Example_Track3
;****************************************************************
; Instrument Table Pointers					*
;****************************************************************
	dc.b <InstrumentLoTable,>InstrumentLoTable
	dc.b <InstrumentHiTable,>InstrumentHiTable
;****************************************************************
; Instruments Low Table						*
;****************************************************************
InstrumentLoTable
	dc.b <Inst_WF07,<Inst_WF2A,<Inst_WF03
	dc.b <PowPow,<BassHold,<NoiseHit,<Square,<TriangleFlat,<TriangleDecay
;****************************************************************
; Instruments High Table					*
;****************************************************************
InstrumentHiTable
	dc.b >Inst_WF07,>Inst_WF2A,>Inst_WF03
	dc.b >PowPow,>BassHold,>NoiseHit,>Square,>TriangleFlat,>TriangleDecay
;****************************************************************
; Instruments							*
;****************************************************************
Inst_WF07
	dc.b <Inst_WF07_NoteOff,>Inst_WF07_NoteOff,0,1 ; note off, Shift reg
	dc.b $7,%00000000 ; Feedback + integrate Register Settings
	dc.b 10		; Volume
	dc.b 20,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b $FF,$FF,$C0	; Frequency Adjustment

	dc.b 1,4
	dc.b 3,90,0,0 ; Set volume
	dc.b 1,1
	dc.b 3,90,-4,0 ; Set volume
	dc.b 1,8
	dc.b 3,60,0,0 ; Set volume
	dc.b 5,-1 ; Infinite Loop
	dc.b 4,0,0,1,0,0 ; Cheap vibrato
	dc.b 1,2
	dc.b 4,2,0,$FF,$FF,0
	dc.b 1,4
	dc.b 4,-2,$FF,1,0,0
	dc.b 1,2
	dc.b 6 ; end loop
Inst_WF07_NoteOff
	dc.b 4,0,0,0,0,0 ; Recenter Frequency
	dc.b 1,4
	dc.b 3,60,-8,0
	dc.b 1,4
	dc.b 0 ; stop



Inst_WF2A
	dc.b <Inst_WF2A_NoteOff,>Inst_WF2A_NoteOff,0,0 ; note off, Shift reg
	dc.b $2A,%00000000 ; Feedback + integrate Register Settings
	dc.b 10		; Volume
	dc.b 20,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b $FF,$FF,$C0	; Frequency Adjustment

	dc.b 1,4
	dc.b 3,90,0,0 ; Set volume
	dc.b 1,1
	dc.b 3,90,-4,0 ; Set volume
	dc.b 1,8
	dc.b 3,60,0,0 ; Set volume
	dc.b 5,-1 ; Infinite Loop
	dc.b 4,0,0,1,0,0 ; Cheap vibrato
	dc.b 1,2
	dc.b 4,2,0,$FF,$FF,0
	dc.b 1,4
	dc.b 4,-2,$FF,1,0,0
	dc.b 1,2
	dc.b 6 ; end loop
Inst_WF2A_NoteOff
	dc.b 4,0,0,0,0,0 ; Recenter Frequency
	dc.b 1,4
	dc.b 3,60,-8,0
	dc.b 1,4
	dc.b 0 ; stop


Inst_WF03
	dc.b <Inst_WF03_NoteOff,>Inst_WF03_NoteOff,0,0 ; note off, Shift reg
	dc.b $03,%00000000 ; Feedback + integrate Register Settings
	dc.b 10		; Volume
	dc.b 20,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b $FF,$FF,$C0	; Frequency Adjustment

	dc.b 1,4
	dc.b 3,90,0,0 ; Set volume 90
	dc.b 1,1
	dc.b 3,90,-4,0 ; Set volume 90
	dc.b 1,8
	dc.b 3,60,0,0 ; Set volume 90
	dc.b 5,-1 ; Infinite Loop
	dc.b 4,0,0,1,0,0 ; The following is cheap vibrato
	dc.b 1,2
	dc.b 4,2,0,$FF,$FF,0
	dc.b 1,4
	dc.b 4,-2,$FF,1,0,0
	dc.b 1,2
	dc.b 6 ; end loop
Inst_WF03_NoteOff
	dc.b 4,0,0,0,0,0 ; Recenter Frequency
	dc.b 1,4
	dc.b 3,60,-8,0
	dc.b 1,4
	dc.b 0 ; stop


PowPow
	dc.b <PowPow_NoteOff,>PowPow_NoteOff,0,0 ; note off, Shift reg
	dc.b $40,%00100000 ; Feedback + integrate Register Settings
	dc.b 32		; Volume
	dc.b 0,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b 16,0,0	; Frequency Adjustment

	dc.b 1,7
	dc.b 3,0,0,0
	dc.b 5,-1 ; Infinite Loop
	dc.b 1,20 ; wait 20 frames
	dc.b 6 ; end loop
PowPow_NoteOff
	dc.b 0 ; stop



BassHold
	dc.b <BassHold_NoteOff,>BassHold_NoteOff,0,0 ; note off, Shift reg
	dc.b $40,%00100000 ; Feedback + integrate Register Settings
	dc.b 32		; Volume
	dc.b 0,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b 8,0,0	; Frequency Adjustment

	dc.b 5,-1 ; Infinite Loop
	dc.b 1,20 ; wait 20 frames
	dc.b 6 ; end loop
BassHold_NoteOff
	dc.b 0 ; stop



NoiseHit
	dc.b <NoiseHit_NoteOff,>NoiseHit_NoteOff,$f7,0 ; note off, Shift reg
	dc.b $E0,%10000000 ; Feedback + integrate Register Settings
	dc.b 64		; Volume
	dc.b -4,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b 0,0,0	; Frequency Adjustment

	dc.b 1,15
	dc.b 3,0,0,0
	dc.b 5,-1 ; Infinite Loop
	dc.b 1,20 ; wait 20 frames
	dc.b 6 ; end loop
NoiseHit_NoteOff
	dc.b 0 ; stop


Square
	dc.b <Square_NoteOff,>Square_NoteOff,0,0 ; note off, Shift reg
	dc.b $1,%00000000 ; Feedback + integrate Register Settings
	dc.b 90		; Volume
	dc.b -4,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b 0,0,0	; Frequency Adjustment

	dc.b 1,4
	dc.b 3,70,0,0
	dc.b 5,-1 ; Infinite Loop
	dc.b 1,20 ; wait 20 frames
	dc.b 6 ; end loop
Square_NoteOff
	dc.b 3,64,-8,0
	dc.b 1,6
	dc.b 0 ; stop



TriangleFlat
	dc.b <TriangleFlat_NoteOff,>TriangleFlat_NoteOff,0,0 ; note off, Shift reg
	dc.b $40,%00100000 ; Feedback + integrate Register Settings
	dc.b 32		; Volume
	dc.b 0,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b 0,0,0	; Frequency Adjustment

	dc.b 5,-1 ; Infinite Loop
	dc.b 1,20 ; wait 20 frames
	dc.b 6 ; end loop
TriangleFlat_NoteOff
	dc.b 0 ; stop



TriangleDecay
	dc.b <TriangleDecay_NoteOff,>TriangleDecay_NoteOff,0,0 ; note off, Shift reg
	dc.b $40,%00100000 ; Feedback + integrate Register Settings
	dc.b 32		; Volume
	dc.b -1,0	; Volume Adjustment
	dc.b $00,0	; Frequency
	dc.b 0,0,0	; Frequency Adjustment

	dc.b 1,30
	dc.b 3,0,0,0
	dc.b 5,-1 ; Infinite Loop
	dc.b 1,20 ; wait 20 frames
	dc.b 6 ; end loop
TriangleDecay_NoteOff
	dc.b 0 ; stop
;****************************************************************
; Sound Scripts							*
;****************************************************************
Example_Track0 ; (Drumkits/Extra triangle)
	dc.b 7,30,0	; Wait for a bit, then play some samples.
	dc.b 1,$F0
	dc.b 8,0	; NOTE- ONLY call samples in track 0!
	dc.b 7,30,0
	dc.b 1,$0F
	dc.b 8,0
	dc.b 7,50,0
	dc.b 1,$FF
	dc.b 9,<Track0_PatternDrum,>Track0_PatternDrum
	dc.b 9,<Track0_PatternDrum,>Track0_PatternDrum
	dc.b 9,<Track0_PatternDrum,>Track0_PatternDrum
	dc.b 9,<Track0_PatternDrum,>Track0_PatternDrum
	dc.b 8,1
	dc.b 7,46,0 ; 180 ticks

	dc.b 5,3
	dc.b 9,<Track0_PatternA,>Track0_PatternA
	dc.b 6

	dc.b 5,3
	dc.b 9,<Track0_PatternB,>Track0_PatternB
	dc.b 6

	dc.b 7,40,0
	dc.b 1,$FF
	dc.b 8,2
	dc.b 0,0
Track0_PatternDrum
	dc.b 8,1
	dc.b 7,6,0
	dc.b $A
Track0_PatternA
	dc.b 7,65,0
	dc.b 1,$F0
	dc.b 2,5,$20,$0,5
	dc.b 3,8
	dc.b 1,$0F
	dc.b 2,5,$20,$0,5
	dc.b 3,17
	dc.b $A
Track0_PatternB
	dc.b 1,$F0
	dc.b 2,7,$00,$1,15
	dc.b 2,7,$F0,$0,15
	dc.b 2,7,$D0,$0,15
	dc.b 2,7,$10,$1,15
	dc.b 3,10
	dc.b 1,$0F
	dc.b 2,7,$00,$1,15
	dc.b 2,7,$F0,$0,15
	dc.b 2,7,$D0,$0,15
	dc.b 2,7,$10,$1,15
	dc.b 3,20
	dc.b $A

Example_Track1 ; (Lead 1)
	dc.b 1,$FF ; Both Speakers
	dc.b 7,30,0 ; Slight Offset from Ch 0
	dc.b 4,$FF,$FF,0
	dc.b 2,1,$40,$1,60
	dc.b 3,10
	dc.b 4,$F5,$FF,0
	dc.b 2,1,$40,$1,15
	dc.b 3,5
	dc.b 4,0,0,0
	dc.b 7,60,0 ; 180 ticks

	dc.b 5,3
	dc.b 2,6,$F0,$1,4
	dc.b 3,6
	dc.b 2,6,$F0,$1,2
	dc.b 3,4
	dc.b 2,6,$E0,$1,2
	dc.b 3,4
	dc.b 2,6,$D0,$1,2
	dc.b 3,8
	dc.b 2,6,$E0,$1,2
	dc.b 3,4
	dc.b 2,6,$F0,$1,2
	dc.b 3,4
	dc.b 2,6,$00,$2,2
	dc.b 3,4
	dc.b 2,6,$10,$2,4
	dc.b 3,2
	dc.b 2,6,$F0,$1,4
	dc.b 3,40
	dc.b 6

	dc.b 2,1,$40,$1,8
	dc.b 3,2
	dc.b 2,1,$40,$1,8
	dc.b 3,2
	dc.b 2,1,$40,$1,120
	dc.b 3,10
	dc.b 2,1,$50,$1,8
	dc.b 3,2
	dc.b 2,1,$50,$1,8
	dc.b 3,2
	dc.b 2,1,$50,$1,120
	dc.b 3,10
	dc.b 2,1,$60,$1,8
	dc.b 3,2
	dc.b 2,1,$60,$1,8
	dc.b 3,2
	dc.b 2,1,$60,$1,120
	dc.b 3,10
	dc.b 0,0





Example_Track2 ; (Lead 2)
	dc.b 1,$FF ; Both Speakers
	dc.b 7,32,0 ; Slight Offset from Ch 0
	dc.b 4,$FF,$FF,0
	dc.b 2,0,$C0,$1,60
	dc.b 3,10
	dc.b 4,$F5,$FF,0
	dc.b 2,0,$C0,$1,15
	dc.b 3,5
	dc.b 4,0,0,0
	dc.b 7,60,0 ; 180 ticks

	dc.b 7,100,0
	dc.b 5,2
	dc.b 2,1,$F0,$1,4
	dc.b 3,6
	dc.b 2,1,$F0,$1,2
	dc.b 3,4
	dc.b 2,1,$E0,$1,2
	dc.b 3,4
	dc.b 2,1,$D0,$1,2
	dc.b 3,8
	dc.b 2,1,$E0,$1,2
	dc.b 3,4
	dc.b 2,1,$F0,$1,2
	dc.b 3,4
	dc.b 2,1,$00,$2,2
	dc.b 3,4
	dc.b 2,1,$10,$2,4
	dc.b 3,2
	dc.b 2,1,$F0,$1,4
	dc.b 3,40
	dc.b 6

	dc.b 2,0,$C0,$1,8
	dc.b 3,2
	dc.b 2,0,$C0,$1,8
	dc.b 3,2
	dc.b 2,0,$C0,$1,120
	dc.b 3,10
	dc.b 2,0,$D0,$1,8
	dc.b 3,2
	dc.b 2,0,$D0,$1,8
	dc.b 3,2
	dc.b 2,0,$D0,$1,120
	dc.b 3,10
	dc.b 2,0,$E0,$1,8
	dc.b 3,2
	dc.b 2,0,$E0,$1,8
	dc.b 3,2
	dc.b 2,0,$E0,$1,120
	dc.b 3,10
	dc.b 0,0





Example_Track3 ; (PowPow/BassLine)
	dc.b 1,$FF ; Both Speakers
	dc.b 7,30,0 ; Wait for a bit...

	dc.b 2,4,$00,$1,5
	dc.b 3,30
	dc.b 2,4,$00,$1,5
	dc.b 3,30
	dc.b 7,80,0 ; 180 ticks

	dc.b 7,200,0
	dc.b 2,7,$F0,$0,4
	dc.b 3,6
	dc.b 2,7,$F0,$0,2
	dc.b 3,4
	dc.b 2,7,$E0,$0,2
	dc.b 3,4
	dc.b 2,7,$D0,$0,2
	dc.b 3,8
	dc.b 2,7,$E0,$0,2
	dc.b 3,4
	dc.b 2,7,$F0,$0,2
	dc.b 3,4
	dc.b 2,7,$00,$1,2
	dc.b 3,4
	dc.b 2,7,$10,$1,4
	dc.b 3,2
	dc.b 2,7,$F0,$0,4
	dc.b 3,40

	dc.b 5,3
	dc.b 7,30,0
	dc.b 2,2,$40,$3,20
	dc.b 2,2,$60,$3,20
	dc.b 2,2,$20,$3,20
	dc.b 2,2,$40,$3,40
	dc.b 3,20
	dc.b 6
	dc.b 0,0
;********************
; Music Memory Left *
;********************
MSLeft set $BFFF-*
echo "Music Memory left: %HMSLeft"
    path
*
* EOF
*
