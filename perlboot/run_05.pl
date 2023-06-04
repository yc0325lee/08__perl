# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 05. Invoking a barnyard - (2)
#   - Class->method(@args);
#     ; attempts to invoke subroutine Class::method as follows:
#     ; Class::method("Class", @args);
#     ; First parameter is generally class name.
#   - Re-writed version using above theorem.
#   - Still, there are common codes!
#   - But we can factor out the commonalities more and more.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


sub Cow::speak {
    my $class = shift;
    print "a $class goes moooo!\n";
}
sub Horse::speak {
    my $class = shift;
    print "a $class goes neigh!\n";
}
sub Sheep::speak {
    my $class = shift;
    print "a $class goes baaaah!\n";
}

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


__END__
