#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <valid_jpeg.h>

MODULE = Image::ValidJpeg		PACKAGE = Image::ValidJpeg		

PROTOTYPES: ENABLE

int
check_tail(PerlIO * fh);

int
valid_jpeg(FILE * fh, int skip=0);

int 
check_all(FILE * fh);

int
check_jpeg(FILE *fh);

int
GOOD()
CODE:
	RETVAL = GOOD_;
OUTPUT:
	RETVAL

int
BAD()
CODE:
	RETVAL = BAD_;
OUTPUT:
	RETVAL

int
EXTRA()
CODE:
	RETVAL = EXTRA_;
OUTPUT:
	RETVAL

int
SHORT()
CODE:
	RETVAL = SHORT_;
OUTPUT:
	RETVAL

int
max_seek(int n)

void
set_valid_jpeg_debug(int x)
