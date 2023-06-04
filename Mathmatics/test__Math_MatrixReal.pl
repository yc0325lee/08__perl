# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test__Math_MatrixReal.pl
# Description : 
# Author : yc0325lee
# Created : 2019-12-16 23:43:54 by yc0325lee
# Modified : 2019-12-18 23:38:34 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
#use FindBin; use lib $FindBin::Bin;

#for( my $i = 0; $i < @INC; $i++ ) {
#	printf("INC[%d]= %s\n", $i, $INC[$i]);
#}
# INC[0]= D:/00_WORK/08__perl
# INC[1]= C:/strawberry-perl-5.14.2.1-32bit-portable/perl/site/lib
# INC[2]= C:/strawberry-perl-5.14.2.1-32bit-portable/perl/vendor/lib
# INC[3]= C:/strawberry-perl-5.14.2.1-32bit-portable/perl/lib
# INC[4]= .

use Math::MatrixReal;

sub print_matrix {
    @_==1 or die "";
    my $mat = shift;
    $mat->display_precision(0);
    print $mat, "\n";
}

my $mat1 = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [ 1 2 3 ]
    [ 4 5 6 ]
    [ 7 8 9 ]
END_OF_MATRIX
print "mat1=\n"; print_matrix($mat1);
#print Dumper($mat1), "\n";

my $mat2 = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [ 9 8 7 ]
    [ 6 5 4 ]
    [ 3 2 1 ]
END_OF_MATRIX
print "mat2=\n"; print_matrix($mat2);

my $mat3 = Math::MatrixReal->new_from_cols( [ [1, 2, 3] ] );
print "mat3=\n"; print_matrix($mat3);

print "mat1 + mat2 =\n"; print_matrix( $mat1 + $mat2 );
print "mat1 - mat2 =\n"; print_matrix( $mat1 - $mat2 );
print "mat1 * mat2 =\n"; print_matrix( $mat1 * $mat2 );
print "mat1 * mat3 =\n"; print_matrix( $mat1 * $mat3 );

# accessing elements
for( my $row = 1; $row <= 3; $row++ ) {
    for( my $col = 1; $col <= 3; $col++ ) {
        printf("mat1[%d][%d]= %d\n", $row, $col, $mat1->element($row,$col));
    }
}
print "\n";

# processing each element
$mat1 = $mat1->each( sub { (shift) * 2; } );
print "mat1=\n"; print_matrix($mat1);

# swap rows or cols
$mat2->swap_row(1, 2); print "mat2=\n"; print_matrix($mat2);
$mat2->swap_col(2, 3); print "mat2=\n"; print_matrix($mat2);

# minor
for( my $row = 1; $row <= 3; $row++ ) {
    for( my $col = 1; $col <= 3; $col++ ) {
        printf("minor(%d,%d)=\n", $row, $col);
        print $mat1->minor($row,$col), "\n";
    }
}
print "\n";



if( 0 ) {
    # solution for A * x = b
    my $A = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1   2   3  ]
    [  5   7  11  ]
    [ 23  19  13  ]
END_OF_MATRIX
    print $A, "\n";


    my $b = Math::MatrixReal->new_from_string(<<"END_OF_MATRIX");
    [  0 ]
    [  1 ]
    [ 29 ]
END_OF_MATRIX

    my $LR = $A->decompose_LR();
    my ($dim, $x, $B);
    if( ($dim,$x,$B) = $LR->solve_LR($b) )
    {
        my $test = $A * $x;
        print "x = \n$x";
        print "A * x = \n$test";
    }

    my ($A_,$b_) = $A->normalize($b);

    $LR = $A_->decompose_LR();
    if( ($dim,$x,$B) = $LR->solve_LR($b_) )
    {
        my $test = $A * $x;
        print "x = \n$x";
        print "A * x = \n$test";
    }
}
