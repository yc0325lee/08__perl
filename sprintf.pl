# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : sprintf.pl
# Description : 
# Author : yc0325lee
# Created : 2019-12-25 18:46:00 by yc0325lee
# Modified : 2019-12-25 18:46:00 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

printf("% #5d\n", 256);
printf("% #5d\n", -255);
