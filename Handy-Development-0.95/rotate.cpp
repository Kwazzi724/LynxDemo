//
// Rotate V1
//
// K.Wilkins July97
//
// V1 - Creation
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Bytes should be 8-bits wide
typedef signed char SBYTE;
typedef unsigned char UBYTE;

// Words should be 16-bits wide
typedef signed short SWORD;
typedef unsigned short UWORD;

// Longs should be 32-bits wide
typedef long SLONG;
typedef unsigned long ULONG;

typedef struct
{
  UBYTE   magic[4];
  UWORD   page_size_bank0;
  UWORD   page_size_bank1;
  UWORD   version;
  UBYTE   cartname[32];
  UBYTE   manufname[16];
  UBYTE   rotation;
  UBYTE   spare[5];
}LYNX_HEADER_NEW;

#define CART_NO_ROTATE          0
#define CART_ROTATE_LEFT        1
#define CART_ROTATE_RIGHT       2

void usage(void)
{
     fprintf(stderr,"Rotate - A utility to set the rotate flag of LNX Images V5\n");
     fprintf(stderr,"----------------------------------------------------------\n");
     fprintf(stderr,"K.Wilkins July 1997\n\n");
     fprintf(stderr,"USAGE:  rotate <left/right/default <file>\n");
     fprintf(stderr,"\n");
     fprintf(stderr,"This utility will patch the LNX header and add in the new\n");
     fprintf(stderr,"rotation flag so that you can make games start with the screen\n");
     fprintf(stderr,"in the correct orientation.\n");
     fprintf(stderr,"Any existing images you have will still work correctly and\n");
     fprintf(stderr,"will only need modifiying if you wish to take advantage of\n");
     fprintf(stderr,"the rotate feature.\n");
     fprintf(stderr,"\n");
     fprintf(stderr,"Examples:\n");
     fprintf(stderr,"rotate left gauntlet.lnx\n");
	 fprintf(stderr,"rotate default batman.lnx\n");
     fprintf(stderr,"\n");
}

void main(int argc, char *argv[])
{
	FILE *filein,*fileout;
	LYNX_HEADER_NEW header;
	UBYTE data=0;
	char infile[256];
	char outfile[256];
	UBYTE rotation;
	char rotatestr[256];
	SLONG argno=0,loop=0;

	if(argc!=3)
	{
	    fprintf(stderr,"ERROR: Invalid number of arguments\n\n");
		usage();
		exit(-1);
	}

   rotation=CART_NO_ROTATE;

   strcpy(rotatestr,argv[1]);
   strcpy(infile,argv[2]);
   strcpy(outfile,"rotate.tmp");


   loop=0;
   while(rotatestr[loop])
   {
	   rotatestr[loop]=toupper(rotatestr[loop]);
	   loop++;
   }

   if(strcmp(rotatestr,"LEFT")==0) rotation=CART_ROTATE_LEFT;
   else if(strcmp(rotatestr,"RIGHT")==0) rotation=CART_ROTATE_RIGHT;
   else if(strcmp(rotatestr,"DEFAULT")==0) rotation=CART_NO_ROTATE;
   else if(strcmp(rotatestr,"")!=0)
   {
     fprintf(stderr,"\nERROR: Invalid rotation paramter only LEFT/RIGHT/DEFAULT are valid\n");
     exit(-1);
   }

   if((filein=fopen(infile,"rb"))==NULL)
   {
     fprintf(stderr,"\nERROR: Couldn't open %s for reading\n",infile);
     exit(-1);
   }

   if(!fread(&header,sizeof(LYNX_HEADER_NEW),1,filein))
   {
     fprintf(stderr,"\nERROR: Couldn't read header\n");
     fclose(filein);
     exit(-1);
   }

   if(header.magic[0]!='L' || header.magic[1]!='Y' || header.magic[2]!='N' || header.magic[3]!='X')
   {
     fprintf(stderr,"\nERROR: %s is not an LNX format file\n",infile);
     fclose(filein);
     exit(-1);
   }

   header.rotation=rotation;

   if((fileout=fopen(outfile,"wb"))==NULL)
   {
     fprintf(stderr,"\nERROR: Couldn't open %s for writing\n",outfile);
     fclose(filein);
     exit(-1);
   }

   if(!fwrite(&header,sizeof(LYNX_HEADER_NEW),1,fileout))
   {
     fprintf(stderr,"\nERROR: Couldn't write header\n");
     fclose(filein);
	 fclose(fileout);
	 unlink(outfile);
     exit(-1);
   }

   while(fread(&data,sizeof(UBYTE),1,filein))
   {
      fwrite(&data,sizeof(UBYTE),1,fileout);
   }


   fclose(filein);
   fclose(fileout);

   unlink(infile);
   rename(outfile,infile);
   fprintf(stdout,"DONE: File modified");
}

   

