#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <valid_jpeg.h>

#include "const-c.inc"

MODULE = Image::ValidJpeg		PACKAGE = Image::ValidJpeg		

INCLUDE: const-xs.inc
