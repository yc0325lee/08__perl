# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Getopt.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-26 23:02:13 by yc0325lee
# Modified : 2018-12-26 23:09:34 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

# -------------------------------------
# Getopt::Std
use Getopt::Std; # GetOpt::Std

# getopt()
our %options;
getopt('abc', \%options); # all opts take an argument!
foreach my $name ( sort keys %options ) {
    printf("%s = %s\n", $name, $options{$name});
}
foreach my $name ( @ARGV ) { print "[warn] option= $name was not processed!\n"; }

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
check_options(\%options);


# -------------------------------------
# Getopt::Long
use Getopt::Long; # GetOpt::Long

# GetOptions
our $all = ''; # default= false
our $verbose = ''; # default= false
our $level = 1; # default= 1
our $name = ''; # default= empty(false)
our $width = 3; # default= 3
our $length = 1.0; # default= 1.0
our @libraries; # default= empty
our %defines = {}; # default= empty

GetOptions(
    'all' => \$all,          # --all
    'verbose!' => \$verbose, # --verbose(set) or --noverbose(reset)
    'quiet' => sub { $verbose = 0; }, # --quiet
    'level+' => \$level,     # '--level' ---> $level++, '--level --level' ---> $level++; $level++
    'name=s' => \$tag,        # --name yclee
    'width=i' => \$width,      # --width 5
    'length|height=f' => \$length, # '--length 3.14' or '--height 3.14'
    'library|lib=s' => \@libraries, # '--lib lib/stdlib --lib lib/extlib'
    'define=s' => \%defines, # '--define OS=linux --define VENDOR=redhat'
);

foreach my $name ( @ARGV ) { print "[warn] opt= $name was not processed!\n"; }
check_options(); # checking global variables
