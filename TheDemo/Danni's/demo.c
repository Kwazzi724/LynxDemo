#include <lynx.h>
#include <tgi.h>
#include <stdlib.h>
#include <6502.h> 

extern void drawRaytrace(void); // dok's :)

// confines
#define SCREEN_WIDTH  160
#define SCREEN_HEIGHT 102

// timer
//static void wait_frames(unsigned int frames)
//{
//    while (frames--)
//    {
//        waitvbl();    /* from lynx.h, waits one VBL (frame) (doesnt work lol) */
//    }
//}
//
//static void wait_seconds(unsigned char seconds)
//{
//    // ~60 fps on Lynx
//    wait_frames((unsigned int)seconds * 60);
//}

#define DELAY_SECOND_LOOPS  10000UL

static void delay_loops(unsigned long loops)
{
    unsigned long i;
    for (i = 0; i < loops; ++i)
    {
        asm("nop");
    }
}

static void wait_seconds(unsigned char seconds)
{
    // crude blocking delay
    delay_loops((unsigned long)seconds * DELAY_SECOND_LOOPS);
}

// small delay used between the expanding circles 
static void small_delay(void)
{
    delay_loops(1000UL);
}


///////// PART 1: GREET /////////

#define draw_color 9
#define delay_cycles 800

#define screen_w 160
#define screen_y 102

static const unsigned char HELLO[][2] = {
    {27,30},{27,31},{27,32},{27,33},{27,34},{27,35},
    {26,36},{26,37},{26,38},{26,39},{26,40},{26,41},{26,42},
    {25,43},{25,44},{25,45},{25,46},{25,47},{25,48},{25,49},{25,50},{25,51},{25,52},{25,53},{25,54},{25,55},{25,56},{25,57},{25,58},{25,59},{25,60},
    {26,47},{27,47},{28,47},{29,47},{30,47},{31,47},{32,47},{33,47},{34,47},{35,47},
    {37,32},{37,33},{37,34},{37,35},{37,36},{37,37},{37,38},{37,39},{37,40},{37,41},{37,42},{37,43},{37,44},{37,45},{37,46},
    {36,47},{36,48},{36,49},{36,50},{36,51},{36,52},{36,53},{36,54},{36,55},{36,56},{36,57},{36,58},{36,59},{36,60},
    {42,50},{43,50},{44,50},{45,50},{46,50},{47,51},{48,51},{49,51},{50,50},
    {51,49},{51,48},{51,47},{51,46},{51,45},{50,44},{49,44},{48,44},{47,44},{46,44},{46,45},{45,45},{44,46},{44,47},{43,47},{43,48},{43,49},
    {42,51},{42,52},{42,53},{43,54},{44,55},{45,55},{46,55},{47,56},{48,56},{49,56},{50,56},{51,56},{52,56},{53,55},
    {58,32},{58,33},{58,34},{58,35},{58,36},{58,37},{58,38},{58,39},{58,40},{58,41},{58,42},{58,43},{58,44},{58,45},{58,46},{58,47},{58,48},{58,49},{58,50},{58,51},{58,52},{58,53},{58,54},{58,55},{58,56},{58,57},{58,58},{58,59},{58,60},{59,60},
    {63,32},{63,33},{63,34},{63,35},{63,36},{63,37},{63,38},{63,39},{63,40},{63,41},{63,42},{63,43},{63,44},{63,45},{63,46},{63,47},{63,48},{63,49},{63,50},{63,51},{63,52},{63,53},{63,54},{63,55},{63,56},{63,57},{63,58},{63,59},{63,60},{63,61},
    {72,49},{71,49},{70,49},{69,50},{68,51},{68,52},{68,53},{67,54},{67,55},{67,56},{68,57},{68,58},{68,59},{69,59},{70,60},{71,60},{72,60},{73,60},{74,60},{75,60},{76,60},{77,60},
    {78,59},{78,58},{78,57},{78,56},{78,55},{78,54},{78,53},{77,52},{77,51},{76,50},{76,49},{75,49},{74,49},{73,48},
    {92,35},{92,36},{92,37},{92,38},{92,39},{92,40},{92,41},
    {101,35},{101,36},{101,37},{101,38},{101,39},{101,40},{101,41},{101,42},
    {89,46},{90,46},{91,46},{92,46},{93,46},{94,46},{95,46},{96,46},{97,46},{98,46},{99,46},{100,46},{101,46},{102,46},{103,46},{104,46},
    {89,47},{89,48},{89,49},{89,50},{90,51},{90,52},{91,53},{92,54},{93,54},{93,55},{94,55},{95,55},{96,55},{97,55},{98,55},{99,55},{100,55},
    {101,54},{102,54},{102,53},{103,53},{103,52},{104,51},{104,50},{104,49},{104,48},{104,47},
    {114,31},{114,32},{114,33},{114,34},{114,35},{115,36},{115,37},{115,38},{115,39},{115,40},{115,41},{115,42},{115,43},{115,44},{115,45},
    {115,50},{115,51},{115,52},{116,53},{116,54},{116,55}
};
static const unsigned int HELLO_LENGTH = sizeof(HELLO) / sizeof(HELLO[0]);

static void slow_down(void)
{
    unsigned int i;
    for (i = 0; i < delay_cycles; ++i)
    {
        asm("nop");   // an assembly thing: NOP ("No Operation")
    }
}

static void scene_writing_hello(void)
{
    int i;

    tgi_clear();
    while (tgi_busy()) {}

    tgi_setcolor(draw_color);

    // Draw each pixel in order
    for (i = 0; i < (int)HELLO_LENGTH; ++i)
    {
        int x = (int)HELLO[i][0] - 1;
        int y = (int)HELLO[i][1] - 1;

        // clamp to screen
        if (x < 0) x = 0; else if (x >= screen_w) x = screen_w - 1;
        if (y < 0) y = 0; else if (y >= screen_y) y = screen_y - 1;

        tgi_setpixel(x, y);

        while (tgi_busy()) {}
        slow_down();
    }

    // leave greet for 1 sec
    wait_seconds(1);
}

///////// PART 2: THE MAN (and prologue/writing) /////////

