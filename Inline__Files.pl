# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Inline__Files.pl
# Description : 
# Author : yc0325lee
# Created : 2018-11-22 00:07:20 by prince2103
# Modified : 2018-11-22 00:33:59 by prince2103
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use FindBin;
use lib "$FindBin::Bin/cpan";

use Inline::Files -backup; # for safety

while( <ALPHA> ) { print; }
while( <BETA> ) { print; }
while( <GAMMA> ) { print; }
while( <DELTA> ) { print; }

__ALPHA__
This is ALPHA!

__BETA__
This is BETA!

__GAMMA__
This is GAMMA!

__DELTA__
This is DELTA!

