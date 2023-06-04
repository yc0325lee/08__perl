# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : algorithm-string_to_hash.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-27 21:56:12 by yc0325lee
# Modified : 2018-12-27 23:18:49 by yc0325lee
# Comments
# - for perl's internal hash function, find 'PERL_HASH' macro in hv.h from
#   perl distribution
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

sub str2hash_0 {
	my $hval = 0;
	foreach (split //, shift) {
		$hval = $hval*33 + ord($_);
		printf("<dbg> hval= %u\n", $hval);
	}
	return $hval;
}

sub str2hash_1 {
	my $hval = 0;
	foreach (split //, shift) {
		$hval = $hval*33 + ord($_);
		printf("<dbg> hval= %u\n", $hval);
	}
	return $hval + ($hval >> 5); # after 5.6
}

foreach my $key (qw(
	abcdefghijklmnopqrstuvwxyz1234567890
	abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
)) {
	printf("str2hash_0= %u\n", str2hash_0($key));
	printf("str2hash_1= %u\n", str2hash_1($key));
}
