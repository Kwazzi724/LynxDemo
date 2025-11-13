#include <lynx.h> 
#include <tgi.h>
#include <6502.h>

extern unsigned char robot2[];
extern const unsigned char palette[];

void main(void) {
    static struct SCB_REHV scb = {
        0x30,   // sprctl0 - BPP_4, normal type
        0x00,   // sprctl1 - No special flags
        0x00,   // sprcoll- - collision number in the stack/data
        0,      // next none for now
        0,      // data (set below)
        100,    // hpos, centered
        80,     // vpos, centered
        0x0100, // hsize (normal 1:1)
        0x0100  // vsize (normal as well)
    };

    scb.data = (void*)robot2;

    tgi_install(&tgi_static_stddrv);
    tgi_init();

    CLI(); // clear 6502I

    while (1) {
        tgi_clear();
        tgi_sprite(scb);
        tgi_updatedisplay();
        while (tgi_busy()) {}
    }
}
