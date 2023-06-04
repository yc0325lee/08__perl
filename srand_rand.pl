# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : rand.pl
# Description : 
# Author : yc0325lee
# Created : 2020-01-02 23:17:09 by yc0325lee
# Modified : 2020-01-02 23:17:09 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;


# hash-table for checking naming conflicts
our $table = {};

# random seed
srand();

# generation & checking
my $i = 0;
my ($first, $second, $name);
while( $i < 100 ) {
	#printf("i=%02d %.2f\n", $i, rand(100));
	$first  = sprintf("%04x", int(rand(2**16)));
	$second = sprintf("%04x", int(rand(2**16)));
	$name = $first . $second;

	while( exists $table->{$name} && defined $table->{$name} ) {
		$first  = sprintf("%04x", int(rand(2**16)));
		$second = sprintf("%04x", int(rand(2**16)));
		$name = $first . $second;
	}

	printf("i=%02d %s\n", $i, $name);

	$first = $second = $name = undef;
	$i++;
}

__END__
$bin
$din
$dout
$fca1
$fca2
$flag
$flipped
$inst
$left
$ref
$row
$str
$xaddr
$xbin
$yaddr
$ybin
@array
@data
@left
@right
