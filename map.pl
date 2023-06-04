# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : map.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-16 22:04:58 by yc0325lee
# Modified : 2018-12-21 00:54:51 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


my @numbers = ( 1, 2, 3, 4, 5 ); print "@numbers\n";
my @squares = map { $_ * $_ } @numbers; print "@squares\n\n";

my @numbers = ( 65, 66, 67, 68, 69 ); print "@numbers\n";
my @chars = map { chr($_) } @numbers; print "@chars\n\n";




# -------------------------------------
my %hash0 = (
    name => 0,
    age => 1,
    gender => 2,
    company => 3,
);
print_hash(\%hash0);

my %hash1 = map { $_ => $hash0{$_} * $hash0{$_} } keys %hash0;
print_hash(\%hash1);

my $href1;
foreach my $key ( keys %hash0 ) {
    $href1->{$key} = 1;
}
print_hash($href1);

my $href2;
%{$href2} = map { $_ => 1 } keys %hash0;
print_hash($href2);


# -------------------------------------
sub print_hash {
    my $href = shift;
    foreach my $key ( sort keys %{$href} ) {
        printf("%s => %d\n", $key, $href->{$key});
    }
    printf("\n");
}

