#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <valid_jpeg.h>

#include "const-c.inc"

MODULE = Image::ValidJpeg		PACKAGE = Image::ValidJpeg		

INCLUDE: const-xs.inc

int
check_tail(FILE * fh);

int
valid_jpeg(FILE * fh, int parse=0);

int 
check_all(FILE * fh);

int
GOOD()

int
BAD()

int
SHORT()

int
LONG()

int
max_seek(int n)
