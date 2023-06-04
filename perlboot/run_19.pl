# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 19. more interesting instances - (1)
#   - Use blessed hash references to store more instance data.
#   - Overriding new() to handle constructing a sheep with a certain color.
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
        my $this = { NAME => $name }; # hash reference -> object
        bless($this, $class);
        return $this;
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? $either->{NAME} : "Any " . $either;
        #                     -------                    -------
        #                     instance                    class
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
    sub default_color { return "white"; }
    sub new { # constructor overriding
        my $class = shift;
        my $name = shift;
        my $this = $class->SUPER::new($name);
        #          -------------------------
        #          Animal's constructor is being invoked!

        $this->{COLOR} = $class->default_color(); # new data added!
        return $this;
        # No need to bless($this,$class) cuz this is being done
        # up in the inheritace hierarchy!
    }
    sub color {
        my $this = shift;
        return $this->{COLOR};
    }
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

my $sheep = Sheep->new("Mrs.Jane");
printf("%s's color -> %s\n", $sheep->name(), $sheep->color());


__END__
