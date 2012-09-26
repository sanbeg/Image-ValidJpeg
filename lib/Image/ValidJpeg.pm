package Image::ValidJpeg;

use 5.010001;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Image::ValidJpeg ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
check_tail
check_jpeg
check_all
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Image::ValidJpeg::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Image::ValidJpeg', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Image::ValidJpeg - Perl extension for validating JPEG files.

=head1 SYNOPSIS

use Image::ValidJpeg;

open $fh, 'FILE.jpg';

Image::ValidJpeg::valid_jpeg($fh);

=head1 DESCRIPTION

This module parses JPEG files to look for errors, such as truncated files.

The methods return 0 if the file is valid, nonzero if an error is detected.

=head2 METHODS

=over

=item B<check_tail>(I<$fh>)

Look for an end of image marker in the last few bytes of I<$fh>.

=item B<check_jpeg>(I<$fh>)

Scan through the basic structure of the file, validating that it is correct,
until it gets to the main image data.  Then, look for an end of image marker
in the last few bytes of I<$fh>.

=item B<check_all>(I<$fh>)

Scan through the basic structure of the file, validating that it is correct;
also scan the main image data byte by byte.  Verify that the file ends with
end of image marker in the last few bytes of I<$fh>.  This it the most
thorough method, but also the slowest, so probably most useful for checking
a small number of images.

=back

=head2 CONSTANTS

The following contants are defined, to match the return values of the
validation functions:

=over

=item B<GOOD>

Returned for a valid JPEG.  This is guaranteed to be 0.

=item B<SHORT>

Returned if we ran out of data before the end marker was found (i.e. a
truncated file).  Can only be returned by I<check_all>, since we can't
detect this condition without fully parsing the file.

=item B<EXTRA>

Returned if the jpeg was otherwsie valid, there was more data in the file
after the end marker was found.  Can only be returned by I<check_all>, since
we can't detect this condition without fully parsing the file.

=item B<BAD>

Returned if validation failed for other reasons, such as an invalid marker.
Errors from I<check_jpeg> always return I<BAD>.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Steve Sanbeg

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Steve Sanbeg

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
