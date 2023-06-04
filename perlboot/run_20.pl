# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 20. More interesting instances - (2)
#   - Sheep::new() removed and Animal::new() modified to handle
#     the special case.
#   - Animal::default_color() added to keep from having to define
#     default_color() for each derived class.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub default_color { return "brown"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        my $this = {
            NAME => $name,
            COLOR => $class->default_color(),
        };
        bless($this, $class);
        return $this;
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? $either->{NAME} : "Any " . $either;
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
    sub color {
        my $this = shift;
        return $this->{COLOR};
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
    sub default_color { return "white"; }
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

my $horse = Horse->new("Mr.Edie"); #
$horse->eat("hay");                # -> Animal::eat($horse, "hay");
print $horse->{COLOR}, "\n";       # brown

Sheep->eat("grass");                # --> Animal::eat('Sheep', "grass");
my $sheep = Sheep->new("Mrs.Jane"); #
print $sheep->{COLOR}, "\n";        # white


__END__
