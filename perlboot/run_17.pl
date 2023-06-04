# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 17. Making a method work with either classes or instances
#   - a method to detect if it is being called on a class or called on an
#     instance.
#   - ref(EXPR)
#     ; Returns a non-empty string if EXPR is a reference, the empty string
#       otherwise.
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
print Horse->name(), " says ", $horse->sound(), ".\n";  # "Any Horse"
print $horse->name(), " says ", $horse->sound(), ".\n"; # "Mr.Ed"

$horse->speak(); # Mr.Ed goes neigh


__END__
