#include <lynx.h>
#include <tgi.h>
#include "_suzy.h"

#define SPRCTL0_4_bits_per_pixel  0xC0
#define SPRCTL0_normal            0x04

#define SPRCTL1_literal           0x80   // sprite data is literal (.spr from sprpck) 
#define SPRCTL1_no_palette        0x08   // use current palette, no inline palette 

// Externals from sprite3_data.s and sprite3_pal.s 
extern unsigned char sprite3[];
extern unsigned char sprite3_palette[];


//SCB_RENONE sprite3Scb = {
//    BPP_4 | TYPE_NORMAL,          // sprctl0: 4bpp, normal
//    REUSEPAL,                     // sprctl1: reuse palette
//    0x01,                         // sprcoll: collision group 
//    0,                            // next: no next SCB
//    (unsigned char*)sprite3,       // data: pointer to sprite pixels
//    80,                           // hpos
//    60                            // vpos
//};

SCB_RENONE sprite3_scb = {
    SPRCTL0_4_bits_per_pixel | SPRCTL0_normal,    
    SPRCTL1_literal | SPRCTL1_no_palette,         
    0x01,                                     
    0,                                            
    sprite3,                                    
    70,                                         
    60                                            
};


void main(void)
{
    tgi_install(&tgi_static_stddrv);
    tgi_init();
    while (tgi_busy()) {}

    // tgi_setpalette((unsigned char*)sprite3_palette);
    tgi_setpalette(tgi_getdefpalette());
    tgi_setcolor(TGI_COLOR_WHITE);

    while (1)
    {
        tgi_clear();

        tgi_outtextxy(0, 0, "Sprite test");
        tgi_sprite(&sprite3_scb);  // draw sprite

        tgi_updatedisplay();
        while (tgi_busy()) {}  // wait for VBL
    }
}
