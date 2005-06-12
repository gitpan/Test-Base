use lib 't';
use Test::Base;

plan tests => 1;

eval "use TestBass";

like("$@", qr{Can't use TestBass after using Test::Base});
