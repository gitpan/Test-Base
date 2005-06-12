use Test::Base;

plan tests => 1 * blocks;

run_is in => 'out';

__DATA__
===
--- in lines append=---\n join
one
two
three
--- out
one
---
two
---
three
---

===
--- in lines chomp append=---\n join
one
two
three
--- out
one---
two---
three---

===
--- in chomp append=---\n
one
two
three
--- out
one
two
three---

