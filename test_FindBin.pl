# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test_FindBin.pl
# Description : 
# Author : yc0325lee
# Created : 2018-11-21 23:50:27 by prince2103
# Modified : 2018-12-26 21:09:36 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use FindBin;
use lib $FindBin::Bin; # Do this instead of 'use lib "."'!

foreach my $path (
	$FindBin::Bin,
	$FindBin::Script,
	$FindBin::RealBin,
	$FindBin::RealScript,
) {
	printf("= %s\n", $path);
}
