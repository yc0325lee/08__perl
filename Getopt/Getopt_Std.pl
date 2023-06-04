# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : GetOpt_Std.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-26 21:22:17 by yc0325lee
# Modified : 2018-12-26 22:14:51 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use Getopt::Std; # GetOpt::Std

# getopt()
our %options;
getopt('abc', \%options); # all opts take an argument!
foreach my $name ( sort keys %options ) {
    printf("%s = %s\n", $name, $options{$name});
}
foreach my $name ( @ARGV ) { print "[warn] option= $name was not processed!\n"; }

# -------------------------------------
# getopts()
# usage
# ; perl GetOpt_Std.pl [-a] [-b] [-i input.txt] [-o output.txt]
# ; perl GetOpt_Std.pl [-ab] [-i input.txt] [-o output.txt]
# ; perl GetOpt_Std.pl [-ab] [-iinput.txt] [-ooutput.txt]
our %options;
getopts('abi:o:', \%options); # x: takes an argument & unknown opt '-x' will be warned!
foreach my $name ( sort keys %options ) {
    printf("%s = %s\n", $name, $options{$name}); # @ARGV is consumed here!
}
foreach my $name ( @ARGV ) { print "[warn] opt= $name was not processed!\n"; }
#check_options(\%options);
