# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : INC.pl
# Description : 
# Author : yc0325lee
# Created : 2019-12-16 22:28:08 by yc0325lee
# Modified : 2019-12-16 23:31:29 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

for( my $i = 0; $i < @INC; $i++ )
{
    printf("INC[%d]= %s\n", $i, $INC[$i]);
}

# INC[0]= D:/00_WORK/08__perl
# INC[1]= C:/strawberry-perl-5.30.1.1-32bit-portable/perl/site/lib
# INC[2]= C:/strawberry-perl-5.30.1.1-32bit-portable/perl/vendor/lib
# INC[3]= C:/strawberry-perl-5.30.1.1-32bit-portable/perl/lib