// colors used
#define BG_COLOR    16
#define SIL_COLOR   7
#define HAIR_COLOR  9
#define TEXT_COLOR  12   

// drawing pixel bounds for the guy
#define HEAD_LEFT    48
#define HEAD_RIGHT   112
#define HEAD_TOP     34
#define HEAD_BOTTOM  78

#define NECK_LEFT    68
#define NECK_RIGHT   92
#define NECK_TOP     HEAD_BOTTOM
#define NECK_BOTTOM  (NECK_TOP + 10)

#define BODY_LEFT    30
#define BODY_RIGHT   130
#define BODY_TOP     NECK_BOTTOM
#define BODY_BOTTOM  150   // clips off-screen/>102

// hair bounds
#define HAIR_LEFT    HEAD_LEFT
#define HAIR_RIGHT   HEAD_RIGHT
#define HAIR_TOP     (HEAD_TOP + 2)
#define HAIR_BOTTOM  (HEAD_BOTTOM - 3)
#define HAIR_SOLID_BOTTOM  (HEAD_TOP + ((HEAD_BOTTOM - HEAD_TOP) / 2))

#define HAIR_PAIR_STEP  3
#define HAIR_TRIM       4

static void draw_man_silhouette(void)
{
    int x;
    int y0_long, y1_long, y0_short, y1_short;

    // background
    tgi_setbgcolor(BG_COLOR);
    tgi_clear();

    // guy
    tgi_setcolor(SIL_COLOR);
    tgi_bar(HEAD_LEFT, HEAD_TOP, HEAD_RIGHT, HEAD_BOTTOM);       // head 
    tgi_bar(NECK_LEFT, NECK_TOP, NECK_RIGHT, NECK_BOTTOM);       // neck 
    tgi_bar(BODY_LEFT, BODY_TOP, BODY_RIGHT, BODY_BOTTOM);       // body 

    // solid hair on the top half of head 
    tgi_setcolor(HAIR_COLOR);
    tgi_bar(HEAD_LEFT, HEAD_TOP, HEAD_RIGHT, HAIR_SOLID_BOTTOM);

    // striky hair on the bottom half
    tgi_setcolor(HAIR_COLOR);
    for (x = HAIR_LEFT; x <= HAIR_RIGHT; x += HAIR_PAIR_STEP)
    {
        y0_long = HAIR_SOLID_BOTTOM + 1;
        y1_long = HAIR_BOTTOM;
        y0_short = y0_long + HAIR_TRIM;
        y1_short = y1_long - HAIR_TRIM;

        // long strokes
        tgi_line(x, y0_long, x, y1_long);

        // short strokes in between
        if (x + 1 <= HAIR_RIGHT)
        {
            tgi_line(x + 1, y0_short, x + 1, y1_short);
        }
    }
}

#if 0  // UNUSED
// clear only the text above the head 
static void clear_text_band(void)
{
    int top = 0;
    int bottom = HEAD_TOP - 1;   // define above head 

    if (bottom < 0) bottom = 0;

    tgi_setcolor(BG_COLOR);
    tgi_bar(0, top, SCREEN_WIDTH - 1, bottom);
}
#endif

// show one sentence at a time centered above the head, then hold it
//static void show_sentence(const char* text, unsigned char hold_seconds)
//{
//    int text_width;
//    int x, y;
//
//    clear_text_band();
//
//    tgi_setcolor(TEXT_COLOR);
//    text_width = tgi_gettextwidth(text);
//
//    if (text_width < SCREEN_WIDTH)
//        x = (SCREEN_WIDTH - text_width) / 2;
//    else
//        x = 0;
//
//    // placing it 10 above head 
//    y = HEAD_TOP - 10;
//    if (y < 0) y = 0;
//
//    tgi_outtextxy(x, y, text);
//
//    tgi_updatedisplay();
//    wait_seconds(hold_seconds);
//}

static void show_sentence(const char* line1, const char* line2,
    unsigned char hold_seconds)
{
    int w1, w2;
    int x1, x2;
    int height;
    int y0;

    // redraw man each full frame
    draw_man_silhouette();

    tgi_setcolor(TEXT_COLOR);

    // get text height for spacing 
    height = tgi_gettextheight("A");
    if (height <= 0) height = 10;// above doesnt work lol

    // anchor top line to make sure all text is above the head
    // y0 = HEAD_TOP - (2 * height) - 2;
    y0 = 6; // first line close to the top of screen
    // if (y0 < 0) y0 = 0;
    if (y0 + (2 * height) + 2 >= HEAD_TOP) // since the font is somehow huge, clamp so both lines are still above the head
    {
        y0 = HEAD_TOP - (2 * height) - 2;
        if (y0 < 0) y0 = 0;
    }

    // 1st line centered 
    w1 = tgi_gettextwidth(line1);
    x1 = (w1 < SCREEN_WIDTH) ? (SCREEN_WIDTH - w1) / 2 : 0;
    tgi_outtextxy(x1, y0, line1);

    // 2nd line centered under the 1st
    w2 = tgi_gettextwidth(line2);
    x2 = (w2 < SCREEN_WIDTH) ? (SCREEN_WIDTH - w2) / 2 : 0;
    tgi_outtextxy(x2, y0 + height + 1, line2);

    tgi_updatedisplay();
    wait_seconds(hold_seconds);
}

// full screen centered text for credits 
static void show_sentence_center(const char* line1, const char* line2,
    unsigned char hold_seconds)
{
    int w1, w2;
    int x1, x2;
    int height;
    int y0;

    tgi_setbgcolor(0);
    tgi_clear();
    while (tgi_busy()) {}

    tgi_setcolor(TEXT_COLOR);

    // height = tgi_gettextheight("A");
    if (height <= 0) height = 10;

    w1 = tgi_gettextwidth(line1);
    w2 = tgi_gettextwidth(line2);

    x1 = (w1 < SCREEN_WIDTH) ? (SCREEN_WIDTH - w1) / 2 : 0;
    x2 = (w2 < SCREEN_WIDTH) ? (SCREEN_WIDTH - w2) / 2 : 0;
    y0 = (SCREEN_HEIGHT - (2 * height + 1)) / 2;
    if (y0 < 0) y0 = 0;

    tgi_outtextxy(x1, y0, line1);
    tgi_outtextxy(x2, y0 + height + 1, line2);

    tgi_updatedisplay();
    wait_seconds(hold_seconds);
}


