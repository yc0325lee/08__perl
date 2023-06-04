# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : use_File_Basename.pl
# Description : 
# Author : yc0325lee
# Created : 2019-09-17 23:06:11 by yc0325lee
# Modified : 2019-09-17 23:12:53 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;
use File::Basename;

#($name,$path,$suffix) = fileparse($fullname,@suffixlist);
#$name = fileparse($fullname,@suffixlist);
#$basename = basename($fullname,@suffixlist);
#$dirname  = dirname($fullname);

while( glob("*.pl" ) )
{
    print $_, "\n";
    my ($name, $dir, $suffix) = fileparse($_, qr/\.[^.]+/);
    print "# name= ", $name, "\n";
    print "# dir= ", $dir, "\n";
    print "# suffix= ", $suffix, "\n\n";
}
