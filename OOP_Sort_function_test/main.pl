# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# main.pl
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use DerivedClass_A;
use DerivedClass_B;

# sort criteria
foreach my $addonFile (qw(
    DerivedClass__sort_criteria.pl
)) {
    if( ! -e $addonFile ) {
        confess "[ERR ] $addonFile not exist!";
    }
    print "[INFO] Do-ing $addonFile ...\n";
    #do $addonFile or confess "[ERR ] cannot do $addonFile: $!"; # cannot see lexicals in this file!
    eval `cat $addonFile` or confess "[ERR ] cannot eval $addonFile: $@"; # addonFile compiled in this scope! -> must use this for $a & $b
}

my $aref_a = [
    DerivedClass_A->new('a0', 0, 4),
    DerivedClass_A->new('a1', 1, 3),
    DerivedClass_A->new('a2', 2, 2),
    DerivedClass_A->new('a3', 3, 1),
    DerivedClass_A->new('a4', 4, 0),
];

my $aref_b = [
    DerivedClass_B->new('b0', 0, 4),
    DerivedClass_B->new('b1', 1, 3),
    DerivedClass_B->new('b2', 2, 2),
    DerivedClass_B->new('b3', 3, 1),
    DerivedClass_B->new('b4', 4, 0),
];

# polymorphism
foreach my $object ( @{$aref_a}, @{$aref_b} ) {
    $object->print();
}

our $sortFunc;

# sort - a
print "\n# sort test for DerivedClass_A\n";
$sortFunc = DerivedClass_A->sort_criterion();
foreach my $object ( sort $sortFunc @{$aref_a} ) {
    $object->print();
}

# sort - b
print "\n# sort test for DerivedClass_B\n";
$sortFunc = DerivedClass_B->sort_criterion();
foreach my $object ( sort $sortFunc @{$aref_b} ) {
    $object->print();
}

# sort - a & b together
print "\n# sort test for DerivedClass_A & DerivedClass_B\n";
$sortFunc = BaseClass->sort_criterion();
foreach my $object ( sort $sortFunc @{$aref_b}, @{$aref_a} ) {
    $object->print();
}

