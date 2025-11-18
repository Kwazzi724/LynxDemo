#include <lynx.h>
#include <tgi.h>
#include "_suzy.h"

// matches _sprite in sprite.s
extern const unsigned char sprite2[];
extern const unsigned char sprite2_palette[];

#define TYPE_NORMAL 0x00
#define BPP_4       0x40 // 4bpp normal sprite
#define REUSEPAL    0x20 // reuse palette

SCB_RENONE sprite2Scb = {
    BPP_4 | TYPE_NORMAL,          // sprctl0: 4bpp, normal
    REUSEPAL,                     // sprctl1: reuse palette
    0x01,                         // sprcoll: collision group 
    0,                            // next: no next SCB
    (unsigned char*)sprite2,       // data: pointer to sprite pixels
    80,                           // hpos
    60                            // vpos
};

void main(void)
{
    tgi_install(&tgi_static_stddrv);
    tgi_init();
    while (tgi_busy()) {}

    tgi_setpalette((unsigned char*)sprite2_palette);
    tgi_setcolor(TGI_COLOR_WHITE);

    while (1)
    {
        tgi_clear();

        tgi_outtextxy(0, 0, "Sprite test");
        tgi_sprite((void*)&sprite2Scb);   // draw sprite

        tgi_updatedisplay();
        while (tgi_busy()) {}  // wait for VBL
    }
}
