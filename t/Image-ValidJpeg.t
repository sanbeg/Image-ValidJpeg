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
is( Image::ValidJpeg::check_tail($fh), 1 );
close($fh);

open $fh, 't/short.jpg';
is( Image::ValidJpeg::valid_jpeg($fh), 4 );
close($fh);

open $fh, 't/short.jpg';
is( Image::ValidJpeg::check_all($fh), 1 );
close($fh);


open $fh, 't/small.jpg';
is( Image::ValidJpeg::check_tail($fh), 0 );
close($fh);

open $fh, 't/small.jpg';
is( Image::ValidJpeg::valid_jpeg($fh), 0 );
close($fh);

open $fh, 't/small.jpg';
is( Image::ValidJpeg::check_all($fh), 0 );
close($fh);


done_testing;
