# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 07. Inheriting the windpipes
#   - Definition of common subroutine package called 'Animal' added.
#   - Can share common 'speak()' through 'inheritance'!
#   - '@ISA' needed for inheritance.
#   - '@ISA' must be package-global in each class.
#   - recursive, depth-first, left-to-right search in each @ISA
#   - How to declare '@ISA'
#     ; @Cow::ISA = qw(Animal);
#     ; our @ISA = qw(Animal);
#     ; use vars qw(@ISA); @ISA = qw(Animal);
#     ; use base qw(Animal);
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
    package Cow;                  # ------------------------------------ #
    our @ISA = qw(Animal);        # -> Cow "is a" Animal!                #
    sub sound { return "moooo"; } # Recursive,depth-first,left-to-right! #
}                                 # ------------------------------------ #
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{                                  # ----------------------------------- #
    package Sheep;                 # 3 ways to make @ISA package global! #
    our @ISA = qw(Animal);         # - @Sheep::ISA = qw(Animal);         #
    sub sound { return "baaaah"; } # - our @ISA = qw(Animal);            #
}                                  # - use vars qw(@ISA);                #
                                   # ----------------------------------- #

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}

# o flow of method invocation
# Cow->speak();
# Cow::speak("Cow");    -> no definition of 'speak()'!
#                       -> Searches '@ISA' array!
#                       -> 'speak()' found in 'Animal' package!
# Animal::speak("Cow"); -> 'Animal::speak()' is called!


__END__
