# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 02. Introducing the method incocation arrow - (1)
#   - Class->method() invokes subroutine method() in package Class.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}

Cow->speak(); # Cow::speak("Cow");
Horse->speak(); # Horse::speak("Horse");
Sheep->speak(); # Sheep::speak("Sheep");


__END__
