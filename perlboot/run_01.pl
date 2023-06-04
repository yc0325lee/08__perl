# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 01. If we could talk to the animals... - (2)
#   - Symbolic coderef de-referencing used.
#   - This style is not recommended.
#   - This may not work with 'use strict' pragma.
#   - 'no strict ref' pragma is needed!
# ----------------------------------------------------------------------------
#use strict;
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

# Pasture is land with grass growing on it for farm animals to eat.
my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    &{ $animal . "::speak" };
    #  -------------------
    #   |
    # This is a string!
}

print "\n";

# same!
&{"Cow::speak"};
&{"Cow::speak"};
&{"Horse::speak"};
&{"Sheep::speak"};
&{"Sheep::speak"};


__END__
