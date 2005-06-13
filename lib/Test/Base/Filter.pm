#===============================================================================
# Test::Base::Filter
#
# This is the default class for handling Test::Base data filtering.
#===============================================================================
package Test::Base::Filter;
use Spiffy -Base;

field 'block';

our $arguments;
sub arguments {
    return undef unless defined $arguments;
    my $args = $arguments;
    $args =~ s/(\\[a-z])/'"' . $1 . '"'/gee;
    return $args;
}

sub assert_scalar {
    return if @_ == 1;
    require Carp;
    my $filter = (caller(1))[3];
    $filter =~ s/.*:://;
    Carp::croak "Input to the '$filter' filter must be a scalar, not a list";
}

#===============================================================================
sub append {
    my $suffix = $self->arguments;
    map { $_ . $suffix } @_;
}

sub array {
    [@_];
}

sub base64_decode {
    $self->assert_scalar(@_);
    require MIME::Base64;
    MIME::Base64::decode_base64(shift);
}

sub base64_encode {
    $self->assert_scalar(@_);
    require MIME::Base64;
    MIME::Base64::encode_base64(shift);
}

sub chomp {
    map { CORE::chomp; $_ } @_;
}

sub chop {
    map { CORE::chop; $_ } @_;
}

sub dumper {
    no warnings 'once';
    require Data::Dumper;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Indent = 1;
    local $Data::Dumper::Terse = 1;
    Data::Dumper::Dumper(@_);
}

sub escape {
    $self->assert_scalar(@_);
    my $text = shift;
    $text =~ s/(\\.)/eval "qq{$1}"/ge;
    return $text;
}

sub eval {
    $self->assert_scalar(@_);
    my @return = CORE::eval(shift);
    return $@ if $@;
    return @return;
}

sub eval_all {
    $self->assert_scalar(@_);
    my $out = '';
    my $err = '';
    Test::Base::tie_output(*STDOUT, $out);
    Test::Base::tie_output(*STDERR, $err);
    my $return = CORE::eval(shift);
    no warnings;
    untie *STDOUT;
    untie *STDERR;
    return $return, $@, $out, $err;
}

sub eval_stderr {
    $self->assert_scalar(@_);
    my $output = '';
    Test::Base::tie_output(*STDERR, $output);
    CORE::eval(shift);
    no warnings;
    untie *STDERR;
    return $output;
}

sub eval_stdout {
    $self->assert_scalar(@_);
    my $output = '';
    Test::Base::tie_output(*STDOUT, $output);
    CORE::eval(shift);
    no warnings;
    untie *STDOUT;
    return $output;
}

sub exec_perl_stdout {
    my $tmpfile = "/tmp/test-blocks-$$";
    $self->_write_to($tmpfile, @_);
    open my $execution, "$^X $tmpfile 2>&1 |"
      or die "Couldn't open subprocess: $!\n";
    local $/;
    my $output = <$execution>;
    close $execution;
    unlink($tmpfile)
      or die "Couldn't unlink $tmpfile: $!\n";
    return $output;
}

sub get_url {
    $self->assert_scalar(@_);
    my $url = shift;
    CORE::chomp($url);
    require LWP::Simple;
    LWP::Simple::get($url);
}
    
sub join {
    my $string = $self->arguments;
    $string = '' unless defined $string;
    CORE::join $string, @_;
}

sub lines {
    $self->assert_scalar(@_);
    my $text = shift;
    return () unless length $text;
    my @lines = ($text =~ /^(.*\n?)/gm);
    return @lines;
}

sub norm {
    $self->assert_scalar(@_);
    my $text = shift || '';
    $text =~ s/\015\012/\n/g;
    $text =~ s/\r/\n/g;
    return $text;
}

sub regexp {
    $self->assert_scalar(@_);
    my $text = shift;
    my $flags = $self->arguments;
    if ($text =~ /\n.*?\n/s) {
        $flags = 'xism'
          unless defined $flags;
    }
    else {
        CORE::chomp($text);
    }
    $flags ||= '';
    my $regexp = eval "qr{$text}$flags";
    die $@ if $@;
    return $regexp;
}

