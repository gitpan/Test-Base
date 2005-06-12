use inc::Module::Install;

name('Test-Base');
author('Brian Ingerson <ingy@cpan.org>');
abstract('A Data Driven Testing Framework');
license('perl');
version_from('lib/Test/Base.pm');

requires(qw(
    perl 5.6.1
    Spiffy 0.24
    Test::More 0.54
));

check_nmake();

&WriteAll();
