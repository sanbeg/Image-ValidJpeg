# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Image-ValidJpeg.t'

#########################

use Test::More;
BEGIN { use_ok('Image::ValidJpeg') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

open my($fh), 't/data/short.jpg';
is( Image::ValidJpeg::check_tail($fh), Image::ValidJpeg::BAD, "check_tail on invalid image" );
close($fh);

open $fh, 't/data/short.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::BAD, "check_jpeg on invalid image" );
close($fh);

open $fh, 't/data/short.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::SHORT, "check_all on invalid image" );
close($fh);


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

#doubled jpeg
open $fh, 't/data/double.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::GOOD, "check_jpeg on double image" );
close($fh);

open $fh, 't/data/double.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::EXTRA, "check_all on double image" );
close($fh);

#doubled jpeg
open $fh, 't/data/extra.jpg';
is( Image::ValidJpeg::check_jpeg($fh), Image::ValidJpeg::BAD, "check_jpeg on double image" );
close($fh);

open $fh, 't/data/extra.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::EXTRA, "check_all on double image" );
close($fh);

done_testing;