static void scene_man_with_text(void)
{
    // draw man once
    draw_man_silhouette();
    tgi_updatedisplay();

    // tiny pause before text starts
    wait_seconds(1);

    // sentences and their timing
    show_sentence("I am in this", "dream again,", 2);
    // show_sentence("I have had it", "countless times.", 3);
    show_sentence("I must go to", "the house.", 3);
    // show_sentence("There is no other", "place like it.", 3);
    show_sentence("The silent,", "crystalline", 2);
    show_sentence("palace of", "my mind.", 2);
    // show_sentence("Endless and", "without any exit,", 2);
    show_sentence("Where my memories,",
        "puny as they are,", 2);
    show_sentence("an allegory",
        " of waste,", 2);
    show_sentence("sealed in",
        " stillness.", 3);
}

///////// PART FIN: EXPANDING COLOR CIRCLES /////////

#define CIRCLE_MAX_RADIUS  100

static void scene_expanding_circles(unsigned char seconds)
{
    int cx = SCREEN_WIDTH / 2;
    int cy = SCREEN_HEIGHT / 2;
    unsigned char color = 1;
    unsigned char baseColor = 1;
    int radius;
    unsigned long frames = 0;
    unsigned long maxFrames = (unsigned long)seconds * 10UL; // 40 anim frames per sec

    tgi_setbgcolor(0);
    tgi_clear();
    while (tgi_busy()) {}
    tgi_updatedisplay();

    // draw looping expanding circle background with different / looping colors
    while (frames < maxFrames)
    {
        for (radius = 2; radius <= CIRCLE_MAX_RADIUS && frames < maxFrames; radius += 2)
        {
            int r;
            unsigned char col = baseColor;

            // redraw each step every frame to prevent flicker
            tgi_setbgcolor(0);
            tgi_clear();
            while (tgi_busy()) {}

            // draw all circles from small to current radius
            for (r = 2; r <= radius; r += 2)
            {
                tgi_setcolor(col);
                tgi_circle(cx, cy, r);

                // loop colors
                ++col;
                if (col > 16)
                    col = 1;
            }

            tgi_updatedisplay();
            small_delay();

            // rotate starting color so pattern changes over time
            ++baseColor;
            if (baseColor > 16)
                baseColor = 1;

            ++frames;
        }
    }
}

///////// PART 3 WALK TO HOUSE SEQUENCE /////////

/// color / palette config
#define COL_BG          4   // background
#define COL_ROAD        0   // road 
#define COL_STRIPE      1   // road stripe 
#define COL_MAN_BODY    7   // guy
#define COL_MAN_HEAD    9   // huy head / yellow-ish hair
#define COL_HOUSE       8   // red house
#define COL_WINDOW_FRAME 2  // frame around windows 
#define COL_WINDOW_GLASS 0  // inside of windows 
#define COL_RAIN_COL1   10
#define COL_RAIN_COL2   11
#define COL_RAIN_COL3   12
#define COL_RAIN_COL4   13
#define COL_RAIN_COL5   14

// road geometry (centred)
#define ROAD_WIDTH      32
#define ROAD_LEFT       ((SCREEN_WIDTH - ROAD_WIDTH) / 2)
#define ROAD_RIGHT      (ROAD_LEFT + ROAD_WIDTH - 1)

// road stripes 
#define STRIPE_SPACING  10
#define STRIPE_THICK    1

// man geometry 
#define MAN_HEAD_W      8
#define MAN_HEAD_H      8
#define MAN_NECK_W      4
#define MAN_NECK_H      2
#define MAN_BODY_W      6
#define MAN_BODY_H      12
#define MAN_SHOULDER_W  12
#define MAN_SHOULDER_H  2
#define MAN_ARM_W       2
#define MAN_ARM_H       10
#define MAN_LEG_W       2
#define MAN_LEG_H_IDLE  10
#define MAN_LEG_DELTA   2   // how much shorter the forward leg is 
#define MAN_FOOT_H      2
#define MAN_HAND_H      2

// house geometry 
#define HOUSE_W         120
#define HOUSE_H         56
#define HOUSE_LEFT      ((SCREEN_WIDTH - HOUSE_W) / 2)
#define HOUSE_RIGHT     (HOUSE_LEFT + HOUSE_W - 1)

// final position of house top once fully on-screen
#define HOUSE_FINAL_TOP 0

// door geometry (aligned with road)
#define DOOR_W          ROAD_WIDTH
#define DOOR_LEFT       ROAD_LEFT
#define DOOR_RIGHT      ROAD_RIGHT

// windows inside house 
#define WINDOW_W        24
#define WINDOW_H        18
#define WINDOW_MARGIN_X 12
#define WINDOW_MARGIN_Y 8

// man huy animation frames 
typedef enum
{
    MAN_FRAME_IDLE = 0,
    MAN_FRAME_LEFT_FWD = 1,
    MAN_FRAME_RIGHT_FWD = 2
} ManFrame;

// rain for the walk scene 
#define WALK_RAIN_COUNT  40

typedef struct
{
    int x;
    int y;
    unsigned char color;
} WalkRainDrop;

static WalkRainDrop walkRain[WALK_RAIN_COUNT];

// walk-scene rain: init & update & draw

static unsigned char random_rain_color(void)
{
    switch (rand() % 5)
    {
    default:
    case 0: return COL_RAIN_COL1;
    case 1: return COL_RAIN_COL2;
    case 2: return COL_RAIN_COL3;
    case 3: return COL_RAIN_COL4;
    case 4: return COL_RAIN_COL5;
    }
}

