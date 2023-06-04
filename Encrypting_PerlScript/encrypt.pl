# ----------------------------------------------------------------------------
# o encrypt.pl
# o date : 2013/11/30
# o character class for identifier
#   [_a-zA-Z0-9]  <--> [^_a-zA-Z0-9]
# ----------------------------------------------------------------------------
use strict;
use warnings;

# hash-table for checking naming conflicts
our $renameHashRef = {};
our $compareHashRef = {};

# random seed
srand();

# build renameHashRef
while( <DATA> ) {
	chomp;

	my $type; my $prefix;

	s/^([\$\@\%])//;
	if( defined $1 ) { $prefix = $1; }
	else             { $prefix = ''; }

	my $from = $_;
	my $to = '_' . getHexCode();
	#printf("[DBG] %s -> %s\n", $from, $to);
	$renameHashRef->{$from} = $to;
}

# perl-script translation
while( <> ) {
	foreach my $from ( keys %{$renameHashRef} ) {
		my $to = $renameHashRef->{$from};
		s/([^_a-zA-Z0-9])\Q$from\E([^_a-zA-Z0-9])/$1$to$2/g;
	}
	print;
}


sub getHexCode {
	@_==0 or die "";
	my ($first, $second, $generated);

	$first  = sprintf("%04x", int(rand(2**16)));
	$second = sprintf("%04x", int(rand(2**16)));
	$generated = $first . $second;

	while( exists $compareHashRef->{$generated} &&
			defined $compareHashRef->{$generated} ) {
		$first  = sprintf("%04x", int(rand(2**16)));
		$second = sprintf("%04x", int(rand(2**16)));
		$generated = $first . $second;
	}

	$compareHashRef->{$generated} = 1; # defined!

	return $generated;
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
$mem
$backup
$words
$bpw
$mux
$bpwl
$bpwr
$rows
$cols
$cols_left
$cols_right
$width
$xwidth
$ywidth
$fca1Width
$fca2Width
