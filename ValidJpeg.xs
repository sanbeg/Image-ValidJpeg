#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <valid_jpeg.h>

#include "const-c.inc"

int GOOD() 
{
  return GOOD_;
}
int BAD()
{
  return BAD_;
}
int EXTRA()
{
  return EXTRA_;
}
int SHORT()
{
  return SHORT_;
}

MODULE = Image::ValidJpeg		PACKAGE = Image::ValidJpeg		

INCLUDE: const-xs.inc

int
check_tail(FILE * fh);

int
valid_jpeg(FILE * fh, int skip=0);

int 
check_all(FILE * fh);

int
check_jpeg(FILE *fh);

int
GOOD()

int
BAD()

int
EXTRA()

int
SHORT()

int
max_seek(int n)

void
set_valid_jpeg_debug(int x)