sub strict {
    $self->assert_scalar(@_);
    <<'...' . shift;
use strict;
use warnings;
...
}

sub trim {
    map {
        s/\A([ \t]*\n)+//;
        s/(?<=\n)\s*\z//g;
        $_;
    } @_;
}

sub unchomp {
    map { $_ . "\n" } @_;
}

sub yaml {
    $self->assert_scalar(@_);
    require YAML;
    return YAML::Load(shift);
}

sub _write_to {
    my $filename = shift;
    open my $script, ">$filename"
      or die "Couldn't open $filename: $!\n";
    print $script @_;
    close $script
      or die "Couldn't close $filename: $!\n";
}

__DATA__

=head1 NAME

Test::Base::Filter - Default Filter Class for Test::Base

=head1 SYNOPSIS

    package MyTestSuite;
    use Test::Base -Base;

    ... reusable testing code ...

    package MyTestSuite::Filter;
    use Test::Base::Filter -Base;

    sub my_filter1 {
        ...
    }

=head1 DESCRIPTION

Filters are the key to writing effective data driven tests with Test::Base.
Test::Base::Filter is a class containing a large default set of generic
filters. You can easily subclass it to add/override functionality.

=head1 FILTERS

This is a list of the default stock filters (in alphabetic order):

=head2 append

list => list

Append a string to each element of a list.

    --- numbers lines chomp append=-#\n join
    one
    two
    three

=head2 array

list => scalar

Turn a list of values into an anonymous array reference.

=head2 base64_decode

scalar => scalar

Decode base64 data. Useful for binary tests.

=head2 base64_encode

scalar => scalar

Encode base64 data. Useful for binary tests.

=head2 chomp

list => list

Remove the final newline from each string value in a list.

=head2 chop

list => list

Remove the final char from each string value in a list.

=head2 dumper

scalar => list

Take a data structure (presumably from another filter like eval) and use
Data::Dumper to dump it in a canonical fashion.

=head2 escape

scalar => scalar

Unescape all backslash escaped chars.

=head2 eval

scalar => list

Run Perl's C<eval> command against the data and use the returned value
as the data.

=head2 eval_all

scalar => list

Run Perl's C<eval> command against the data and return a list of 4
values:

    1) The return value
    2) The error in $@
    3) Captured STDOUT
    4) Captured STDERR

=head2 eval_stderr

scalar => scalar

Run Perl's C<eval> command against the data and return the
captured STDERR.

=head2 eval_stdout

scalar => scalar

Run Perl's C<eval> command against the data and return the
captured STDOUT.

=head2 exec_perl_stdout

list => scalar

Input Perl code is written to a temp file and run. STDOUT is captured and
returned.

=head2 get_url

scalar => scalar

The text is chomped and considered to be a url. Then LWP::Simple::get is
used to fetch the contents of the url.

=head2 join

list => scalar

Join a list of strings into a scalar.

=head2 lines

scalar => list

Break the data into an anonymous array of lines. Each line (except
possibly the last one if the C<chomp> filter came first) will have a
newline at the end.

=head2 norm

scalar => scalar

Normalize the data. Change non-Unix line endings to Unix line endings.

=head2 regexp[=xism]

scalar => scalar

The C<regexp> filter will turn your data section into a regular
expression object. You can pass in extra flags after an equals sign.

If the text contains more than one line and no flags are specified, then
the 'xism' flags are assumed.

=head2 strict

scalar => scalar

Prepend the string:

    use strict; 
    use warnings;

to the block's text.

=head2 trim

list => list

Remove extra blank lines from the beginning and end of the data. This
allows you to visually separate your test data with blank lines.

=head2 unchomp

list => list

Add a newline to each string value in a list.

=head2 yaml

scalar => list

Apply the YAML::Load function to the data block and use the resultant
structure. Requires YAML.pm.

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
