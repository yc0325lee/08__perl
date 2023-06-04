# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 03. Introducing the method incocation arrow - (2)
#   - The package name has been parted from the subroutine name.
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

my $a = 'Cow';
my $b = 'Horse';
my $c = 'Sheep';

$a->speak(); # Cow::speak("Cow");
$b->speak(); # Horse::speak("Horse");
$c->speak(); # Sheep::speak("Sheep");


__END__
