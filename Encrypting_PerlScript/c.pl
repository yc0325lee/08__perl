######################################################################
# COLUMN-REDUNDANCY VECTOR IMPLEMENTATION
# - v0.10 :	'_f1fa633e' inserted in write2mem() 09/12/05
# - v0.20 :	shift_by_fca() added 09/12/05
######################################################################
use strict;
use warnings;
use POSIX qw(ceil);
use Data::Dumper;
use vars qw(
	$_9d027ca6
	$_cfdac934
	$_28223ece $_a3503396 $_a33e653c $_15422888 $_f48aaf6e
	$_10dae9b6 $_cda224bc $_abb2336c $_8248affa
	$_f2e6f576 $_7db0dfac $_4a9a5490
	$_de4c329e $_27fa9c48
);
$Data::Dumper::Indent = 1;

use integer;
my $_aba66b2e = 'spsram_ulp_256x4m8';
die "" unless( $_aba66b2e =~ m/(\d+)x(\d+)m(\d+)/ );
$_28223ece = $1;
$_a3503396 = $2;
$_a33e653c = $3;
$_15422888 = $_a3503396 / 2;
$_f48aaf6e = $_a3503396 - $_15422888;
$_10dae9b6 = $_28223ece / $_a33e653c;
$_cda224bc = $_a3503396 * $_a33e653c;
$_abb2336c = $_15422888 * $_a33e653c;
$_8248affa = $_f48aaf6e * $_a33e653c;
no integer;
$_f2e6f576 = ceil( log($_28223ece)/log(2.0) );
$_4a9a5490 = log($_a33e653c)/log(2.0);
$_7db0dfac = $_f2e6f576 - $_4a9a5490;
$_de4c329e = ceil( log($_abb2336c/4)/log(2.0) );
# FCA1[] : 0 ~ (_abb2336c/4-1)
$_27fa9c48 = ceil( log($_8248affa/4)/log(2.0) );
# FCA2[] : 0 ~ (_8248affa/4-1)

# WRITE ZERO TO MEMORY
print ">>> WRITE ZERO TO MEMORY <<<\n";
write2mem(\$_9d027ca6,0);

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$_10dae9b6-1; $i>=0; $i--) { # Be cautious the index!
	my $_6130c6ae = mem2str(\$_9d027ca6, $i);
	print $_6130c6ae, "\n";
}

# WRITE PATTERN TO MEMORY
print ">>> WRITE PATTERN TO MEMORY <<<\n";
write2mem(\$_9d027ca6,2);

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$_10dae9b6-1; $i>=0; $i--) { # Be cautious the index!
	my $_6130c6ae = mem2str(\$_9d027ca6, $i);
	print $_6130c6ae, "\n";
}

# MEM --> BACKUP
print ">>> MEM --> BACKUP <<<\n";
for(my $i=$_10dae9b6-1; $i>=0; $i--) { # Be cautious the index!
	my $_6130c6ae = mem2str(\$_9d027ca6, $i);
	str2mem(\$_cfdac934, $_6130c6ae, $i);
}

# SHIFTING BY FCA
print ">>> SHIFTING BY FCA <<<\n";
my ($_30a00e44, $_7e4eb9ac);
for(my $i=$_10dae9b6-1; $i>=0; $i--) { # Be cautious the index!
	$_30a00e44 = $i % ($_abb2336c/4);
	$_7e4eb9ac = $i % ($_8248affa/4);
	shift_by_fca(\$_9d027ca6, $i, $_30a00e44, $_7e4eb9ac);
}

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$_10dae9b6-1; $i>=0; $i--) { # Be cautious the index!
	my $_6130c6ae = mem2str(\$_9d027ca6, $i);
	print $_6130c6ae, "\n";
}

# PRINT PHYSICAL ARRAY OF BACKUP
print ">>> PRINT PHYSICAL ARRAY OF BACKUP <<<\n";
for(my $i=$_10dae9b6-1; $i>=0; $i--) { # Be cautious the index!
	my $_6130c6ae = mem2str(\$_cfdac934, $i);
	print $_6130c6ae, "\n";
}

# READ FROM MEMORY
print ">>> READ FROM MEMORY <<<\n";
read2mem(\$_9d027ca6, 2);

# READ FROM BACKUP
print ">>> READ FROM BACKUP <<<\n";
read2mem(\$_cfdac934, 2);

