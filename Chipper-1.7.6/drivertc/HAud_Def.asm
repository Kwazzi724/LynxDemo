;****************************************************************
;								*
;	      HandyAudition Defines, ZP, and Globals		*
;								*
;****************************************************************
BlockSize set 2048
Cart_Loadersize	set 410
	
;****************************************************************
;			  BLL Macros				*
;****************************************************************
	
	
	include <hardware.asm>
	include "help.mac"
	include "file.mac"
	include "if_while.mac"
	include "window.mac"
	include "mikey.mac"
	include "suzy.mac"
	include "irq.mac"
	include "debug.mac"
	include "newkey.mac"
	

	MACRO SHOW
	LDAY \0
	jsr DrawSprite
	ENDM

	MACRO JSHOW
	LDAY \0
	jmp DrawSprite
	ENDM
;****************************************************************
;		     BLL Variable Defines			*
;****************************************************************
	
	include "mikey.var"
	include "suzy.var"
	include "irq.var"
	
;****************************************************************
;			  Zeropage				*
;****************************************************************
BEGIN_ZP
;*************************
; Big, Important Globals *
;*************************
FrameCounter ds 1
FlipMode ds 1
FlipPressed ds 1
GLO_GenPointer ds 2
GLO_GameMode ds 1
GLO_GamePaused ds 1
GLO_PauseCount ds 1
GLO_LoadStage ds 1
GLO_LoadSFile ds 1
GLO_LoadScene ds 1
GLO_CurrentStage ds 1
;****************
; Hex Converter *
;****************
HEX_Value ds 1
HEX_XPos ds 1
HEX_YPos ds 1
AReg_YPos ds 1
AReg_Redir ds 2
;*********************
; Palette Operations *
;*********************
PAL_SrcPalLo ds 1
PAL_SrcPalHi ds 1
PAL_DestPalLo ds 1
PAL_DestPalHi ds 1
PAL_BrightnessAdjust ds 1
PAL_GreenAdjust ds 1
PAL_RedAdjust ds 1
PAL_BlueAdjust ds 1
;********************
; VSYNC/HSYNC Stuff *
;********************
FrameProcDone ds 1
VBlankProcDone ds 1
UserVBlank_EN ds 1
UserVBlank_Lo ds 1
UserVBlank_Hi ds 1
HBlank_FlipState ds 1
HBlank_OffX ds 1
HBlank_OffY ds 1
;****************
; Cartridge I/O *
;****************
FileBlockHigh ds 1
CurrBlock ds 1
BlockByte ds 2
entry	ds DirEntry.LEN	; space for current entry
DestPtr	dw 0
;**************
; IRQ Vectors *
;**************
SysIRQTable ds 16
;************
; BLL Temps *
;************
temp    ds 2
temp1   ds 2
temp2   ds 2
;***************************
; HandyMusic ZeroPage Vars *
;***************************
	
	include "HM_ZP.asm"
	
zeropage_pos	set $100-*
END_ZP

echo "Zeropage left: %Hzeropage_pos"
;****************************************************************
;			General Defines				*
;****************************************************************
INITIRQ SysIRQTable

;*** Audio Samples ***
FileNum_SampleBase	EQU 2
;*** Music Files ***
FileNum_MusicBase	EQU 2

;Display Buffer Location in RAM.
DispBuff0 set $C000
DispBuff1 set $E000
;****************************************************************
;			     END				*
;****************************************************************