static void init_walk_rain(void)
{
    int i;
    for (i = 0; i < WALK_RAIN_COUNT; ++i)
    {
        int side = rand() & 1;
        int x;

        if (side == 0)
        {
            // left side region
            x = rand() % ROAD_LEFT;
        }
        else
        {
            // right side region
            x = ROAD_RIGHT + 1 + (rand() % (SCREEN_WIDTH - ROAD_RIGHT - 1));
        }

        walkRain[i].x = x;
        walkRain[i].y = rand() % SCREEN_HEIGHT;
        walkRain[i].color = random_rain_color();
    }
}

static void update_walk_rain(void)
{
    int i;
    for (i = 0; i < WALK_RAIN_COUNT; ++i)
    {
        walkRain[i].y += 2;
        if (walkRain[i].y >= SCREEN_HEIGHT)
        {
            int side = rand() & 1;
            int x;

            if (side == 0)
            {
                x = rand() % ROAD_LEFT;
            }
            else
            {
                x = ROAD_RIGHT + 1 + (rand() % (SCREEN_WIDTH - ROAD_RIGHT - 1));
            }

            walkRain[i].y = 0;
            walkRain[i].x = x;
            walkRain[i].color = random_rain_color();
        }
    }
}

static void draw_walk_rain(void)
{
    int i;
    for (i = 0; i < WALK_RAIN_COUNT; ++i)
    {
        tgi_setcolor(walkRain[i].color);
        tgi_line(walkRain[i].x, walkRain[i].y - 3,
            walkRain[i].x, walkRain[i].y);
    }
}

/// Draw the guy at (centreX, footY) for a frame
static void draw_man(int centreX, int footY, ManFrame frame)
{
    int legLeftHeight;
    int legRightHeight;

    // legs (relative to hip)
    int hipTop;
    int legLeftTop;
    int legRightTop;
    int legLeftBottom;
    int legRightBottom;

    // feet (per leg)
    int footTopLeft;
    int footBottomLeft;
    int footTopRight;
    int footBottomRight;

    // body sits on top of legs
    int bodyBottom;
    int bodyTop;

    // shoulders
    int shoulderTop;
    int shoulderBottom;

    // arms
    int armTop;
    int armBottom;

    // neck
    int neckBottom;
    int neckTop;

    // head
    int headBottom;
    int headTop;

    int bodyLeft;
    int bodyRight;

    int shoulderLeft;
    int shoulderRight;

    int neckLeft;
    int neckRight;

    int headLeft;
    int headRight;

    int legGap;
    int legLeftX;
    int legRightX;

    int footLeftLeft;
    int footLeftRight;
    int footRightLeft;
    int footRightRight;

    int armLeftX;
    int armRightX;

    // walk frames: foot "lift" at the bottom on each side
    legLeftHeight = MAN_LEG_H_IDLE;
    legRightHeight = MAN_LEG_H_IDLE;

    if (frame == MAN_FRAME_LEFT_FWD)
        legLeftHeight = MAN_LEG_H_IDLE - MAN_LEG_DELTA;
    else if (frame == MAN_FRAME_RIGHT_FWD)
        legRightHeight = MAN_LEG_H_IDLE - MAN_LEG_DELTA;

    // doing the vertical stack by calculation / parts relative to each other

    // hip anchor so both legs start at the same place
    hipTop = footY - MAN_FOOT_H - MAN_LEG_H_IDLE + 1;

    // legs (downward from hip)
    legLeftTop = hipTop;
    legRightTop = hipTop;
    legLeftBottom = hipTop + legLeftHeight - 1;
    legRightBottom = hipTop + legRightHeight - 1;

    // feet follow each leg bottom, so the shorter leg lifts its foot
    footTopLeft = legLeftBottom + 1;
    footBottomLeft = footTopLeft + MAN_FOOT_H - 1;
    footTopRight = legRightBottom + 1;
    footBottomRight = footTopRight + MAN_FOOT_H - 1;

    // body sits on top of the hips
    bodyBottom = hipTop - 1;
    bodyTop = bodyBottom - MAN_BODY_H + 1;

    // shoulders above body 
    shoulderTop = bodyTop - MAN_SHOULDER_H;
    shoulderBottom = shoulderTop + MAN_SHOULDER_H - 1;

    // arms 
    armTop = shoulderBottom + 1;
    armBottom = armTop + MAN_ARM_H - 1;

    // neck above shoulders 
    neckBottom = shoulderTop - 1;
    neckTop = neckBottom - MAN_NECK_H + 1;

    // head above neck 
    headBottom = neckTop - 1;
    headTop = headBottom - MAN_HEAD_H + 1;

    bodyLeft = centreX - MAN_BODY_W / 2;
    bodyRight = bodyLeft + MAN_BODY_W - 1;

    shoulderLeft = centreX - MAN_SHOULDER_W / 2;
    shoulderRight = shoulderLeft + MAN_SHOULDER_W - 1;

    neckLeft = centreX - MAN_NECK_W / 2;
    neckRight = neckLeft + MAN_NECK_W - 1;

    headLeft = centreX - MAN_HEAD_W / 2;
    headRight = headLeft + MAN_HEAD_W - 1;

    legGap = 2;
    legLeftX = centreX - MAN_LEG_W - legGap / 2;
    legRightX = centreX + legGap / 2;

    footLeftLeft = legLeftX - 1;
    footLeftRight = footLeftLeft + 3;
    footRightLeft = legRightX - 1;
    footRightRight = footRightLeft + 3;

    armLeftX = shoulderLeft;
    armRightX = shoulderRight - MAN_ARM_W + 1;

    /// drawing the guy's body parts

    // legs 
    tgi_setcolor(COL_MAN_BODY);
    tgi_bar(legLeftX, legLeftTop, legLeftX + MAN_LEG_W - 1, legLeftBottom);
    tgi_bar(legRightX, legRightTop, legRightX + MAN_LEG_W - 1, legRightBottom);

    // feet (each leg uses its own height now)
    tgi_bar(footLeftLeft, footTopLeft, footLeftRight, footBottomLeft);
    tgi_bar(footRightLeft, footTopRight, footRightRight, footBottomRight);

    // body 
    tgi_bar(bodyLeft, bodyTop, bodyRight, bodyBottom);

    // shoulders 
    tgi_bar(shoulderLeft, shoulderTop, shoulderRight, shoulderBottom);

    // arms 
    tgi_bar(armLeftX, armTop, armLeftX + MAN_ARM_W - 1, armBottom);
    tgi_bar(armRightX, armTop, armRightX + MAN_ARM_W - 1, armBottom);

    // neck 
    tgi_bar(neckLeft, neckTop, neckRight, neckBottom);

    // head 
    tgi_setcolor(COL_MAN_HEAD);
    tgi_bar(headLeft, headTop, headRight, headBottom);
}

