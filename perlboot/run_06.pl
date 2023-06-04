# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 06. Calling a second method to simplify things
#   - Class-name removed from subroutine-name by using 'package'.
#   - Curly braces used for separate name-spaces.
#   - sound() added to factor out the commonalities.
#   - Aha! Now, all classes have same 'speak()' subroutine!
#   - Commonalities on 'speak()' subroutine!
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Cow;
    sub sound { return "moooo"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Horse;
    sub sound { return "neigh"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Sheep;
    sub sound { return "baaaah"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


__END__
