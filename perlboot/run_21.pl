# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 21. A horse of a different color
#   - adding methods that get and set the colors.
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
    sub default_color { return "brown"; }
    sub color { # accessor
        my $this = shift;
        return $this->{COLOR};
    }
    sub set_color { # accessor
        my $this = shift;
        my $color = shift;
        $this->{COLOR} = $color;
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

my $horse = Horse->new("Mr.Edie");
$horse->eat("hay");
print "The color of ", $horse->name(), " : ", $horse->color(), "\n";
$horse->set_color("black-and-white");
printf("(The color was changed.)\n");
print "The color of ", $horse->name(), " : ", $horse->color(), "\n";

Sheep->eat("grass");
my $sheep = Sheep->new("Mrs.Jane");
print "The color of ", $sheep->name(), " : ", $sheep->color(), "\n";


__END__
