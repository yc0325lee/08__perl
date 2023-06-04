# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : array_hash_slice.pl
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

# -------------------------------------
# array slicing
{
    my @array = qw( 0 1 2 3 4 5 6 7 8 9 ); # 10 elements
    my ($first, $last) = @array[0,-1];
    print "first= $first, last= $last\n";

    my @temp = @array[ 5 .. 9 ];
    print "\@temp= @temp\n";
}


# -------------------------------------
# hash slicing
{
    #my %hash = (
    #    zero  => 0,
    #    one   => 1,
    #    two   => 2,
    #    three => 3,
    #    four  => 4,
    #    five  => 5,
    #    six   => 6,
    #    seven => 7,
    #    eight => 8,
    #    nine  => 9,
    #);
    my %hash; # declaration assignment not allowed!
    @hash{ 'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine' }
        = qw( 0 1 2 3 4 5 6 7 8 9 ); # 10 elements
    print Dumper( \%hash ), "\n";

    my ($first, $last) = @hash{'zero', 'nine'};
    print "first= $first, last= $last\n";

    # process odd ones only
    foreach my $val ( @hash{qw( one three five seven nine )} ) {
        print "val= $val\n";
    }
}
