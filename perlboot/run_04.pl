# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 04. Invoking a barnyard - (1)
#   - It'd be nice if we could factor out the commonality.
#   - Class->method(@args);
#     ; attempts to invoke subroutine Class::method as follows:
#     ; Class::method("Class", @args);
#   - And look at the common codes!
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

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


__END__
