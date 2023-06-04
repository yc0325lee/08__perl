######################################################################
# COLUMN-REDUNDANCY VECTOR IMPLEMENTATION
# - v0.10 :	'flag' inserted in write2mem() 09/12/05
# - v0.20 :	shift_by_fca() added 09/12/05
######################################################################
use strict;
use warnings;
use POSIX qw(ceil);
use Data::Dumper;
use vars qw(
	$mem
	$backup
	$words $bpw $mux $bpwl $bpwr
	$rows $cols $cols_left $cols_right
	$width $xwidth $ywidth
	$fca1Width $fca2Width
);
$Data::Dumper::Indent = 1;

use integer;
my $inst = 'spsram_ulp_256x4m8';
die "" unless( $inst =~ m/(\d+)x(\d+)m(\d+)/ );
$words = $1;
$bpw = $2;
$mux = $3;
$bpwl = $bpw / 2;
$bpwr = $bpw - $bpwl;
$rows = $words / $mux;
$cols = $bpw * $mux;
$cols_left = $bpwl * $mux;
$cols_right = $bpwr * $mux;
no integer;
$width = ceil( log($words)/log(2.0) );
$ywidth = log($mux)/log(2.0);
$xwidth = $width - $ywidth;
$fca1Width = ceil( log($cols_left/4)/log(2.0) );
# FCA1[] : 0 ~ (cols_left/4-1)
$fca2Width = ceil( log($cols_right/4)/log(2.0) );
# FCA2[] : 0 ~ (cols_right/4-1)

# WRITE ZERO TO MEMORY
print ">>> WRITE ZERO TO MEMORY <<<\n";
write2mem(\$mem,0);

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$rows-1; $i>=0; $i--) { # Be cautious the index!
	my $str = mem2str(\$mem, $i);
	print $str, "\n";
}

# WRITE PATTERN TO MEMORY
print ">>> WRITE PATTERN TO MEMORY <<<\n";
write2mem(\$mem,2);

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$rows-1; $i>=0; $i--) { # Be cautious the index!
	my $str = mem2str(\$mem, $i);
	print $str, "\n";
}

# MEM --> BACKUP
print ">>> MEM --> BACKUP <<<\n";
for(my $i=$rows-1; $i>=0; $i--) { # Be cautious the index!
	my $str = mem2str(\$mem, $i);
	str2mem(\$backup, $str, $i);
}

# SHIFTING BY FCA
print ">>> SHIFTING BY FCA <<<\n";
my ($fca1, $fca2);
for(my $i=$rows-1; $i>=0; $i--) { # Be cautious the index!
	$fca1 = $i % ($cols_left/4);
	$fca2 = $i % ($cols_right/4);
	shift_by_fca(\$mem, $i, $fca1, $fca2);
}

# PRINT PHYSICAL ARRAY OF MEM
print ">>> PRINT PHYSICAL ARRAY OF MEM <<<\n";
for(my $i=$rows-1; $i>=0; $i--) { # Be cautious the index!
	my $str = mem2str(\$mem, $i);
	print $str, "\n";
}

# PRINT PHYSICAL ARRAY OF BACKUP
print ">>> PRINT PHYSICAL ARRAY OF BACKUP <<<\n";
for(my $i=$rows-1; $i>=0; $i--) { # Be cautious the index!
	my $str = mem2str(\$backup, $i);
	print $str, "\n";
}

# READ FROM MEMORY
print ">>> READ FROM MEMORY <<<\n";
read2mem(\$mem, 2);

# READ FROM BACKUP
print ">>> READ FROM BACKUP <<<\n";
read2mem(\$backup, 2);