/// Drawing the house
static void draw_house(int houseTop)
{
    int houseBottom;
    int drawTop;
    int drawBottom;
    int doorTopFull;
    int doorBottomFull;
    int doorTop;
    int doorBottom;

    int winTopFull;
    int winBottomFull;
    int winTop;
    int winBottom;
    int leftWinLeft;
    int leftWinRight;
    int rightWinRight;
    int rightWinLeft;

    houseBottom = houseTop + HOUSE_H - 1;

    if (houseBottom < 0 || houseTop >= SCREEN_HEIGHT)
        return; // starts fully off screen

    // clips vertically only for what actually shows
    drawTop = houseTop;
    if (drawTop < 0) drawTop = 0;
    drawBottom = houseBottom;
    if (drawBottom >= SCREEN_HEIGHT) drawBottom = SCREEN_HEIGHT - 1;

    tgi_setcolor(COL_HOUSE);
    tgi_bar(HOUSE_LEFT, drawTop, HOUSE_RIGHT, drawBottom);

    // door starts bit below the top of house 
    doorTopFull = houseTop + (HOUSE_H / 4);
    doorBottomFull = houseBottom;

    if (doorBottomFull >= 0 && doorTopFull < SCREEN_HEIGHT)
    {
        doorTop = doorTopFull;
        if (doorTop < 0) doorTop = 0;
        doorBottom = doorBottomFull;
        if (doorBottom >= SCREEN_HEIGHT) doorBottom = SCREEN_HEIGHT - 1;

        tgi_setcolor(COL_ROAD); // black road
        tgi_bar(DOOR_LEFT, doorTop, DOOR_RIGHT, doorBottom);
    }

    // drawing the windows
    {
        winTopFull = houseTop + WINDOW_MARGIN_Y;
        winBottomFull = winTopFull + WINDOW_H - 1;
        leftWinLeft = HOUSE_LEFT + WINDOW_MARGIN_X;
        leftWinRight = leftWinLeft + WINDOW_W - 1;
        rightWinRight = HOUSE_RIGHT - WINDOW_MARGIN_X;
        rightWinLeft = rightWinRight - WINDOW_W + 1;

        if (winBottomFull >= 0 && winTopFull < SCREEN_HEIGHT)
        {
            winTop = winTopFull;
            if (winTop < 0) winTop = 0;
            winBottom = winBottomFull;
            if (winBottom >= SCREEN_HEIGHT) winBottom = SCREEN_HEIGHT - 1;

            tgi_setcolor(COL_WINDOW_GLASS);
            tgi_bar(leftWinLeft, winTop, leftWinRight, winBottom);
            tgi_bar(rightWinLeft, winTop, rightWinRight, winBottom);

            // window:
            tgi_setcolor(COL_WINDOW_FRAME);
            // borders 
            // left window border using 1px bars
            tgi_bar(leftWinLeft, winTop, leftWinRight, winTop);      // top
            tgi_bar(leftWinLeft, winBottom, leftWinRight, winBottom);   // bottom
            tgi_bar(leftWinLeft, winTop, leftWinLeft, winBottom);   // left
            tgi_bar(leftWinRight, winTop, leftWinRight, winBottom);   // right

            // right window border using 1px bars
            tgi_bar(rightWinLeft, winTop, rightWinRight, winTop);    // top
            tgi_bar(rightWinLeft, winBottom, rightWinRight, winBottom); // bottom
            tgi_bar(rightWinLeft, winTop, rightWinLeft, winBottom); // left
            tgi_bar(rightWinRight, winTop, rightWinRight, winBottom); // right

            // crosses 
            tgi_line((leftWinLeft + leftWinRight) / 2, winTop,
                (leftWinLeft + leftWinRight) / 2, winBottom);
            tgi_line(leftWinLeft, (winTop + winBottom) / 2,
                leftWinRight, (winTop + winBottom) / 2);

            tgi_line((rightWinLeft + rightWinRight) / 2, winTop,
                (rightWinLeft + rightWinRight) / 2, winBottom);
            tgi_line(rightWinLeft, (winTop + winBottom) / 2,
                rightWinRight, (winTop + winBottom) / 2);
        }
    }
}
/// Draws 1 frame of the walk scene

static void draw_walk_scene(int manCentreX,
    int manFootY,
    ManFrame manFrame,
    int stripeOffset,
    int houseTop,
    unsigned char houseVisible)
{
    int y;

    // clear background to grey
    tgi_setbgcolor(COL_BG);
    tgi_clear();
    while (tgi_busy()) {}

    // rain in the background 
    update_walk_rain();
    draw_walk_rain();

    // road (on top of rain)
    tgi_setcolor(COL_ROAD);
    tgi_bar(ROAD_LEFT, 0, ROAD_RIGHT, SCREEN_HEIGHT - 1);

    // road stripes
    tgi_setcolor(COL_STRIPE);
    for (y = stripeOffset; y < SCREEN_HEIGHT; y += STRIPE_SPACING)
    {
        int y2 = y + STRIPE_THICK - 1;
        if (y2 >= SCREEN_HEIGHT) y2 = SCREEN_HEIGHT - 1;
        tgi_bar(ROAD_LEFT + 4, y, ROAD_RIGHT - 4, y2); // inset a bit from edge
    }

    // house if visible
    if (houseVisible)
    {
        draw_house(houseTop);
    }

    // man in front of road & house
    draw_man(manCentreX, manFootY, manFrame);
}


static void run_walk_to_house_scene(void);

// raycaster scene function declaration
static void run_raycaster_scene(void);

////////// RAYCASTER SECTION////////////

