# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : sum.pl
# - author : yc0325lee
# - created : 2022-11-10 23:48:06 by yc032
# - modified : 2022-11-10 23:48:06 by yc032
# - description : 
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;


my $sum = 0;
for(my $i = 1; $i <= 10; $i++ ) {
    $sum += $i;
}

printf("sum= %d\n", $sum);