######################################################################
# SUBROUTINES
######################################################################
sub write2mem {
	@_==2 or die "";
	my $ref = shift; # reference to reference
	my $flag = shift;
	for(my $i=0; $i<$words; $i++) {
		my $bin = sprintf("%.*b", $width, $i);
		die "" unless( $bin =~ m/([01]{$xwidth})([01]{$ywidth})/ );
		my $xbin = $1;
		my $ybin = $2;
		my $xaddr = oct("0b$xbin");
		my $yaddr = oct("0b$ybin");

		my $din;
		if( $flag==0 ) {
			$din = '0'x$bpw;
		}
		elsif( $flag==1 ) {
			$din = '1'x$bpw;
		}
		else {
			if( $mux==4 ) {
				$din = '10' x int($bpw/2);
			}
			else {
				$din = $yaddr<4 ? '1'x$bpw : '0'x$bpw;
			}
		}
		#print "Writing ", $din, " at $xaddr $yaddr ...";
		my @data = reverse split(//, $din);
		for(my $j=0; $j<$bpw; $j++) {
			${$ref}->[$j]->[$xaddr]->[$yaddr] = $data[$j];
		}
		#print "OK!\n";
	}
}

sub read2mem {
	@_==2 or die "";
	my $ref = shift; # reference to reference
	my $flag = shift;
	for(my $i=0; $i<$words; $i++) {
		my $bin = sprintf("%.*b", $width, $i);
		die "" unless( $bin =~ m/([01]{$xwidth})([01]{$ywidth})/ );
		my $xbin = $1;
		my $ybin = $2;
		my $xaddr = oct("0b$xbin");
		my $yaddr = oct("0b$ybin");

		my $din;
		if( $flag==0 ) {
			$din = '0'x$bpw;
		}
		elsif( $flag==1 ) {
			$din = '1'x$bpw;
		}
		else {
			if( $mux==4 ) {
				$din = '10' x int($bpw/2);
			}
			else {
				$din = $yaddr<4 ? '1'x$bpw : '0'x$bpw;
			}
		}
		my @data;
		for(my $j=0; $j<$bpw; $j++) {
			$data[$j] = ${$ref}->[$j]->[$xaddr]->[$yaddr];
		}
		my $dout = join("", reverse @data);
		print "Reading ", $dout, " at $xaddr $yaddr ...";
		printf("%s!\n", $dout eq $din ? "PASS" : "ERROR");
	}
}

sub shift_by_fca {
	@_==4 or die "";
	my $ref = shift; # reference to reference
	my $row = shift;
	my $fca1 = shift;
	my $fca2 = shift;

	die "" if( $fca1 > ($cols_left/4-1) );
	die "" if( $fca2 > ($cols_right/4-1) );

	my $str = mem2str($ref, $row);
	$str =~ s/ //g;
	die "" unless( length($str)==$cols );
	my (@left, @right);
	my $j = 0;
	while( $str =~ m/([01]{4})/g ) {
		if( $j < $cols_left/4 ) {
			push(@left, $1);
		}
		else {
			push(@right, $1);
		}
		$j++;
	}
	# Reverse left-side to treat it like right-side!
	my $left = join("", @left);
	my $flipped = reverse $left;
	my @array;
	while( $flipped =~ m/([01]{4})/g ) {
		push(@array, $1);
	}
	splice(@array, $fca1, 1);
	splice(@array, 0, 0, '0000');
	$flipped = join("", @array);
	$left = reverse $flipped;
	$#left = -1; # init array
	while( $left =~ m/([01]{4})/g ) {
		push(@left, $1);
	} # Now coming back to original @left!
	# Don't need to reverse right-side!
	splice(@right, $fca2, 1);
	splice(@right, 0, 0, '0000');
	# join @left/@right and make it a string!
	$str = join("", @left, @right);
	str2mem($ref, $str, $row);
}

sub mem2str {
	@_==2 or die "";
	my $ref = shift; # reference to reference
	my $row = shift;
	my $str;
	for(my $j=0; $j<$bpw; $j++) {
		if( $j<$bpwl ) { # Flipped left-side!
			for(my $k=$mux-1; $k>=0; $k--) {
				$str .= ${$ref}->[$j]->[$row]->[$k];
			}
		}
		else { # Unflipped right-side!
			for(my $k=0; $k<$mux; $k++) {
				$str .= ${$ref}->[$j]->[$row]->[$k];
			}
		}
		$str .= " "; # I/O delimitter!
	}
	return $str;
}

sub str2mem {
	@_==3 or die "";
	my $ref = shift; # reference to reference
	my $str = shift;
	my $row = shift;
	$str =~ s/ //g;
	die "" unless( length($str)==$cols );
	my $i = 0; # bpw's index
	while( $str =~ m/([01]{$mux})/g ) {
		my @data = split("",$1);
		if( $i < $bpwl ) {
			@{ ${$ref}->[$i]->[$row] } = reverse @data;
		}
		else {
			@{ ${$ref}->[$i]->[$row] } = @data;
		}
		$i++;
	}
	die "" unless( $i == $bpw );
}
