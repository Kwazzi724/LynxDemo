#include <lynx.h>
#include <tgi.h>
#include "_suzy.h"

// sprite control bits (from the blog comments/updated cc65) 
#define SPRCTL0_4_bits_per_pixel  0xC0
#define SPRCTL0_normal            0x04

// #define SPRCTL1_literal           0x80   // sprite data is literal (.spr from sprpck), do not use for normal sprites
#define SPRCTL1_no_palette        0x08   // use current palette, no inline palette 

// Externals from sprite3_data.s and sprite3_pal.s 
extern unsigned char bg4bit[];
// Example palette – replace with ones from the generator
static unsigned char dungeonPalette[32] = {
    // for e.g.
    // first 16 bytes = high bytes of each colour 
    //0x01, 0x04, 0x08, 0x0C,
    //0x0C, 0x08, 0x05, 0x05,
    //0x07, 0x0E, 0x09, 0x03,
    //0x02, 0x0F, 0x08, 0x00,

    //// next 16 bytes = low bytes of each colour 
    //0xCA, 0xB4, 0xC4, 0xC3,
    //0x53, 0x22, 0x52, 0x27,
    //0x5E, 0x0F, 0xAF, 0x4D,
    //0x48, 0xFF, 0x88, 0x00

    // first 16 high byte / green components (G) 
    0x00, // 0 black          
    0x01, // 1 dark brown     
    0x03, // 2 mid brown      
    0x04, // 3 light brown    
    0x02, // 4 shadow purple  
    0x02, // 5 dark grey-blue 
    0x04, // 6 mid grey-blue  
    0x07, // 7 highlight grey 
    0x08, // 8 yellow   
    0x06, // 9 orange   
    0x0C, // 10 white    
    0x00, // 11 shadow   
    0x01, // 12 dark grey   
    0x06, // 13 blue   
    0x03, // 14 red    
    0x00, // 15 spare

    // next 16 low byte /  blue & red packed (BBBBRRRR)
    0x00, 
    0x14, 
    0x39, 
    0x35, 
    0x54, 
    0x87,
    0xAA, 
    0x2F, 
    0x1E, 
    0xCF, 
    0x11, 
    0x23, 
    0xFA,
    0x1F, 
    0x00 

    // 0x04, /* 0: 446 -> G=4 */
    //0x00, /* 1: 000 -> G=0 */
    //0x08, /* 2: 888 -> G=8 */
    //0x0A, /* 3: AC8 -> G=A */
    //0x04, /* 4: 448 -> G=4 */
    //0x08, /* 5: 84E -> G=8 */
    //0x04, /* 6: 484 -> G=4 */
    //0x0A, /* 7: ACE -> G=A */
    //0x0E, /* 8: E4E -> G=E */
    //0x08, /* 9: 842 -> G=8 */
    //0x0F, /*10: FFF -> G=F */
    //0x0C, /*11: CC6 -> G=C */
    //0x00, /*12: 000 */
    //0x00, /*13: 000 */
    //0x00, /*14: 000 */
    //0x00, /*15: 000 */

    ///* 16–31: blue+red packed as (BBBB RRRR) */
    //0x46, /* 0: 446 -> B=4,R=6  -> 0x46 */
    //0x00, /* 1: 000 -> 0x00 */
    //0x88, /* 2: 888 -> 0x88 */
    //0xC8, /* 3: AC8 -> B=C,R=8  -> 0xC8 */
    //0x48, /* 4: 448 -> 0x48 */
    //0x4E, /* 5: 84E -> B=4,R=E  -> 0x4E */
    //0x84, /* 6: 484 -> B=8,R=4  -> 0x84 */
    //0xCE, /* 7: ACE -> 0xCE */
    //0x4E, /* 8: E4E -> B=4,R=E  -> 0x4E */
    //0x42, /* 9: 842 -> B=4,R=2  -> 0x42 */
    //0xFF, /*10: FFF -> 0xFF */
    //0xC6, /*11: CC6 -> B=C,R=6  -> 0xC6 */
    //0x00, /*12: 000 */
    //0x00, /*13: 000 */
    //0x00, /*14: 000 */
    //0x00  /*15: 000 */
};



SCB_RENONE bg4bit_scb = {
    SPRCTL0_4_bits_per_pixel | // for 4 bit .bmp images
    SPRCTL0_normal,     // normal/default sprite
    SPRCTL1_no_palette,          // sprctl1 = NO stretching!!!) and here it is not SPRCTL1_literal
    0x01,                                          // sprcoll (collision group) 
    0,                                             // next SCB = none 
    bg4bit,                                       // pointer to sprite pixel data 
    0,                                            // x position 
    0                                             // y position 
};


void main(void)
{
    tgi_install(&tgi_static_stddrv);
    tgi_init();
    while (tgi_busy()) {}

    // tgi_setpalette() expects 32 bytes: 16 “high” bytes, 16 “low” bytes (2 bytes per colour).
    tgi_setpalette(dungeonPalette);
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
