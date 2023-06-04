# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : main_Complex.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-16 22:47:30 by yc0325lee
# Modified : 2019-12-20 00:12:00 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use FindBin; use lib $FindBin::Bin;
use Complex;

my $x = Complex->new();
my $y = Complex->new(3, 4);
my $z = Complex->new(4.0, 7.0);

my $aref = [ $x, $y, $z ];

printf("%s= %.3f , %.3f\n", $z, $z->Real(), $z->Imag());


# polymorphism
#for(my $i = 0; $i < @{$aref}; $i++) {
#    $aref->[$i]->print();
#}
