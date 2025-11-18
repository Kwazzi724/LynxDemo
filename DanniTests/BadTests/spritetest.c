#include <lynx.h>
#include <tgi.h>
#include "_suzy.h"

// matches _sprite in sprite.s
extern const unsigned char sprite[];

#define TYPE_NORMAL 0x00
#define BPP_4       0x40 // 4bpp normal sprite
#define REUSEPAL    0x20 // reuse palette

SCB_RENONE spriteScb = {
    BPP_4 | TYPE_NORMAL,          // sprctl0: 4bpp, normal
    REUSEPAL,                     // sprctl1: reuse palette
    0x01,                         // sprcoll: collision group 
    0,                            // next: no next SCB
    (unsigned char*)sprite,       // data: pointer to sprite pixels
    40,                           // hpos
    30                            // vpos
};

void main(void)
{
    tgi_install(&tgi_static_stddrv);
    tgi_init();
    while (tgi_busy()) {}

    tgi_setpalette(tgi_getdefpalette());  // default palette
    tgi_setcolor(TGI_COLOR_WHITE);

    while (1)
    {
        tgi_clear();

        tgi_outtextxy(0, 0, "Sprite test");
        tgi_sprite((void*)&spriteScb);   // draw sprite

        tgi_updatedisplay();
        while (tgi_busy()) {}  // wait for VBL
    }
}
