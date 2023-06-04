######################################################################
# COLUMN-REDUNDANCY VECTOR IMPLEMENTATION
# - v0.10 :	'_39747896' inserted in write2mem() 09/12/05
# - v0.20 :	shift_by_fca() added 09/12/05
######################################################################
use strict;
use warnings;
use POSIX qw(ceil);
use Data::Dumper;
use vars qw(
	$_e41ef2bc
	$_501a52b4
	$_57ae8bc2 $_6a661234 $_b27a61fe $_1c52a516 $_2c72d6c2
	$_a6869b70 $_9ef24114 $_da987cb0 $_ff529e12
	$_a9c03b46 $_a3e4e1e6 $_d22e4cc8
	$_9b801120 $_32c8cea0
);
$Data::Dumper::Indent = 1;

use integer;
my $_16f4392e = 'spsram_ulp_256x4m8';
die "" unless( $_16f4392e =~ m/(\d+)x(\d+)m(\d+)/ );
$_57ae8bc2 = $1;
$_6a661234 = $2;
$_b27a61fe = $3;
$_1c52a516 = $_6a661234 / 2;
$_2c72d6c2 = $_6a661234 - $_1c52a516;
$_a6869b70 = $_57ae8bc2 / $_b27a61fe;
$_9ef24114 = $_6a661234 * $_b27a61fe;
$_da987cb0 = $_1c52a516 * $_b27a61fe;
$_ff529e12 = $_2c72d6c2 * $_b27a61fe;
no integer;
$_a9c03b46 = ceil( log($_57ae8bc2)/log(2.0) );
$_d22e4cc8 = log($_b27a61fe)/log(2.0);
$_a3e4e1e6 = $_a9c03b46 - $_d22e4cc8;
$_9b801120 = ceil( log($_da987cb0/4)/log(2.0) );
# FCA1[] : 0 ~ (_da987cb0/4-1)
$_32c8cea0 = ceil( log($_ff529e12/4)/log(2.0) );
# FCA2[] : 0 ~ (_ff529e12/4-1)

# WRITE ZERO TO MEMORY
print ">>> WRITE ZERO TO MEMORY <<<\n";
write2mem(\$_e41ef2bc,0);

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$_a6869b70-1; $i>=0; $i--) { # Be cautious the index!
	my $_63825b7c = mem2str(\$_e41ef2bc, $i);
	print $_63825b7c, "\n";
}

# WRITE PATTERN TO MEMORY
print ">>> WRITE PATTERN TO MEMORY <<<\n";
write2mem(\$_e41ef2bc,2);

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$_a6869b70-1; $i>=0; $i--) { # Be cautious the index!
	my $_63825b7c = mem2str(\$_e41ef2bc, $i);
	print $_63825b7c, "\n";
}

# MEM --> BACKUP
print ">>> MEM --> BACKUP <<<\n";
for(my $i=$_a6869b70-1; $i>=0; $i--) { # Be cautious the index!
	my $_63825b7c = mem2str(\$_e41ef2bc, $i);
	str2mem(\$_501a52b4, $_63825b7c, $i);
}

# SHIFTING BY FCA
print ">>> SHIFTING BY FCA <<<\n";
my ($_dfda2564, $_394c3b68);
for(my $i=$_a6869b70-1; $i>=0; $i--) { # Be cautious the index!
	$_dfda2564 = $i % ($_da987cb0/4);
	$_394c3b68 = $i % ($_ff529e12/4);
	shift_by_fca(\$_e41ef2bc, $i, $_dfda2564, $_394c3b68);
}

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$_a6869b70-1; $i>=0; $i--) { # Be cautious the index!
	my $_63825b7c = mem2str(\$_e41ef2bc, $i);
	print $_63825b7c, "\n";
}

# PRINT PHYSICAL ARRAY OF BACKUP
print ">>> PRINT PHYSICAL ARRAY OF BACKUP <<<\n";
for(my $i=$_a6869b70-1; $i>=0; $i--) { # Be cautious the index!
	my $_63825b7c = mem2str(\$_501a52b4, $i);
	print $_63825b7c, "\n";
}

# READ FROM MEMORY
print ">>> READ FROM MEMORY <<<\n";
read2mem(\$_e41ef2bc, 2);

# READ FROM BACKUP
print ">>> READ FROM BACKUP <<<\n";
read2mem(\$_501a52b4, 2);

