use Test::Base;

plan tests => 3;

run {
    ok(1);
};

is(scalar(blocks), 1);

my ($block) = blocks;
is($block->foo, "2\n");

__DATA__
=== One
--- foo
1
=== Two
--- ONLY
--- foo
2
=== Three
--- foo
3
--- ONLY
=== Four
--- foo
4
