;****************************************************************
;		      HandyAudition- Main File			*
;****************************************************************

	path
	path "drivertc"
	include "bsmac.mac"

	include "HAud_Def.asm"
    

;Engine Functions live at $1000-$2FFF
ORG $1000
    run
Start::
;****************************************************************
; Included Files/Functions					*
;****************************************************************
    
;*********************
; Hardware Functions *
;*********************
;Hardware Initialization
	include "LYNX_All.asm"
;Buttons
	include "LYNX_But.asm"
;IRQ
	include "LYNX_IRQ.asm"
;V/HSYNC
	include "LYNX_Vid.asm"
;Cartridge I/O
	include "LYNX_Crt.asm"
;**************************
; HandyAudition Functions *
;**************************
;All of them...
	include "HA_All.asm"
;****************************************************************
; Shared Graphics						*
;****************************************************************
    
    
;***********
; Hex Font *
;***********
HUD_0_data::		ibytes "HUD_0.spr"
HUD_1_data::		ibytes "HUD_1.spr"
HUD_2_data::		ibytes "HUD_2.spr"
HUD_3_data::		ibytes "HUD_3.spr"
HUD_4_data::		ibytes "HUD_4.spr"
HUD_5_data::		ibytes "HUD_5.spr"
HUD_6_data::		ibytes "HUD_6.spr"
HUD_7_data::		ibytes "HUD_7.spr"
HUD_8_data::		ibytes "HUD_8.spr"
HUD_9_data::		ibytes "HUD_9.spr"
TXT_41_data::		ibytes "TXT_41.spr"
TXT_42_data::		ibytes "TXT_42.spr"
TXT_43_data::		ibytes "TXT_43.spr"
TXT_44_data::		ibytes "TXT_44.spr"
TXT_45_data::		ibytes "TXT_45.spr"
TXT_46_data::		ibytes "TXT_46.spr"
;******
; Etc *
;******
SFX_Labl_data::		ibytes "SFX_Labl.spr"
AREGLABL_data::		ibytes "AREGLABL.spr"
ZPixel_data::		ibytes "ZPixel.spr"
;***************************
; HandyAudition Space Left *
;***************************
ADLeft set $6FFF-*
echo "HandyAudition Memory left: %HADLeft"
;****************************************************************
; HandyMusic Driver ($2000-$A6AF)				*
;****************************************************************
	
	
;Main Driver Source
	include "HandyMusic.asm"
	
;****************************************************************
; HandyAudition Example Sound Effects ($36B0-$3FFF)		*
;****************************************************************
	
	
	include "ASM_SFX.asm"
	
;****************************************************************
; HandyAudition Example Music ($4000-$BFFF)			*
;****************************************************************
	
	
;;	include "ASM_MUS.asm"
	path
	org $4000
	include "tmp_tc.asm"
MusicLeft set $BFFF-*
echo "HandyAudition Musik Memory left: %HMusicLeft"
	
*
* EOF
*
