# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# merge.pl
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

while( <run_*.pl> )
{
    #print "file= ", $_, "\n";
	open(my $inFH, '<', $_) or die "";
    while( <$inFH> )
    {
        next if( m/__END__/ );
        print;
    }
    close($inFH) or die "";
}
