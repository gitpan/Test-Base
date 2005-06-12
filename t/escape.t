use Test::Base;

plan tests => 1 * blocks;

my @blocks = blocks;

is($blocks[0]->escaped, "line1\nline2");
is($blocks[1]->escaped, "	foo\n		bar\n");

__END__

===
--- escaped escape chomp
line1\nline2
===
--- escaped escape
\tfoo
\t\tbar

