#include "valid_jpeg.h"
#include <arpa/inet.h>

unsigned char valid_jpeg_debug = 0;

enum valid_jpeg_status 
  {
    valid_jpeg_ok = 0,
    trailing_junk,
    short_file,
    bad_data,
    invalid_header,
  };

int GOOD() 
{
  return valid_jpeg_ok;
}
int SHORT()
{
  return short_file;
}
int BAD()
{
  return bad_data;
}
int LONG()
{
  return trailing_junk;
}

static int max_seek_ = 512;


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

int check_tail (FILE * fh) 
{
  if( fseek(fh,-2,SEEK_END) ) 
    return -1;

  unsigned char bytes[2];
  int n_read = fread(bytes, 1, 2, fh);
  if ( (n_read==2) && (bytes[0]==0xff) && (bytes[1]==0xd9) )
    return 0;
  return 1;
}


  
int valid_jpeg (FILE * fh, unsigned char seek_over_entropy) 
{
  char in_entropy=0;
  int j;
  
  while (! feof(fh))
    {
      unsigned char marker=0;

      if ( fread(&marker, 1, 1, fh) < 1 )
	return short_file;
      if (marker != 0xff)
	{
	  
	  if (! in_entropy)
	    {
	      return bad_data;
	    }
	  
	  continue;
	}

      if ( fread(&marker, 1, 1, fh) < 1 )
	return short_file;
      
      if (marker != 0)
	{
	  in_entropy = 0;
	}
      else
	{
	  if (! in_entropy)
	    return bad_data;
	  continue;
	}
      if (marker == 0xd8)
	debug("got start");
      else if (marker == 0xd9) 
	{
	  unsigned char junk;
	  if (fread(&junk, 1, 1, fh) > 0)
	    return trailing_junk;

	  if (feof(fh))
	    return valid_jpeg_ok;
	  else
	    return trailing_junk;
	}
      
      else if ( (marker >= 0xd0) && (marker <= 0xd7) )
	debug("got RST");
      else
	{
	  unsigned short length;

	  if (marker == 0xda) {
	    if ( seek_over_entropy ) 
	      {
		if( fseek(fh,-2,SEEK_END) ) 
		  return -1;
		else
		  continue;
	      }
	    else 
	      {
		in_entropy = 1;
	      }
	  }
	  
	  if ( fread(&length, 2, 1, fh) < 1 )
	    return short_file;
	  
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
		  return short_file;
	      }
	}
      
    }
  return short_file;
}

int check_all (FILE * fh) 
{
  return valid_jpeg(fh, 1);
}
