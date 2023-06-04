# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test.pl
# Description : 
# Author : yc0325lee
# Created : 2020-01-01 17:37:31 by yc0325lee
# Modified : 2020-01-01 17:37:31 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use Inline C => <<'__END_OF_C__';
    int sum(int a, int b)
    {
        return ( a + b );
    }

__END_OF_C__

print sum( 3.0, 4.0), "\n";
