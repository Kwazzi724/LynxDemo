#include <stdlib.h>
#include <6502.h>
#include <lynx.h>
#include <tgi.h>
#include <conio.h>
#include <peekpoke.h>
#include <joystick.h>

extern char lynxtgi[];
extern char lynxjoy[];

extern char pal[];

typedef struct {
	unsigned char b0;
	unsigned char b1;
	unsigned char b2;
	void *next;
	void *bitmap;
	int posx, posy, sizex, sizey;
	char palette[8];
} sprite_t;

void show_screen()
{
	// Clear current screen
	tgi_clear();
	
	tgi_setcolor(COLOR_WHITE);
	tgi_outtextxy(60, 48, "Ready!");

	tgi_updatedisplay();
}

void initialize()
{
	tgi_install(&lynxtgi);
	joy_install(&lynxjoy);
	tgi_init();
	CLI();
	
	while (tgi_busy()) 
	{ 
	};

	tgi_setbgcolor(COLOR_BLACK); 
	tgi_setpalette(tgi_getdefpalette());
	
	tgi_setcolor(COLOR_BLACK);
	tgi_clear();
}

void main(void) 
{
	unsigned char joy;
	unsigned char waitForRelease = 0;
	
	initialize();

	while (1)
	{
		if (kbhit()) 
		{
			switch (cgetc()) 
			{
				case 'F':
					tgi_flip();
					break;

				default:
					break;
			}
		}

		joy = joy_read(JOY_1);
		if (!joy) waitForRelease = 0;
		if (waitForRelease != 0) continue;

		if (JOY_BTN_RIGHT(joy))
		{
			waitForRelease = 1;
		}

		if (JOY_BTN_LEFT(joy))
		{
			waitForRelease = 1;
		}

		if (!tgi_busy())
		{
			show_screen();
		}
	};
}