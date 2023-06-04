# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : windows_file_renaming.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-26 23:12:32 by yc0325lee
# Modified : 2018-12-26 23:20:03 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

# part-1
#while( my $old = <*.mp3> ) {
while( my $old = glob("*.mp3 *.mp4") ) {
	chomp($old);
	$old =~ m/2013[-_](\d{2})[-_](\d{2})/;
	my $new = sprintf("[13%s%s].mp3",$1,$2);
	print "$old -> $new\n";
	rename($old,$new) or die "";
}

# part-2
while( <DATA> ) {
	chomp;
	my $old = $_;
	my $new = $_;
	#$new =~ s/(\d),(\d{3})/$1$2/;
    $new =~ s/^ESL ?Podcast /00/;
    #$new =~ s/^/0/;
	print "$old -> $new\n";
	print "[ERR ]\n" unless( -e $old );
	rename($old, $new); # $old -> $new
}

__END__
ESLPodcast 12 - Dining at a Restaurant(1).mp3
ESLPodcast 13 - Dining at a Restaurant(2).mp3
ESLPodcast 14 - Going to a Concert I.mp3
ESLPodcast 15 - Going to a Concert I.mp3
ESLPodcast 16 - Summertime Vacations.mp3
ESLPodcast 17 - Going to the Movies.mp3
ESLPodcast 18 - Getting Around (Fast.mp3
ESLPodcast 19 - Going Shopping.mp3
ESLPodcast 20 - Buying a New Compute.mp3
ESLPodcast 21 - Tell Me About Yourse.mp3
ESLPodcast 22 - Seeing Old Friends.mp3
ESLPodcast 23 - Spring Cleaning.mp3
ESLPodcast 24 - Driving on the Freew.mp3
ESLPodcast 25 - Problems at the Offi.mp3
ESLPodcast 26 - Daily Errands.mp3
ESLPodcast 27 - Good Advice.mp3
ESLPodcast 28 - Small Talk About the.mp3
ESLPodcast 29 - Unkind Comments.mp3
ESLPodcast 30 - Going to the Drugsto.mp3
ESLPodcast 31 - Reading the Newspape.mp3
ESLPodcast 32 - Going to the Post Of.mp3
ESLPodcast 33 - Being Gifted.mp3
ESLPodcast 34 - Cafe Living.mp3
ESLPodcast 35 - Working Late at the.mp3
ESLPodcast 36 - Shopping at the Mall.mp3
ESLPodcast 37 - Buying a Pet.mp3
ESLPodcast 38 - Food for the Barbecu.mp3
ESLPodcast 39 - Reality T.V..mp3
ESLPodcast 40 - Homecoming.mp3
ESLPodcast 41 - Tough Negotiations.mp3
ESLPodcast 42 - Formal Emails.mp3
ESLPodcast 43 - Getting an Interview.mp3
ESLPodcast 44 - Making a Good Impres.mp3
ESLPodcast 45 - A Visit to the Docto.mp3
ESLPodcast 46 - Taking Credit.mp3
ESLPodcast 47 - A Trip to New York C.mp3
ESLPodcast 48 - At the Movies.mp3
ESLPodcast 49 - Car Trouble.mp3
ESLPodcast 50 - Cashing a Check.mp3
