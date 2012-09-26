# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Image-ValidJpeg.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
BEGIN { use_ok('Image::ValidJpeg') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

open my($fh), 't/short.jpg';
is( Image::ValidJpeg::check_tail($fh), 1, "check_tail on invalid image" );
close($fh);

open $fh, 't/short.jpg';
is( Image::ValidJpeg::valid_jpeg($fh), Image::ValidJpeg::SHORT, "valid_jpeg on invalid image" );
close($fh);

open $fh, 't/short.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::BAD, "check_all on invalid image" );
close($fh);


open $fh, 't/small.jpg';
is( Image::ValidJpeg::check_tail($fh), Image::ValidJpeg::GOOD, "check_tail on valid image" );
close($fh);


open $fh, 't/small.jpg';
is( Image::ValidJpeg::valid_jpeg($fh), Image::ValidJpeg::GOOD, "valid_jpeg on valid image" );
close($fh);

open $fh, 't/small.jpg';
is( Image::ValidJpeg::check_all($fh), Image::ValidJpeg::GOOD, "check_all on valid image" );
close($fh);

done_testing;
