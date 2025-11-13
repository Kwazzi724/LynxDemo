// - Die vom LYXASS erzeugten Dateien haben eine Header der wie folgt aussieht :
// 
//                 dc.w $8008
//                 dc.w Start
//                 dc.w Len        ; inc. Header
//                 dc.l "BS93"
// 
// - Der ComLynx-Loader erwartet :
//
// Start-Sequenz : $81,"P"                         ; Programm laden
// Init-Sequenz  : LO(Start),HI(Start)             ; Startadr. = Zieladr.
//                 LO((Len-10) XOR $FFFF),HI((Leb-10) XOR $FFFF)
//                                                 ; und die Länge der Daten
// Xmit-Sequenz  : ....                            ; das Programm
// Checksumme    : keine !!
//

//
// THE ABOVE DESCRIPTION IS WRONG WRONG WRONG WRONG, THINGS ARE TRANSMITTED
// THE OTHER WAY AROUND HI/LO NOT LO/HI


#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>

typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct
{
	UWORD	jump;
	UWORD	load_address;
	UWORD	size;
	UBYTE	magic[4];
}HOME_HEADER;

void main(int argc, char **argv)
{
	HANDLE fout,fin;
	UBYTE image;
	UBYTE csum=0;
	UWORD tmp;
	HOME_HEADER	header;
	DCB	comstat;
	int  xyzzy,nmbread;

	if((fin=CreateFile(argv[1],
					   GENERIC_READ,
					   FILE_SHARE_READ,
					   NULL,
					   OPEN_EXISTING,
					   FILE_ATTRIBUTE_NORMAL,
					   NULL))==INVALID_HANDLE_VALUE)
	{
		fprintf(stderr,"ERROR: Failed to open input file.\n");
		exit(0);
	}

	if((fout=CreateFile("com1:",
						GENERIC_WRITE,
						FILE_SHARE_READ,
						NULL,
						OPEN_EXISTING,
						FILE_ATTRIBUTE_NORMAL,
						NULL))==INVALID_HANDLE_VALUE)
	{
		fprintf(stderr,"ERROR: Failed to open serial port.\n");
		exit(0);
	}

	//
	// Modify the device attributes
	//

	if(!GetCommState(fout,&comstat))
	{
		fprintf(stderr,"ERROR: Failed GetCommState()\n");
		exit(0);
	}

	comstat.BaudRate=CBR_9600;
	comstat.fParity=TRUE;
	comstat.Parity=EVENPARITY;
	comstat.StopBits=ONESTOPBIT;

	if(!SetCommState(fout,&comstat))
	{
		fprintf(stderr,"ERROR: Failed GetCommState()\n");
		exit(0);
	}


	//
	// Read in image header
	//

	ReadFile(fin,&header,sizeof(HOME_HEADER),&xyzzy,NULL);

	if(header.jump!=0x8008 && header.magic[0]!='B' && header.magic[1]!='S' && header.magic[2]!='9' && header.magic[3]!='3')
	{
		fprintf(stderr,"ERROR: File header is corrupted, aborting\n");
		exit(0);
	}

	// Swap word order in the header, humph!

	tmp=header.jump;
	header.jump=tmp>>8;
	header.jump+=(tmp&0xff)<<8;

	tmp=header.load_address;
	header.load_address=tmp>>8;
	header.load_address+=(tmp&0xff)<<8;

	tmp=header.size;
	header.size=tmp>>8;
	header.size+=(tmp&0xff)<<8;

//	fprintf(stdout,"Header: %04x (JUMP)\n",header.jump);
//	fprintf(stdout,"Header: %04x (LOAD)\n",header.load_address);
//	fprintf(stdout,"Header: %04x (SIZE)\n",header.size);
//	fprintf(stdout,"Header: %c%c%c%c (MAGIC)\n\n",header.magic[0],header.magic[1],header.magic[2],header.magic[3]);

	image=0x81;
	WriteFile(fout,&image,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (INIT 1)\n",image);
	image='P';
	WriteFile(fout,&image,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (INIT 2)\n",image);

	//
	// Write image start
	//
	image=(UBYTE)(header.load_address>>8);
	WriteFile(fout,&image,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (START HI)\n",image);

	image=(UBYTE)(header.load_address&0xff);
	WriteFile(fout,&image,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (START LO)\n",image);

	//
	// Write image size
	//
	tmp=(header.size-10)^0xffff;

	image=(UBYTE)(tmp>>8);
	WriteFile(fout,&image,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (SIZE HI)\n",image);

	image=(UBYTE)(tmp&0xff);
	WriteFile(fout,&image,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (SIZE LO)\n",image);

	// Dump the file

	do
	{
       if(!ReadFile(fin,&image,sizeof(char),&nmbread,NULL)) break;
       if(!WriteFile(fout,&image,sizeof(char),&xyzzy,NULL)) break;

	   csum+=image;
	}
	while(nmbread);

	// Write the csum

	WriteFile(fout,&csum,sizeof(char),&xyzzy,NULL);
//	fprintf(stdout,"Serial: %02x (CSUM)\n",csum);

	CloseHandle(fin);
	CloseHandle(fout);

	fprintf(stdout,"DOWNLOAD COMPLETED OK\n");
	exit(0);
}