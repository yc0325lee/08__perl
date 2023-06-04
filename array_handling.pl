# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : array_handling.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-25 23:14:57 by yc0325lee
# Modified : 2018-12-25 23:30:51 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

our @array;

# indexing
@array = qw( 0 1 2 3 4 5 6 7 8 9 ); # 10 elements
print "\@array: @array\n";
print "\$array[0]= ", $array[0], "\n";
print "\$array[\$#array]= ", $array[$#array], "\n";
print "\$array[-1]= ", $array[-1], "\n";
print "\$array[-2]= ", $array[-2], "\n";
print "int(\@array)= ", int(@array), "\n";
print "\$#array= ", $#array, "\n";
print "\$array[3..5]= ", join(' ', @array[3..5]), "\n"; # slice
print "sliced= ", join(' ', @array[0 .. $#array-1]), "\n"; # slice
print "\n";

# call by value
sub do_call_by_value {
    my @arguments = @_;
    for(my $i=0; $i<@arguments; $i++) { $arguments[$i] *= 10; }
}

# call by reference - 0
sub do_call_by_reference_0 {
    for(my $i=0; $i<@_; $i++) { $_[$i] *= 10; }
}

# call by reference - 1
sub do_call_by_reference_1 {
    my $aref = shift;
    for(my $i=0; $i<@{$aref}; $i++) { $aref->[$i] *= 10; }
}

sub shift2 ( \@ ) { return splice( @{$_[0]}, 0, 2 ); }
sub pop2 ( \@ ) { return splice( @{$_[0]}, -2, 2 ); }
# shift-N
# @shifted = splice(@array, 0, $n);
# pop-N
# @popped = splice(@array, -$n);
# @popped = splice(@array, int(@array)-$n, $n);


#@array = qw( a b c d e f g h i z k l m n o p q r s t u v w x y z );
@array = qw( 0 1 2 3 4 5 6 7 8 9 ); print "\@array: @array\n";
do_call_by_value(@array);              print "\@array: @array\n";
do_call_by_reference_0(@array);        print "\@array: @array\n";
do_call_by_reference_1(\@array);       print "\@array: @array\n";

my @shifted = shift2( @array );
my @popped = pop2( @array );
print "\@shifted \@array \@popped: @shifted | @array | @popped\n";

@shifted = splice(@array, 0, 2); # shift2()
@popped = splice(@array, -2); # pop2() == splice(@array, int(@array)-2, 2)
print "\@shifted \@array \@popped: @shifted | @array | @popped\n";

my $shifted = shift(@array); # shift-1
my $popped = pop(@array); # pop-1
print "\@shifted \@array \@popped: $shifted | @array | $popped\n";
unshift(@array, $shifted);
push(@array, $popped);
print "\@array: @array\n";

# sorting
# my @sorted = sort { $a <=> $b } @unsorted;
# Circular list
my @circular = qw( 0 1 2 3 4 5 6 7 8 9 );
unshift(@circular, pop(@circular)); # 9 0 1 2 3 4 5 6 7 8 -> clockwise
push(@circular, shift(@circular)); # 0 1 2 3 4 5 6 7 8 9 -> counter-clockwise


__END__
@array: 0 1 2 3 4 5 6 7 8 9
$array[0]= 0
$array[$#array]= 9
$array[-1]= 9
$array[-2]= 8
int(@array)= 10
$#array= 9
$array[3..5]= 3 4 5
sliced= 0 1 2 3 4 5 6 7 8

@array: 0 1 2 3 4 5 6 7 8 9
@array: 0 1 2 3 4 5 6 7 8 9
@array: 0 10 20 30 40 50 60 70 80 90
@array: 0 100 200 300 400 500 600 700 800 900
@shifted @array @popped: 0 100 | 200 300 400 500 600 700 | 800 900
@shifted @array @popped: 200 300 | 400 500 | 600 700
@shifted @array @popped: 400 |  | 500
@array: 400 500
