use Test::Base;

delimiters qw($$$ ***);

plan tests => 1 * blocks;

run {
    ok(shift);
};

__END__

$$$
*** foo
this
*** bar
that

$$$

*** foo
hola
*** bar
latre
