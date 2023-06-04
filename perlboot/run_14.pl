# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 14. How to build a horse
#   - Introducing constructor.
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
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
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
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
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
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
}

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->new("Mr.Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";


__END__
