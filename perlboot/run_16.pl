# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 16. Inheritting the constructor and instance method
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
        my $this = shift;
        return ${$this};
    }
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

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->new("Mr.Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";

# But how about calling speak()?
$horse->speak(); # This will be a problem,
                 # a Horse=SCALAR(0xaca42ac) goes neigh!
                 # because speak() is class-only method!
                 # Let's modify speak()!

__END__
Mr.Ed says neigh.
a Horse=SCALAR(0x140cc74) goes neigh!
