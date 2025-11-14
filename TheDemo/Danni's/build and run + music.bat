copy ..\..\Chipper-1.7.6\tmp_cc65.s
ca65 -t lynx tmp_cc65.s -o music.o
ca65 -t lynx soundbs.s -o soundbs.o
cl65 -t lynx -o demo.lnx demo.c soundbs.o music.o fem1.a male.a malegamer.a stilllife.a libraytrace.a -ltgi
..\..\Mednafen\mednafen.exe demo.lnx