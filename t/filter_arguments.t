use Test::Base tests => 3;

my @blocks = blocks();

sub foo {
    is(filter_arguments, '123,456');
}

sub bar {
    is(filter_arguments, '---holy-crow+++');
    is($_, "one\n  two\n");
}

__DATA__
===
--- xxx foo=123,456

=== 
--- xxx bar=---holy-crow+++
one
  two
