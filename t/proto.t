use Test::More;

use Image::ValidJpeg ':all';

open $fh, 't/data/small.jpg';
is( check_jpeg($fh), GOOD, "valid_jpeg on valid image" );
close($fh);

done_testing;
