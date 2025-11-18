//#include <lynx.h>
//#include <tgi.h>
//#include "_suzy.h"
//
//// matches _sprite in sprite.s
//extern const unsigned char sprite3[];
//extern const unsigned char sprite3_palette[];
//
//#define TYPE_NORMAL 0x00
//#define BPP_4       0x40 // 4bpp normal sprite
//#define REUSEPAL    0x20 // reuse palette

#include <lynx.h>
#include <tgi.h>
#include "_suzy.h"

#define SPRCTL0_4_bits_per_pixel  0xC0
#define SPRCTL0_normal            0x04

// #define SPRCTL1_literal           0x80   
#define SPRCTL1_no_palette        0x08  

// Externals from sprite3_data.s and sprite3_pal.s 
extern unsigned char bg4bit[];
extern unsigned char bg4bit_palette[];


SCB_RENONE bg4bit_scb = {
    SPRCTL0_4_bits_per_pixel | SPRCTL0_normal,    
    SPRCTL1_no_palette,          
    0x01,                                         
    0,                                         
    bg4bit,                                      
    0,                                          
    0                                            
};


void main(void)
{
    tgi_install(&tgi_static_stddrv);
    tgi_init();
    while (tgi_busy()) {}

    tgi_setpalette(bg4bit_palette);
    // tgi_setpalette(tgi_getdefpalette());
    tgi_setcolor(TGI_COLOR_WHITE);

    while (1)
    {
        tgi_clear();

        tgi_outtextxy(0, 0, "Sprite test");
        tgi_sprite(&bg4bit_scb);  // draw sprite

        tgi_updatedisplay();
        while (tgi_busy()) {}  // wait for VBL
    }
}
