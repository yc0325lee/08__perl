# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : main.pl
# Description : 
# Author : yc0325lee
# Created : 2020-09-29 10:57:46 by lee2103
# Modified : 2020-09-29 10:57:46 by lee2103
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use File::Basename qw( basename dirname );


# command line arguments
if( @ARGV == 0 ) {
    print STDERR "[info] reading input from STDIN ...\n";
}
elsif( @ARGV > 1 ) {
    my $cmd = basename($0);
    print "\nUsage(1) -> perl $cmd input.txt\n"; # from input-file
    print "Usage(2) -> cat input.txt | perl $cmd\n"; # from stdin
    exit(1);
}

my $inFH;
if( @ARGV ) {
    my $inFile = $ARGV[0];
    open($inFH, '<', $inFile) or die "[error] cannot open $inFile file!";
}
else {
    $inFH = *STDIN; # from stdin
}

while( <$inFH> )
{
    chomp;
    printf("%d: %s\n", $., $_);
}
