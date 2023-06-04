# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 10. Overriding the methods - (2)
#   - The duplication of code in speak() is not good.
#   - So the Animal::speak() invoked directly.
#   - But invoking Animal::speak() directly is very bad
#     from the point of inheritance mechanism & hard-coded 'Animal'!
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->Animal::speak();
    #   -----------------------> See here!
    #   Start with 'Animal' to find speak()!
    #   Use 'Animal' inheritance chain if not found there!
    #   Still, 'Animal' hard-coded!
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}

__END__