#define MAP_WIDTH   8
#define MAP_HEIGHT  9

#define ANGLE_MASK 63
#define ANGLE_90   16   // +y 
#define ANGLE_180  32   // -x 
#define ANGLE_270  48   // -y 

// fixed-point helpers
#define FIXED_SHIFT 8
#define FIXED_ONE   (1 << FIXED_SHIFT)
#define INT_TO_FIXED(x) ((x) << FIXED_SHIFT)
#define FIXED_TO_INT(x) ((x) >> FIXED_SHIFT)
#define FIXED_HALF  (FIXED_ONE >> 1)
#define TILE_CENTER_FIXED(t) (INT_TO_FIXED(t) + FIXED_HALF)

static unsigned char worldMap[MAP_HEIGHT][MAP_WIDTH] = {
    /*0 1 2 3 4 5 6 7 */
     {1,1,1,1,1,1,1,1}, /* 0 */
     {1,0,0,0,0,0,0,1}, /* 1 */
     {1,1,1,1,0,1,1,1}, /* 2 */
     {1,0,0,0,0,0,0,1}, /* 3 */
     {1,0,1,1,1,1,1,1}, /* 4 */
     {1,0,0,0,0,0,1,1}, /* 5 */
     {1,1,1,1,0,0,0,1}, /* 6 */
     {1,0,0,0,0,0,0,1}, /* 7 */
     {1,1,1,1,1,1,1,1}  /* 8 */
};

static int playerX;
static int playerY;
static unsigned char playerAngle = 0;

typedef struct Tile {
    unsigned char x;
    unsigned char y;
} Tile;

static const Tile PATH[] = {
    {1,7}, {2,7}, {3,7}, {4,7}, {4,6},
    {4,5}, {3,5}, {2,5}, {1,5}, {1,4},
    {1,3}, {2,3}, {3,3}, {4,3}, {4,2},
    {4,1}, {5,1}, {6,1},
};
#define PATH_LEN ((int)(sizeof(PATH)/sizeof(PATH[0])))

static const signed char sin_table[64] = {
    0, 6, 12, 18, 24, 30, 36, 42, 48, 53, 58, 63, 68, 72, 76, 79,
    82, 85, 87, 89, 90, 91, 91, 91, 90, 89, 87, 85, 82, 79, 76, 72,
    68, 63, 58, 53, 48, 42, 36, 30, 24, 18, 12, 6, 0, -6, -12, -18,
    -24, -30, -36, -42, -48, -53, -58, -63, -68, -72, -76, -79, -82, -85, -87, -89
};

static const signed char cos_table[64] = {
    90, 91, 91, 91, 90, 89, 87, 85, 82, 79, 76, 72, 68, 63, 58, 53,
    48, 42, 36, 30, 24, 18, 12, 6, 0, -6, -12, -18, -24, -30, -36, -42,
    -48, -53, -58, -63, -68, -72, -76, -79, -82, -85, -87, -89, -90, -91, -91, -91,
    -90, -89, -87, -85, -82, -79, -76, -72, -68, -63, -58, -53, -48, -42, -36, -30
};

#define FAST_SIN(a) sin_table[(a) & ANGLE_MASK]
#define FAST_COS(a) cos_table[(a) & ANGLE_MASK]

static const unsigned char wall_heights[13] = { 50,50,45,35,28,23,19,16,14,12,11,10,9 };
static const unsigned char distance_colors[13] = { 15,15,14,14,12,12,10,10,8,8,8,8,8 };

#define FAST_STEP_SIZE 120
#define FRAMES_PER_STEP 4

static int path_index = 0;
static int frames_into_step = 0;
static int step_dx_fixed = 0;
static int step_dy_fixed = 0;
static unsigned char movement_done = 0;

// rainy window defines
#define WIN_W  54
#define WIN_H  60
#define WIN_X  ((SCREEN_WIDTH  - WIN_W) / 2)
#define WIN_Y  ((SCREEN_HEIGHT - WIN_H) / 2)
#define WIN_RIGHT  (WIN_X + WIN_W - 1)
#define WIN_BOTTOM (WIN_Y + WIN_H - 1)
#define WIN_CX     (WIN_X + (WIN_W / 2))
#define WIN_CY     (WIN_Y + (WIN_H / 2))
#define SEAL_THICK 2
#define SEAL_COLOR 1
#define WINDOW_COLOR 5
#define RAIN_COLOR 12
#define NUM_RAIN   24
#define RAIN_HEIGHT 2
#define RAIN_SPEED  1
#define RAIN_MIN_X   (WIN_X + 1)
#define RAIN_MAX_X   (WIN_RIGHT - 1)
#define RAIN_MIN_Y   (WIN_Y + 1)
#define RAIN_MAX_Y   (WIN_BOTTOM - 1)

typedef struct {
    int x; int y; unsigned char color;
} RayRain;

static RayRain rayRain[NUM_RAIN];
static unsigned char window_active = 0;
static unsigned char window_inited = 0;

static unsigned char angle_for_step(int dx, int dy);
static void begin_step_from_to(const Tile* from, const Tile* to);
static void init_path_and_player(void);
static void update_auto_movement(void);
static void cast_smooth_rays(void);

static void draw_window_pane(void)
{
    tgi_setcolor(WINDOW_COLOR);
    tgi_bar(WIN_X, WIN_Y, WIN_RIGHT, WIN_BOTTOM);
}

static void draw_seals(void)
{
    tgi_setcolor(SEAL_COLOR);

    // window border
    tgi_bar(WIN_X, WIN_Y, WIN_RIGHT, WIN_Y + SEAL_THICK - 1);
    tgi_bar(WIN_X, WIN_BOTTOM - SEAL_THICK + 1, WIN_RIGHT, WIN_BOTTOM);
    tgi_bar(WIN_X, WIN_Y, WIN_X + SEAL_THICK - 1, WIN_BOTTOM);
    tgi_bar(WIN_RIGHT - SEAL_THICK + 1, WIN_Y, WIN_RIGHT, WIN_BOTTOM);

    // window's cross bars
    tgi_bar(WIN_X, WIN_CY - (SEAL_THICK / 2), WIN_RIGHT, WIN_CY + (SEAL_THICK / 2));
    tgi_bar(WIN_CX - (SEAL_THICK / 2), WIN_Y, WIN_CX + (SEAL_THICK / 2), WIN_BOTTOM);
}

