# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Image-ValidJpeg.t'

#########################

use Test::More;
BEGIN { use_ok('Image::ValidJpeg') };

#########################
use Fatal 'open';
my $fh;

##############################
# Test trunated JPEG
##############################

open $fh, 't/data/short.jpg';
is( Image::ValidJpeg::check_tail($fh), Image::ValidJpeg::BAD, "check_tail on invalid image" );
close($fh);

open $fh, 't/data/short.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::BAD, "check_jpeg on invalid image" );
close($fh);

open $fh, 't/data/short.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::SHORT, "check_all on invalid image" );
close($fh);


##############################
# Test valid JPEG
##############################

open $fh, 't/data/small.jpg';
is( Image::ValidJpeg::check_tail($fh), Image::ValidJpeg::GOOD, "check_tail on valid image" );
close($fh);


open $fh, 't/data/small.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::GOOD, "check_jpeg on valid image" );
close($fh);

open $fh, 't/data/small.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::GOOD, "check_all on valid image" );
close($fh);

open $fh, 't/data/small.jpg';
is( Image::ValidJpeg::check_tail($fh), Image::ValidJpeg::GOOD, "check_tail on valid image" );
close($fh);

########################################
# Test valid JPEGs with extra data
########################################

#doubled jpeg
open $fh, 't/data/double.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::GOOD, "check_jpeg on double image" );
close($fh);

open $fh, 't/data/double.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::EXTRA, "check_all on double image" );
close($fh);

#jpeg + some random junk
open $fh, 't/data/extra.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::BAD, "check_jpeg on image + junk" );
close($fh);

open $fh, 't/data/extra.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::EXTRA, "check_all on image + junk" );
close($fh);

done_testing;
