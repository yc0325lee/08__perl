# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : GetOpt_Long.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-26 21:22:17 by yc0325lee
# Modified : 2018-12-26 23:09:14 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use Getopt::Long; # GetOpt::Long

# GetOptions
our $all = ''; # default= false
our $verbose = 1; # default= true
our $level = 1; # default= 1
our $name = ''; # default= empty(false)
our $width = 3; # default= 3
our $length = 1.0; # default= 1.0
our @libraries; # default= empty
our %defines = (); # default= empty

GetOptions(
    'all' => \$all,                     # --all
    'verbose!' => \$verbose,            # --verbose(set) or --noverbose(reset)
    'quiet' => sub { $verbose = 0; },   # --quiet
    'level+' => \$level,                # '--level' ---> $level++, '--level --level' ---> $level++; $level++
    'name=s' => \$name,                 # --name yclee
    'width=i' => \$width,               # --width 5
    'length|height=f' => \$length,      # '--length 3.14' or '--height 3.14'
    'library|lib=s' => \@libraries,     # '--lib lib/stdlib --lib lib/extlib'
    'define=s' => \%defines,            # '--define OS=linux --define VENDOR=redhat'
);

#foreach my $name ( sort keys %options ) {
#    printf("%s = %s\n", $name, $options{$name}); # @ARGV is consumed here!
#}
#foreach my $name ( @ARGV ) { print "[warn] opt= $name was not processed!\n"; }
#check_options();