######################################################################
# SUBROUTINES
######################################################################
sub write2mem {
	@_==2 or die "";
	my $_a0863684 = shift; # reference to reference
	my $_f1fa633e = shift;
	for(my $i=0; $i<$_28223ece; $i++) {
		my $_96f65e78 = sprintf("%.*b", $_f2e6f576, $i);
		die "" unless( $_96f65e78 =~ m/([01]{$_7db0dfac})([01]{$_4a9a5490})/ );
		my $_1a68426e = $1;
		my $_ee3a0ad0 = $2;
		my $_68d6e8d0 = oct("0b$_1a68426e");
		my $_9fca63d6 = oct("0b$_ee3a0ad0");

		my $_665c50d6;
		if( $_f1fa633e==0 ) {
			$_665c50d6 = '0'x$_a3503396;
		}
		elsif( $_f1fa633e==1 ) {
			$_665c50d6 = '1'x$_a3503396;
		}
		else {
			if( $_a33e653c==4 ) {
				$_665c50d6 = '10' x int($_a3503396/2);
			}
			else {
				$_665c50d6 = $_9fca63d6<4 ? '1'x$_a3503396 : '0'x$_a3503396;
			}
		}
		#print "Writing ", $_665c50d6, " at $_68d6e8d0 $_9fca63d6 ...";
		my @_9f72d88c = reverse split(//, $_665c50d6);
		for(my $j=0; $j<$_a3503396; $j++) {
			${$_a0863684}->[$j]->[$_68d6e8d0]->[$_9fca63d6] = $_9f72d88c[$j];
		}
		#print "OK!\n";
	}
}

sub read2mem {
	@_==2 or die "";
	my $_a0863684 = shift; # reference to reference
	my $_f1fa633e = shift;
	for(my $i=0; $i<$_28223ece; $i++) {
		my $_96f65e78 = sprintf("%.*b", $_f2e6f576, $i);
		die "" unless( $_96f65e78 =~ m/([01]{$_7db0dfac})([01]{$_4a9a5490})/ );
		my $_1a68426e = $1;
		my $_ee3a0ad0 = $2;
		my $_68d6e8d0 = oct("0b$_1a68426e");
		my $_9fca63d6 = oct("0b$_ee3a0ad0");

		my $_665c50d6;
		if( $_f1fa633e==0 ) {
			$_665c50d6 = '0'x$_a3503396;
		}
		elsif( $_f1fa633e==1 ) {
			$_665c50d6 = '1'x$_a3503396;
		}
		else {
			if( $_a33e653c==4 ) {
				$_665c50d6 = '10' x int($_a3503396/2);
			}
			else {
				$_665c50d6 = $_9fca63d6<4 ? '1'x$_a3503396 : '0'x$_a3503396;
			}
		}
		my @_9f72d88c;
		for(my $j=0; $j<$_a3503396; $j++) {
			$_9f72d88c[$j] = ${$_a0863684}->[$j]->[$_68d6e8d0]->[$_9fca63d6];
		}
		my $_b2ce3112 = join("", reverse @_9f72d88c);
		print "Reading ", $_b2ce3112, " at $_68d6e8d0 $_9fca63d6 ...";
		printf("%s!\n", $_b2ce3112 eq $_665c50d6 ? "PASS" : "ERROR");
	}
}

sub shift_by_fca {
	@_==4 or die "";
	my $_a0863684 = shift; # reference to reference
	my $_973ecd52 = shift;
	my $_30a00e44 = shift;
	my $_7e4eb9ac = shift;

	die "" if( $_30a00e44 > ($_abb2336c/4-1) );
	die "" if( $_7e4eb9ac > ($_8248affa/4-1) );

	my $_6130c6ae = mem2str($_a0863684, $_973ecd52);
	$_6130c6ae =~ s/ //g;
	die "" unless( length($_6130c6ae)==$_cda224bc );
	my (@_a6c247f8, @_57ac89ea);
	my $j = 0;
	while( $_6130c6ae =~ m/([01]{4})/g ) {
		if( $j < $_abb2336c/4 ) {
			push(@_a6c247f8, $1);
		}
		else {
			push(@_57ac89ea, $1);
		}
		$j++;
	}
	# Reverse _a6c247f8-side to treat it like _57ac89ea-side!
	my $_a6c247f8 = join("", @_a6c247f8);
	my $_b4ce7468 = reverse $_a6c247f8;
	my @_439a27fe;
	while( $_b4ce7468 =~ m/([01]{4})/g ) {
		push(@_439a27fe, $1);
	}
	splice(@_439a27fe, $_30a00e44, 1);
	splice(@_439a27fe, 0, 0, '0000');
	$_b4ce7468 = join("", @_439a27fe);
	$_a6c247f8 = reverse $_b4ce7468;
	$#_a6c247f8 = -1; # init _439a27fe
	while( $_a6c247f8 =~ m/([01]{4})/g ) {
		push(@_a6c247f8, $1);
	} # Now coming back to original @_a6c247f8!
	# Don't need to reverse _57ac89ea-side!
	splice(@_57ac89ea, $_7e4eb9ac, 1);
	splice(@_57ac89ea, 0, 0, '0000');
	# join @_a6c247f8/@_57ac89ea and make it a string!
	$_6130c6ae = join("", @_a6c247f8, @_57ac89ea);
	str2mem($_a0863684, $_6130c6ae, $_973ecd52);
}

sub mem2str {
	@_==2 or die "";
	my $_a0863684 = shift; # reference to reference
	my $_973ecd52 = shift;
	my $_6130c6ae;
	for(my $j=0; $j<$_a3503396; $j++) {
		if( $j<$_15422888 ) { # Flipped _a6c247f8-side!
			for(my $k=$_a33e653c-1; $k>=0; $k--) {
				$_6130c6ae .= ${$_a0863684}->[$j]->[$_973ecd52]->[$k];
			}
		}
		else { # Unflipped _57ac89ea-side!
			for(my $k=0; $k<$_a33e653c; $k++) {
				$_6130c6ae .= ${$_a0863684}->[$j]->[$_973ecd52]->[$k];
			}
		}
		$_6130c6ae .= " "; # I/O delimitter!
	}
	return $_6130c6ae;
}

sub str2mem {
	@_==3 or die "";
	my $_a0863684 = shift; # reference to reference
	my $_6130c6ae = shift;
	my $_973ecd52 = shift;
	$_6130c6ae =~ s/ //g;
	die "" unless( length($_6130c6ae)==$_cda224bc );
	my $i = 0; # _a3503396's index
	while( $_6130c6ae =~ m/([01]{$_a33e653c})/g ) {
		my @_9f72d88c = split("",$1);
		if( $i < $_15422888 ) {
			@{ ${$_a0863684}->[$i]->[$_973ecd52] } = reverse @_9f72d88c;
		}
		else {
			@{ ${$_a0863684}->[$i]->[$_973ecd52] } = @_9f72d88c;
		}
		$i++;
	}
	die "" unless( $i == $_a3503396 );
}
