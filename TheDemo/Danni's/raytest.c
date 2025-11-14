#include <lynx.h>
#include <tgi.h>
#include <6502.h>

extern void drawRaytrace(void);

int main(void)
{
    tgi_install(tgi_static_stddrv);
    tgi_init();
    CLI();
    while (tgi_busy()) {}
    tgi_updatedisplay();
    drawRaytrace();

    for (;;) {}

    return 0;
}
