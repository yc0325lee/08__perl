# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test__Text_CSV.pl
# Description : 
# Author : yc0325lee
# Created : 2018-11-23 00:01:04 by prince2103
# Modified : 2018-12-27 00:55:32 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

BEGIN { $ENV{PERL_TEXT_CSV}='Text::CSV_PP'; }
use Text::CSV;


read_and_write__0('sample.csv'); # style-1
read_and_write__1('sample.csv'); # style-2


# -------------------------------------
# subroutines
# -------------------------------------

# extract csv-fields and save as array
sub read_and_write__0
{
    @_==1 or die "";
    my $inFile = shift;

    my $csvObj = Text::CSV->new({ binary => 1, auto_diag => 1, allow_whitespace => 1 });

    open(my $inFH, '<', $inFile) or die "";

    my $aref_row = $csvObj->getline($inFH);
    while( $aref_row->[0] =~ m/^#/ ) {
        $aref_row = $csvObj->getline($inFH); # ignore and get next row!
    }
    print "@{$aref_row}\n"; # header!

    while( $aref_row = $csvObj->getline($inFH) )
    {
        print "@{$aref_row}\n"; # each rows!
    }

    close($inFH) or die "";

    print "\n";
}

# extract csv-fields and save as hash
sub read_and_write__1
{
    @_==1 or die "";
    my $inFile = shift;

    my $csvObj = Text::CSV->new({ binary => 1, auto_diag => 1, allow_whitespace => 1 });

    open(my $inFH, '<', $inFile) or die "";

    my $aref_row = $csvObj->getline($inFH);
    while( $aref_row->[0] =~ m/^#/ ) {
        $aref_row = $csvObj->getline($inFH); # ignore and get next row!
    }

    my @field = @{$aref_row};
    print "@{$aref_row}\n"; # header!
    $csvObj->column_names($aref_row); # header setting

    my $href_row;
    while( $href_row = $csvObj->getline_hr($inFH) )
    {
        for(my $i = 0; $i < @field; $i++)
        {
            if( 0 && $href_row->{$field[$i]} =~ m/^\s*$/ ) {
                print "ERROR\n";
            }
            print $href_row->{$field[$i]}, " ";
            #                 ----------
            #                 field-name
        }
        print "\n";
    }

    close($inFH) or die "";

    print "\n";
}
