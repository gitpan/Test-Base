use Test::Base;

filters qw(norm trim chomp);

plan tests => 1 * blocks;

is(next_block->input, "on\ntw\nthre\n");

__END__
===
--- input lines chomp chop unchomp join
one
two
three
