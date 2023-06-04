# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : binary.pl
# Description : 
# Author : yc0325lee
# Created : 2020-03-11 22:13:39 by yc0325lee
# Modified : 2020-03-11 22:13:39 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

for( my $i = 0; $i < 16384; $i++ )
{
    printf("%04d = %14b\n", $i, $i);
}

