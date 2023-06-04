# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 08. Overriding the methods - (1)
#   - 'Mouse' added for special handling of speak().
#   - But 'Mouse' was duck-typed because there is no need to have @ISA.
#   - The duplication of code in speak() is not good.
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
    sub sound { return "squeak"; } # If something or someone squeaks, they make a
                                   # short, high-pitched sound.

                              # This package has speak() subroutine!
    sub speak {               # speak() -> overriden!
        my $class = shift;    # There is still commonality!
        print "a $class goes ", $class->sound, "!\n";
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}

__END__