######################################################################
# SUBROUTINES
######################################################################
sub write2mem {
	@_==2 or die "";
	my $_89ba2b2a = shift; # reference to reference
	my $_39747896 = shift;
	for(my $i=0; $i<$_57ae8bc2; $i++) {
		my $_28ce9652 = sprintf("%.*b", $_a9c03b46, $i);
		die "" unless( $_28ce9652 =~ m/([01]{$_a3e4e1e6})([01]{$_d22e4cc8})/ );
		my $_1aa89330 = $1;
		my $_84f24710 = $2;
		my $_35d2c36c = oct("0b$_1aa89330");
		my $_b3c624da = oct("0b$_84f24710");

		my $_235c65da;
		if( $_39747896==0 ) {
			$_235c65da = '0'x$_6a661234;
		}
		elsif( $_39747896==1 ) {
			$_235c65da = '1'x$_6a661234;
		}
		else {
			if( $_b27a61fe==4 ) {
				$_235c65da = '10' x int($_6a661234/2);
			}
			else {
				$_235c65da = $_b3c624da<4 ? '1'x$_6a661234 : '0'x$_6a661234;
			}
		}
		#print "Writing ", $_235c65da, " at $_35d2c36c $_b3c624da ...";
		my @_70dcebce = reverse split(//, $_235c65da);
		for(my $j=0; $j<$_6a661234; $j++) {
			${$_89ba2b2a}->[$j]->[$_35d2c36c]->[$_b3c624da] = $_70dcebce[$j];
		}
		#print "OK!\n";
	}
}

sub read2mem {
	@_==2 or die "";
	my $_89ba2b2a = shift; # reference to reference
	my $_39747896 = shift;
	for(my $i=0; $i<$_57ae8bc2; $i++) {
		my $_28ce9652 = sprintf("%.*b", $_a9c03b46, $i);
		die "" unless( $_28ce9652 =~ m/([01]{$_a3e4e1e6})([01]{$_d22e4cc8})/ );
		my $_1aa89330 = $1;
		my $_84f24710 = $2;
		my $_35d2c36c = oct("0b$_1aa89330");
		my $_b3c624da = oct("0b$_84f24710");

		my $_235c65da;
		if( $_39747896==0 ) {
			$_235c65da = '0'x$_6a661234;
		}
		elsif( $_39747896==1 ) {
			$_235c65da = '1'x$_6a661234;
		}
		else {
			if( $_b27a61fe==4 ) {
				$_235c65da = '10' x int($_6a661234/2);
			}
			else {
				$_235c65da = $_b3c624da<4 ? '1'x$_6a661234 : '0'x$_6a661234;
			}
		}
		my @_70dcebce;
		for(my $j=0; $j<$_6a661234; $j++) {
			$_70dcebce[$j] = ${$_89ba2b2a}->[$j]->[$_35d2c36c]->[$_b3c624da];
		}
		my $_22701de2 = join("", reverse @_70dcebce);
		print "Reading ", $_22701de2, " at $_35d2c36c $_b3c624da ...";
		printf("%s!\n", $_22701de2 eq $_235c65da ? "PASS" : "ERROR");
	}
}

sub shift_by_fca {
	@_==4 or die "";
	my $_89ba2b2a = shift; # reference to reference
	my $_2b4a32fc = shift;
	my $_dfda2564 = shift;
	my $_394c3b68 = shift;

	die "" if( $_dfda2564 > ($_da987cb0/4-1) );
	die "" if( $_394c3b68 > ($_ff529e12/4-1) );

	my $_63825b7c = mem2str($_89ba2b2a, $_2b4a32fc);
	$_63825b7c =~ s/ //g;
	die "" unless( length($_63825b7c)==$_9ef24114 );
	my (@_4940736a, @_a55616b2);
	my $j = 0;
	while( $_63825b7c =~ m/([01]{4})/g ) {
		if( $j < $_da987cb0/4 ) {
			push(@_4940736a, $1);
		}
		else {
			push(@_a55616b2, $1);
		}
		$j++;
	}
	# Reverse _4940736a-side to treat it like _a55616b2-side!
	my $_4940736a = join("", @_4940736a);
	my $_bc3a6782 = reverse $_4940736a;
	my @_e46a40aa;
	while( $_bc3a6782 =~ m/([01]{4})/g ) {
		push(@_e46a40aa, $1);
	}
	splice(@_e46a40aa, $_dfda2564, 1);
	splice(@_e46a40aa, 0, 0, '0000');
	$_bc3a6782 = join("", @_e46a40aa);
	$_4940736a = reverse $_bc3a6782;
	$#_4940736a = -1; # init _e46a40aa
	while( $_4940736a =~ m/([01]{4})/g ) {
		push(@_4940736a, $1);
	} # Now coming back to original @_4940736a!
	# Don't need to reverse _a55616b2-side!
	splice(@_a55616b2, $_394c3b68, 1);
	splice(@_a55616b2, 0, 0, '0000');
	# join @_4940736a/@_a55616b2 and make it a string!
	$_63825b7c = join("", @_4940736a, @_a55616b2);
	str2mem($_89ba2b2a, $_63825b7c, $_2b4a32fc);
}

sub mem2str {
	@_==2 or die "";
	my $_89ba2b2a = shift; # reference to reference
	my $_2b4a32fc = shift;
	my $_63825b7c;
	for(my $j=0; $j<$_6a661234; $j++) {
		if( $j<$_1c52a516 ) { # Flipped _4940736a-side!
			for(my $k=$_b27a61fe-1; $k>=0; $k--) {
				$_63825b7c .= ${$_89ba2b2a}->[$j]->[$_2b4a32fc]->[$k];
			}
		}
		else { # Unflipped _a55616b2-side!
			for(my $k=0; $k<$_b27a61fe; $k++) {
				$_63825b7c .= ${$_89ba2b2a}->[$j]->[$_2b4a32fc]->[$k];
			}
		}
		$_63825b7c .= " "; # I/O delimitter!
	}
	return $_63825b7c;
}

sub str2mem {
	@_==3 or die "";
	my $_89ba2b2a = shift; # reference to reference
	my $_63825b7c = shift;
	my $_2b4a32fc = shift;
	$_63825b7c =~ s/ //g;
	die "" unless( length($_63825b7c)==$_9ef24114 );
	my $i = 0; # _6a661234's index
	while( $_63825b7c =~ m/([01]{$_b27a61fe})/g ) {
		my @_70dcebce = split("",$1);
		if( $i < $_1c52a516 ) {
			@{ ${$_89ba2b2a}->[$i]->[$_2b4a32fc] } = reverse @_70dcebce;
		}
		else {
			@{ ${$_89ba2b2a}->[$i]->[$_2b4a32fc] } = @_70dcebce;
		}
		$i++;
	}
	die "" unless( $i == $_6a661234 );
}
