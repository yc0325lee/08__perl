# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 18. Adding parameters to a method
#   - Let's train our animals to eat.
#   - An instance method with parameters gets invoked with the instance.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? ${$either} : "Any " . $either;
        #                     ----------            -------
        #                      instance              class
    }
    sub speak {
        my $either = shift; # class or instance
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
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

my $horse = Horse->new("Mr.Ed");
$horse->eat("hay");  # -> Animal::eat($horse, "hay");
                     #    Mr. Ed eats hay.
Sheep->eat("grass"); # -> Animal::eat('Sheep', "grass");
                     #    Any Sheep eats grass.


__END__
