# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 11. The super way of doing things
#   - 'Animal' was replaced with 'SUPER' keyword!
#   - SUPER::speak means look in the current package's @ISA
#     for a class that implements speak, and invoke the first one found.
#   - Syntax summary
#     Class->method(@args);               |
#     my $a = "Class"; $a->method(@args); | -> Equivalent!
#     Class::method("Class", @args);      |
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
        $class->SUPER::speak();
    #   -----------------------> See here!
    #   the contents of Mouse's @ISA are used for the search,
    #   beginning with $ISA[0], $ISA[1], ...
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


__END__
