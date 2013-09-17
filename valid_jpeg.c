#include "valid_jpeg.h"
#include <arpa/inet.h>

unsigned char valid_jpeg_debug = 0;

void set_valid_jpeg_debug(int x) 
{
  valid_jpeg_debug = x;
}

static int max_seek_ = 1024;


int max_seek (int n) 
{
  int o = max_seek_;
  max_seek_ = n;
  return o;
}

static void debug(const char * msg)
{
  if (valid_jpeg_debug)
    puts(msg);
}

int check_tail (PerlIO * fh) 
{
  unsigned char bytes[2];
  int n_read;
  
  if( PerlIO_seek(fh,-2,SEEK_END) ) 
    return BAD_;

  n_read = PerlIO_read(fh, bytes, 2);

  if ( (n_read==2) && (bytes[0]==0xff) && (bytes[1]==0xd9) )
    return GOOD_;

  return BAD_;
}


  
int valid_jpeg (FILE * fh, unsigned char seek_over_entropy) 
{
  char in_entropy=0;
  int j;
  
  while (! feof(fh))
    {
      unsigned char marker=0;

      if ( fread(&marker, 1, 1, fh) < 1 )
	return SHORT_;

      if ( in_entropy ) 
	{
	  if ( marker == 0xff ) 
	    {
	      if ( fread(&marker, 1, 1, fh) < 1 )
		return SHORT_;
	      if ( marker == 0 )
		//escaped 0xff00
		continue;
	      else if ( (marker >= 0xd0) && (marker <= 0xd7) )
		//RST
		continue;
	      else 
		{
		  //marker after data may be padded
		  while ( marker == 0xff )
		    if ( fread(&marker, 1, 1, fh) < 1 )
		      return SHORT_;
		  in_entropy = 0;
		  
		}
	    } else continue;
	  
	}
      else 
	{
	if (marker != 0xff)
	  return BAD_;
	
	if ( fread(&marker, 1, 1, fh) < 1 )
	  return SHORT_;
	}
	
      if ( marker == 0 )
	return BAD_;

      if (marker == 0xd8)
	debug("got start");
      else if (marker == 0xd9) 
	{
	  //EOI - unless multi-image, should also be EOF 
	  unsigned char junk;
	  if (fread(&junk, 1, 1, fh) > 0)
	    return EXTRA_;

	  if (feof(fh))
	    return GOOD_;
	  else
	    return EXTRA_;
	}
      
      else if ( (marker >= 0xd0) && (marker <= 0xd7) ) 
	{
	  /* RST should only be in entropy */
	  debug("got stray RST");
	  return BAD_;
	  
	}
      
      else if ( marker == 0xff01 ) 
	{
	  //rare marker for arithmetic encoding
	  debug("got TEM");
	}
      
      else
	{
	  unsigned short length;

	  if (marker == 0xda) {
	    if ( seek_over_entropy ) 
	      {
		if( fseek(fh,-2,SEEK_END) ) 
		  return SHORT_;
		else
		  continue;
	      }
	    else 
	      {
		in_entropy = 1;
	      }
	  }
	  
	  if ( fread(&length, 2, 1, fh) < 1 )
	    return SHORT_;
	  
	  length = ntohs(length);

	  if (valid_jpeg_debug) printf ("Length is %d\n", length);
#if 1
	  if (length > max_seek_) 
	    fseek(fh,length-2,SEEK_CUR);
	  else
#endif
	    for (j=2; j<length; ++j)
	      {
		char junk;
		if ( fread(&junk, 1, 1, fh) < 1 )
		  return SHORT_;
	      }
	}
      
    }
  return SHORT_;
}

int check_jpeg (FILE * fh) 
{
  return valid_jpeg(fh, 1);
}
int check_all (FILE * fh) 
{
  return valid_jpeg(fh, 0);
}
