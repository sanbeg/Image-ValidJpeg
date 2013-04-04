# NAME

Image::ValidJpeg - Perl extension for validating JPEG files.

# SYNOPSIS

    use Image::ValidJpeg;

    open $fh, 'FILE.jpg';

    if( Image::ValidJpeg::check_jpeg($fh) ) {
       print "FILE.jpg is bad\n";
    }

# DESCRIPTION

This module parses JPEG files to look for errors, such as truncated files.

The methods return 0 if the file is valid, nonzero if an error is detected.

## METHODS

- __check\_tail__(_$fh_)

    Look for an end of image marker in the last few bytes of _$fh_.  

    This is slightly faster than _check\_jpeg_ and should catch most truncated
    images, unless they happen to be truncated at the end of an embedded JPEG.

- __check\_jpeg__(_$fh_)

    Scan through the basic structure of the file, validating that it is correct,
    until it gets to the main image data.  Then, look for an end of image marker
    in the last few bytes of _$fh_.  

    This can detect some problems that _check\_tail_ cannot, without being
    noticeably slower, making it useful for scanning a large number of image
    files.

- __check\_all__(_$fh_)

    Scan through the basic structure of the file, validating that it is correct;
    also scan the main image data byte by byte.  Verify that the file ends with
    end of image marker in the last few bytes of _$fh_.  

    This it the most thorough method, but also the slowest, so it's
    useful for checking a small number of images.  It's the only one that can
    differentiate between a bad image and a valid image with extra data
    appended, or between a valid jpeg and two jpegs concatenated together.

## CONSTANTS

The following contants are defined, to match the return values of the
validation functions:

- __GOOD__

    Returned for a valid JPEG.  This is guaranteed to be 0.

- __SHORT__

    Returned if we ran out of data before the end marker was found (i.e. a
    truncated file).  Can only be returned by _check\_all_, since we can't
    detect this condition without fully parsing the file.

- __EXTRA__

    Returned if the jpeg was otherwsie valid, there was more data in the file
    after the end marker was found.  Can only be returned by _check\_all_, since
    we can't detect this condition without fully parsing the file.

- __BAD__

    Returned if validation failed for other reasons, such as an invalid marker.
    Errors from _check\_jpeg_ always return _BAD_.

## EXPORT

None by default.

The _check\_\*_ methods and constants can be imported individually, or they
call all be imported via the _':all'_ tag.

# AUTHOR

Steve Sanbeg

# COPYRIGHT AND LICENSE

Copyright (C) 2012 by Steve Sanbeg

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


