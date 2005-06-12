use Test::Base;

filters 'chomp';

plan tests => (1 * blocks) + 1;

is((1 * blocks), 3, 'Does LAST limit tests to 3?');

run {
    my $block = shift;
    is($block->test, 'all work and no play');
}

__DATA__
===
--- test
all work and no play

===
--- test
all work and no play

=== 
--- LAST
--- test
all work and no play

===
--- test
all work and no play

===
--- test
all work and no play

===
--- test
all work and no play

===
--- test
all work and no play


