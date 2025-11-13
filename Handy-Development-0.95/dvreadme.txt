         HandyBug V0.90 - Atari Lynx Emulator for Windows 95/NT/XP
         ---------------------------------------------------------
	 By K.Wilkins (dysfunction [at] users.sourceforge.net)
	 http://handy.sourceforge.net

       <-------------------HANDY HOMEPAGE-------------------->
                      http://handy.sourceforge.net
       <----------------------------------------------------->

This readme only relates to features specific to the development version.

*************************************************************************

** NEW **
** NEW **
** NEW **

V0.90 Highlights (14/06/2002)
-----------------------------
* ZIP file support added
* LSS snapshots no longer contain Cart/Rom data (LSS3 format)
* Backwards compatibility with LSS2 added
* Rendering subsystem rewritten & VBL/HBL timing fixed (Hi-Colour demos)
* Fixed bug whereby Window could be restored in an offscreen position
* Added RAM dump function to the debug menu
* Debug version now supports register & memory editing
* All debugger code moved out of CLynxWindow into CDebugger object
* Handy no longer crashes when a 2nd cart is loaded during a debug session

There are now some nice new debugging features inside Handy:

1. Debug Messages.
You can get your code to output debug messages that can be left inside
your normal cartridge code. Handy will detect a special instruction
sequence and when this is detected you can either generate a breakpoint
and halt or send a text message to the debugger. Just add the following
to your code:

CPX $5aa5   (ec a5 5a)	Generate a breakpoint
CPX $0000   (ec 00 00)

CPX $5aa5   (ec a5 5a)	Generate a register dump
CPX $0000   (ec ff ff)

or

CPX $5aa5   (ec a5 5a)  Print out the zero terminated text message found
CPX $xxxx   (ec xx xx)  at Ram address $xxxx to the debugger window or file

Debug messages from these commands will be displayed in the debug monitor
window, and can be cut/paste.



*************************************************************************

Index
-----

1.0      Installation

2.0      Using HandyBug

3.0      Handy Cartridge format

4.0      Handy Special register

5.0      Handy screendump format (RAW)



1.0 Installation
----------------

Unpack all of the files into the directory of your choice.

md c:\emu\handy
cd c:\emu\handy
pkunzip hndevXXX.zip
del hndevXXX.zip


   1.2 System Requirements
   -----------------------

* PC running WindowsNT or Windows95.
* 16MB or more system memory.
* Pentium class processor or better.
* Minimum 1MB Hard Disk space + whatever images you require.

This program performs best under 65536(16bit) colour mode, but also works in
256 colour mode. It will NOT work in 16 colour mode or less.



2.0 Using Handy
---------------

*****************************************************************************

BIG NOTE: Some of the optimisations have slightly broken breakpoint support.
          Breakpoints will not not trigger correctly within IRQ functions
          when sprites are being drawn due to some recursion when the sprite
          engine is called.
          If you place a breakpoint in an IRQ function and it triggers during
          sprite painting the breakpoint will be held off until the sprite
          painting is finished.

*****************************************************************************

HANDYBUG.EXE	- Lynx emulator with internal debugger (Slower)

Do not run HandyBug if you want to play games, its far too slow with all of
the debugging features enables.

Just click on the HandyBug icon and away you go. Select your file from the
browser as normal.

The keys are mapped to:

Reset Lynx	: F3
Run/Pause	: F5
Option 1 	: 1
Option 2 	: 2
Pause		: Q
Inside Fire	: Z
Outside Fire	: X
Joypad		: Arrow keys
Exit		: Alt-F4
Sound on/off	: Ctrl-S
Load cart	: Ctrl-0
BMP Snapshot	: Ctrl-Alt-B
RAW Snapshot	: Ctrl-Alt-R

Debug Operation
---------------
On the debug menu you will find:

