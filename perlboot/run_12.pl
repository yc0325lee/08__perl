# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 12. A horse is a horse, of course of course -- or is it?
#   - How do we capture the distinctions of an individual horse?
#   - --> instance data
#   - Any reference can be a instance of class.
#   - bless(REF,CLASSNAME)
#     ; the thingy referenced by REF is now an object in the CLASSNAME package
#     ; returns the 'blessed' reference REF
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


__END__
