# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : glob.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-26 23:15:48 by yc0325lee
# Modified : 2018-12-26 23:18:18 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

while( glob("*.pl *.pm") ) {
    print $_, "\n";
}

while( glob(".* *") ) { # all files
    if( 0 ) { }
    elsif( -d ) {
        # directory
    }
    elsif( -f ) {
        # file
    }
}