static void init_ray_rain(void)
{
    int i;
    srand(1);
    for (i = 0; i < NUM_RAIN; ++i)
    {
        rayRain[i].x = RAIN_MIN_X + (rand() % (RAIN_MAX_X - RAIN_MIN_X + 1));
        rayRain[i].y = RAIN_MIN_Y + (rand() % (RAIN_MAX_Y - RAIN_MIN_Y + 1));
        rayRain[i].color = RAIN_COLOR;
    }
    window_inited = 1;
}

static void update_ray_rain(void)
{
    int i;
    for (i = 0; i < NUM_RAIN; ++i)
    {
        int x = rayRain[i].x;
        int y = rayRain[i].y;

        tgi_setcolor(rayRain[i].color);
        if (y < RAIN_MAX_Y)
        {
            tgi_bar(x, y, x, y + (RAIN_HEIGHT - 1));
        }
        else
        {
            tgi_setpixel(x, y);
        }

        rayRain[i].y += RAIN_SPEED;
        if (rayRain[i].y > RAIN_MAX_Y)
        {
            rayRain[i].y = RAIN_MIN_Y;
            rayRain[i].x = RAIN_MIN_X + (rand() % (RAIN_MAX_X - RAIN_MIN_X + 1));
        }
    }
}

static unsigned char angle_for_step(int dx, int dy)
{
    if (dx > 0 && dy == 0) return 0;          // +x
    if (dx < 0 && dy == 0) return ANGLE_180;  // -x
    if (dx == 0 && dy > 0) return ANGLE_90;   // +y
    if (dx == 0 && dy < 0) return ANGLE_270;  // -y
    return playerAngle;
}

static void begin_step_from_to(const Tile* from, const Tile* to)
{
    int fromX = TILE_CENTER_FIXED(from->x);
    int fromY = TILE_CENTER_FIXED(from->y);
    int toX = TILE_CENTER_FIXED(to->x);
    int toY = TILE_CENTER_FIXED(to->y);
    int dx_tiles = (int)to->x - (int)from->x;
    int dy_tiles = (int)to->y - (int)from->y;

    step_dx_fixed = (toX - fromX) / FRAMES_PER_STEP;
    step_dy_fixed = (toY - fromY) / FRAMES_PER_STEP;

    playerAngle = angle_for_step(dx_tiles, dy_tiles);
    frames_into_step = 0;
}

static void init_path_and_player(void)
{
    playerX = TILE_CENTER_FIXED(PATH[0].x);
    playerY = TILE_CENTER_FIXED(PATH[0].y);

    path_index = 0;
    frames_into_step = 0;


    movement_done = 0;
    begin_step_from_to(&PATH[0], &PATH[1]);

}

static void pause_with_window(unsigned char seconds)
{
    unsigned int frames;
    unsigned int i;

    if (!window_inited) init_ray_rain();

    // number of frames to pause
    frames = (unsigned int)seconds * 5;

    for (i = 0; i < frames; ++i)
    {
        // redraw scene at current player position
        cast_smooth_rays();

        // draw rainy window
        draw_window_pane();
        update_ray_rain();
        draw_seals();

        tgi_updatedisplay();
        small_delay();
    }
}

static void update_auto_movement(void)
{
    if (movement_done) return;

    playerX += step_dx_fixed;
    playerY += step_dy_fixed;
    frames_into_step++;

    if (frames_into_step >= FRAMES_PER_STEP)
    {
        path_index++;
        playerX = TILE_CENTER_FIXED(PATH[path_index].x);
        playerY = TILE_CENTER_FIXED(PATH[path_index].y);

        if (path_index >= PATH_LEN - 1)
        {
            movement_done = 1; // reached final tile
            // window_active = 1; // show window or painting now
        }
        else
        {
            begin_step_from_to(&PATH[path_index], &PATH[path_index + 1]);
        }
    }
}

// raycast renderer
static void cast_smooth_rays(void)
{
    int x, i;
    int rayX, rayY;
    int deltaX, deltaY;
    unsigned char distance;
    unsigned char wall_height;
    int draw_start, draw_end;
    unsigned char wall_color;
    unsigned char ray_angle;
    int center = SCREEN_HEIGHT >> 1;
    int mapX, mapY;

    for (x = 0; x < SCREEN_WIDTH; x++)
    {
        ray_angle = playerAngle + ((x - (SCREEN_WIDTH >> 4)) >> 4);
        ray_angle &= ANGLE_MASK;

        deltaX = FAST_COS(ray_angle);
        deltaY = FAST_SIN(ray_angle);

        rayX = playerX;
        rayY = playerY;
        distance = 0;

        for (i = 0; i < 10; i++)
        {
            rayX += (deltaX * FAST_STEP_SIZE) >> 6;
            rayY += (deltaY * FAST_STEP_SIZE) >> 6;
            distance++;

            mapX = FIXED_TO_INT(rayX);
            mapY = FIXED_TO_INT(rayY);

            if ((unsigned char)mapX >= MAP_WIDTH || (unsigned char)mapY >= MAP_HEIGHT)
            {
                break;
            }
            if (worldMap[mapY][mapX])
            {
                break;
            }
        }

        if (distance > 12) distance = 12;

        wall_height = wall_heights[distance];
        wall_height = (wall_height * 3) >> 2;

        draw_start = center - wall_height;
        draw_end = center + wall_height;

        if (draw_start < 0) draw_start = 0;
        if (draw_end >= SCREEN_HEIGHT) draw_end = SCREEN_HEIGHT - 1;

        wall_color = distance_colors[distance];

        if (draw_start > 0)
        {
            tgi_setcolor(1);
            tgi_line(x, 0, x, draw_start - 1);
        }
        if (draw_end > draw_start)
        {
            tgi_setcolor(wall_color);
            tgi_line(x, draw_start, x, draw_end);
        }
        if (draw_end < SCREEN_HEIGHT - 1)
        {
            tgi_setcolor(6);
            tgi_line(x, draw_end + 1, x, SCREEN_HEIGHT - 1);
        }
    }
}

