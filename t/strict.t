use Test::Base;

plan tests => 1 * blocks;

run_is perl => 'strict';

__DATA__
=== Strict Test

--- perl strict
my $x = 5;
--- strict
use strict;
use warnings;
my $x = 5;
