use inc::Module::Install;

name        'Test-Base';
license     'perl';
all_from    'lib/Test/Base.pm';

requires(qw(
    perl 5.6.1
    Spiffy 0.26
    Test::More 0.62
));

clean_files 't/output';

check_nmake;

&WriteAll;
