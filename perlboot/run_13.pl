# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 13. Invoking an instance method
#   - The difference between a class method and an instance method
#     ; Class-method : the first parameter is a class name.
#     ; Instance-method : the first parameter is an instance(blessed reference).
#   - When an instance method is invoked:
#     ; Perl takes the class in which the instance was blessed
#     ; uses that class to locate the subroutine
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
        print "[but you can barely hear it!]\n";
    }
}

my $name = "Mr.Ed";
my $horse = \$name;     # Reference to $name
bless($horse, 'Horse'); # Now, $horse is blessed reference!
                        # That is, an instance of Horse!
print "The content of \$horse : ", ${$horse}, "\n"; # Mr.Ed
print "ref(\$horse) : ", ref($horse), "\n";

my $noise = $horse->sound(); # --> neigh
print "noise : ", $noise, "\n";
print "1. ", $horse->sound(),      "\n"; # instance method invoked!
print "2. ", Horse::sound($horse), "\n"; # Same as above!
print "3. ", Horse->sound(), "\n"; # class method invoked!


__END__