// run the raycaster scene
static void run_raycaster_scene(void)
{
    int last_path_index = 0;

    init_path_and_player();

    // reset window flags
    window_active = 0;
    window_inited = 0;

    tgi_setbgcolor(0);
    tgi_clear();
    while (tgi_busy()) {}

    // walk the path tiles
    while (!movement_done)
    {
        update_auto_movement();
        cast_smooth_rays();
        tgi_updatedisplay();

        // detect when player just stepped onto a new tile 
        if (path_index != last_path_index)
        {
            last_path_index = path_index;

            // every 3rd tile pause at a rainy window 
            if ((path_index % 4) == 0 && path_index < PATH_LEN - 1)
            {
                pause_with_window(1);   // look at window for ~2 sec
            }
        }
    }

    // reached final tile: show paiting
    tgi_setbgcolor(0);
    tgi_clear();
    while (tgi_busy()) {}
    tgi_updatedisplay();

    // dok's full-screen raytracer painting
    drawRaytrace();
    tgi_updatedisplay();      // in case lib doesn't do it itself
    wait_seconds(3);          // show raytracer for 8 seconds

    //// then: clear screen and show closing sentence
    //tgi_setbgcolor(0);
    //tgi_clear();
    //while (tgi_busy()) {}
    //tgi_updatedisplay();

    //show_sentence_center("finally, from there,", "I slipped into", 2);
    //show_sentence_center("a deeper,", "more abstract sleep.", 2);

    //// expanding circles for about 16 seconds
    //scene_expanding_circles();

    //// final thank you & credits scene
    //tgi_setbgcolor(0);
    //tgi_clear();
    //while (tgi_busy()) {}
    //tgi_updatedisplay();

    //show_sentence_center("Thanks everyone!", "we are Beige :)", 5);

    //// hold final frame 
    //for (;;)
    //{
    //}
}

static void run_ending_scene(void)
{
    tgi_setbgcolor(0);
    tgi_clear();
    while (tgi_busy()) {}
    tgi_updatedisplay();

    show_sentence_center("Thanks everyone!", "we are Beige :)", 5);

    // hold final frame 
    for (;;)
    {
    }
}

// run the walking to house

static void run_walk_to_house_scene(void)
{
    int manCentreX = SCREEN_WIDTH / 2;
    int manFootY = SCREEN_HEIGHT - 2;
    int targetFootY = SCREEN_HEIGHT / 2 + 12;

    int stripeOffset = 0;
    int houseTop = -HOUSE_H;
    unsigned char houseVisible = 0;

    int step;
    unsigned char toggle = 0;

    srand(2); // using a different seed of rain than raycaster's window rain
    init_walk_rain();

    // PHASE A: walk the guy up from bottom to centre 
    while (manFootY > targetFootY)
    {
        ManFrame frame = toggle ? MAN_FRAME_LEFT_FWD : MAN_FRAME_RIGHT_FWD;

        draw_walk_scene(manCentreX, manFootY, frame,
            stripeOffset, houseTop, houseVisible);
        tgi_updatedisplay();
        small_delay();    // 1sec between leg swaps

        manFootY -= 4;
        if (manFootY < targetFootY) manFootY = targetFootY;

        toggle = !toggle;
    }

    // PHASE B: stand in centre, simulate walk by scrolling road (for about ~4s) 
    for (step = 0; step < 80; ++step)
    {
        ManFrame frame = (step / 1) & 1 ? MAN_FRAME_LEFT_FWD : MAN_FRAME_RIGHT_FWD;

        stripeOffset += 2;
        if (stripeOffset >= STRIPE_SPACING)
            stripeOffset -= STRIPE_SPACING;

        draw_walk_scene(manCentreX, manFootY, frame,
            stripeOffset, houseTop, houseVisible);
        tgi_updatedisplay();
        small_delay();
    }

    // PHASE C: house scrolls down from above
    houseVisible = 1;
    houseTop = -HOUSE_H;

    for (; houseTop < HOUSE_FINAL_TOP; ++houseTop)
    {
        ManFrame frame = ((houseTop & 4) != 0) ? MAN_FRAME_LEFT_FWD : MAN_FRAME_RIGHT_FWD;

        stripeOffset += 2;
        if (stripeOffset >= STRIPE_SPACING)
            stripeOffset -= STRIPE_SPACING;

        draw_walk_scene(manCentreX, manFootY, frame,
            stripeOffset, houseTop, houseVisible);
        tgi_updatedisplay();
        small_delay();
    }

    // idle in front of the door 
    draw_walk_scene(manCentreX, manFootY, MAN_FRAME_IDLE,
        stripeOffset, HOUSE_FINAL_TOP, houseVisible);
    tgi_updatedisplay();
    wait_seconds(2);

    // go inside / start raycast
    run_raycaster_scene();
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/// MAIN LOOP: SEQUENCES THE SCENES

void main(void)
{
    // tgi init
    tgi_install(tgi_static_stddrv);
    tgi_init();
    CLI(); // init interupts
    while (tgi_busy()) {}

    // PART 1 GREETS
    scene_writing_hello();

    // Blank for 3 sec
    tgi_setbgcolor(0);
    tgi_clear();
    while (tgi_busy()) {}
    tgi_updatedisplay();
    wait_seconds(1);

    // PART 2 MAN + SENTENCES
    scene_man_with_text();

    wait_seconds(1);
    tgi_setpalette(tgi_getdefpalette());

    // PART 3 WALK TO HOUSE
    run_walk_to_house_scene(); // this calls raycaster

    //  closing sentences
    show_sentence_center("finally, from there,", "I slipped into", 2);
    show_sentence_center("a deeper,", "softer sleep.", 2);

    // PART 4 EXPANDING CIRCLES
    scene_expanding_circles(3);
    tgi_clear();
    tgi_updatedisplay();

    // final thank you / credits scene
    run_ending_scene();

    // doesnt return for now
}