Debugger Window - Opens a command line debugger window, type HELP.
Trace Window    - Opens a window with CPU & Emulator status
Dump Window     - Opens a memory window onto the cart or system memory
Code Window     - Opens a disassembler window onto the cart or system memory
Graphics Window - Opens a window that gives a graphical display of memory

Debug keys:

F3  - Reset Lynx
F5  - Run/Pause emulator
F9  - Window update toggle
F11 - Single step emulator

Handy will now save all window positions and status to the registry on exit
so you dont have to mess around every time you startup.


Code/Dump Windows
-----------------
UP/DOWN    - Move up/down in the window
LEFT/RIGHT - Byte positioning of the window
PGUP/DOWN  - Jump scroll by a window up/down

Doing a right mouse click in these windows will bring up a context menu to
allow the address/mode to be set as you wish. If you double click on an
instruction in the Code window a breakpoint will be set at that address,
double click again to remove it. (Note there is only 1 breakpoint). Emulator
will pause when breakpoint is encountered, regardless of if any debug windows
are open.

Hitting the delete button when in the dump window will generate a hex dump
text file for the whole of memory in the cartridge directory called dump.txt.
If you hit delete in the code window it will dump a disassembly of the whole
of memory into the cartridge directory called code.txt

If you double click on a code line then a breakpoint will be added, a total
of 8 breakpoints are allowed and can be viewed in the trace window. Double
click on the line a second time to remove the breakpoint.


Graphics Window
---------------
This window shows a graphical view of memory, you can use the context menu
to zoom the window to x2 which makes things easy to see.


Trace Window
------------
This has had a massive upgrade for V0.70, you can now click radio buttons etc
to toggle run/step modes. You can also toggle the debug window update rates:

Window Updates
    Normal - Windows only update on halt/breakpoint or scroll button
	Frame  - Windows will all update during the Lynx VBL
	Cycle  - Windows will all update every CPU cycle (v.slow)

Sprite Debug single step will bring up a dialog box on every sprite draw
giving the sprite number in the SCB chain, press continue for the next
sprite. Results are best viewed with the graphics window as you can see
the frame being built up in memory.



4.0 Handy Cartridge format
--------------------------

Handy V0.6 supports the new .LSS (Lynx SnapShots) format for save/load game
at any point. This format is too complicated to describe as it is basically
a context dump of every object within the Lynx.

Handy reads .LNX formats files, any will not read raw cartridge images. Any
LNX file MUST have the following format before it will be loaded by Handy:

typedef struct
{
   UBYTE   magic[4];
   UWORD   page_size_bank0;
   UWORD   page_size_bank1;
   UWORD   version;
   UBYTE   cartname[32];
   UBYTE   manufname[16];
   UBYTE   rotate;
   UBYTE   spare[5];
   UBYTE   bank0data[256*page_size_bank0];
   UBYTE   bank1data[256*page_size_bank1];
}LYNX_CART;

Magic Number is "LYNX"

Current version MUST be 0x01

Rotation is defined as:
    0 - No rotate
    1 - Rotate left (counter clockwise)
    2 - Rotate right (clockwise)

Page sizes can be:
  0    - Empty bank
  256  - 64KByte Bank
  512  - 128KByte Bank
  1024 - 256KByte Bank
  2048 - 512KByte Bank

As bank1 is almost invariably empty on most carts I have seen then you can
read cartridge size for bank size.

The make_lnx utility & source is included in with this release. I've re-worked
the code and it is now robust and supports all of the command line options
correctly.

make_lnx <filename>



4.0 Handy Special register
--------------------------

There is a special register present under Handy that is not present in the normal
Lynx, the purpose of this register is to allow your software to detect that it is
running under emulation.

If you are running under Handy then location $FD97 will return 0x42. Please note
that Mikey must be enabled in the memory map ($FFF9) for this to be true.



5.0 Handy screendump format (RAW)
---------------------------------

If you dump screen images in RAW format the structure is as detailed below:

32 bytes palette        - straight dump from Lynx registers
8160 bytes screen       - straight dump from Lynx display memory


--- END OF FILE ---
