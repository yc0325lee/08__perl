# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# Trapping Undefined Function Calls with AUTOLOAD
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

our $AUTOLOAD;

sub AUTOLOAD {
    my $color = $AUTOLOAD;
    $color =~ s/.*:://;
    return "<FONT COLOR='$color'>@_</FONT>";
}

my @colors = qw(red blue green yellow orange purple violet);
foreach my $name ( @colors ) {
    no strict 'refs';
    &{$name}($name);
#   ---------------
#   what is this? :-(
}
