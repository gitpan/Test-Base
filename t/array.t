use Test::Base;

plan tests => 1;

my ($block) = blocks;
is_deeply $block->foo, [qw(one two three)];

__DATA__


===
--- foo lines chomp array
one
two
three
