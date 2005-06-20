use Test::Base tests => 3;

run { pass };

is scalar(blocks), 1;

is first_block->foo, "2";

__DATA__
=== One
--- foo: 1
=== Two
--- ONLY
--- foo: 2
=== Three
--- foo: 3
--- ONLY
=== Four
--- foo: 4
