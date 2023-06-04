# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : gaussian_elimination.pl
# Description : 
# Author : yc0325lee
# Created : 2019-12-26 00:02:14 by yc0325lee
# Modified : 2019-12-26 00:02:14 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use Math::MatrixReal;

sub print_matrix {
    @_==1 or die "";
    my $mat = shift;
    $mat->display_precision(3);
    print $mat, "\n";
}

my $A = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  2  1  1 ]
    [  4 -6  0 ]
    [ -2  7  2 ]
END_OF_MATRIX
print "A=\n"; print_matrix($A);

my $b = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  5 ]
    [ -2 ]
    [  9 ]
END_OF_MATRIX
print "b=\n"; print_matrix($b);

my $E = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1  0  0 ]
    [ -2  1  0 ]
    [  0  0  1 ]
END_OF_MATRIX
print "E=\n"; print_matrix($E);

my $F = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1  0  0 ]
    [  0  1  0 ]
    [  1  0  1 ]
END_OF_MATRIX
print "F=\n"; print_matrix($F);

my $G = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1  0  0 ]
    [  0  1  0 ]
    [  0  1  1 ]
END_OF_MATRIX
print "G=\n"; print_matrix($G);

my $H = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  0.5  0.0  0.0 ]
    [  0.0  1.0  0.0 ]
    [  0.0  0.0  1.0 ]
END_OF_MATRIX
print "H=\n"; print_matrix($H);

my $I = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1.000  0.000  0.000 ]
    [  0.000 -0.125  0.000 ]
    [  0.000  0.000  1.000 ]
END_OF_MATRIX
print "I=\n"; print_matrix($I);

my $J = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1.000 -0.500  0.000 ]
    [  0.000  1.000  0.000 ]
    [  0.000  0.000  1.000 ]
END_OF_MATRIX
print "J=\n"; print_matrix($J);

my $K = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1.000  0.000 -0.375 ]
    [  0.000  1.000  0.000 ]
    [  0.000  0.000  1.000 ]
END_OF_MATRIX
print "K=\n"; print_matrix($K);

my $L = Math::MatrixReal->new_from_string( <<"END_OF_MATRIX" );
    [  1.000  0.000  0.000 ]
    [  0.000  1.000 -0.250 ]
    [  0.000  0.000  1.000 ]
END_OF_MATRIX
print "L=\n"; print_matrix($L);


# -------------------------------------
# gaussian elimination
# ; making LHS a identity matrix
my $left = $A; # left hand side
my $right = $b; # right hand side

print "# step 0\n";
print "left=\n"; print_matrix($left);
print "right=\n"; print_matrix($right);

print "# step 1\n";
print "left=\n"; print_matrix($E * $left);
print "right=\n"; print_matrix($E * $right);

print "# step 2\n";
print "left=\n"; print_matrix($F * $E * $left);
print "right=\n"; print_matrix($F * $E * $right);

print "# step 3\n";
print "left=\n"; print_matrix($G * $F * $E * $left);
print "right=\n"; print_matrix($G * $F * $E * $right);

print "# step 4\n";
print "left=\n"; print_matrix($H * $G * $F * $E * $left);
print "right=\n"; print_matrix($H * $G * $F * $E * $right);

print "# step 5\n";
print "left=\n"; print_matrix($I * $H * $G * $F * $E * $left);
print "right=\n"; print_matrix($I * $H * $G * $F * $E * $right);

print "# step 6\n";
print "left=\n"; print_matrix($J * $I * $H * $G * $F * $E * $left);
print "right=\n"; print_matrix($J * $I * $H * $G * $F * $E * $right);

print "# step 7\n";
print "left=\n"; print_matrix($K * $J * $I * $H * $G * $F * $E * $left);
print "right=\n"; print_matrix($K * $J * $I * $H * $G * $F * $E * $right);

print "# step 8\n";
print "left=\n"; print_matrix($L * $K * $J * $I * $H * $G * $F * $E * $left);
print "right=\n"; print_matrix($L * $K * $J * $I * $H * $G * $F * $E * $right);

# now LHS is an identity matrix
# -> RHS is the solution!
