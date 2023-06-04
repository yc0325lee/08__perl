# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : csv2tab.pl
# Description : 
# Author : yc0325lee
# Created : 2018-11-23 00:14:05 by prince2103
# Modified : 2019-09-20 23:48:52 by yc0325lee
# Note
#  ; Put the following 'csv2tab.cmd' script in your bin directory
#  ; csv2tab.cmd script
#    @echo off
#    IF "%1"=="" (
#    	perl D:\00_WORK\08__perl\Csv_To_Tab\csv2tab.pl
#    ) ELSE (
#    	perl D:\00_WORK\08__perl\Csv_To_Tab\csv2tab.pl %1
#    )
#  ; Set your $PATH environment variable
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

BEGIN { $ENV{PERL_TEXT_CSV} = 'Text::CSV_PP'; } # Pure-Perl version used!
use Text::CSV;
use Text::Table::Tiny qw( generate_table );

unless( @ARGV <= 1 ) # 0 or 1
{
    print "\nUsage(1) -> perl csv2tab.pl input.csv\n"; # from input-file
    print "Usage(2) -> cat input.csv | perl csv2tab.pl\n"; # from stdin
    exit(1);
}

my $csvObj = Text::CSV->new({ binary => 1, auto_diag => 1, allow_whitespace => 1 });
my $tab = []; # table!


my $inFH;
if( @ARGV ) {
    my $inFile = $ARGV[0];
    open($inFH, '<', $inFile) or die "[error] cannot open $inFile file!";
}
else {
    $inFH = *STDIN;
}

my $aref_row = $csvObj->getline($inFH);
while( $aref_row->[0] =~ m/^#/ ) {
    $aref_row = $csvObj->getline($inFH); # ignore and get next row!
}
push(@{$tab}, $aref_row); # header

$csvObj->column_names($aref_row); # header setting
my @field = @{$aref_row}; # header!

my $href_row;
while( $href_row = $csvObj->getline_hr($inFH) )
{
    my @row;
    for(my $i = 0; $i < @field; $i++)
    {
        push(@row, $href_row->{$field[$i]});
    }
    push(@{$tab}, \@row); # each row!
}

if( @ARGV ) {
    close($inFH) or die "";
}
else {
    $inFH = undef;
}

#print generate_table(rows => $tab), "\n";
print generate_table(rows => $tab, header_row => 1), "\n";
#print generate_table(rows => $tab, header_row => 1, separate_rows => 1), "\n";

__END__

# input - sample.csv
# ----------------------------------------------------------------------------
# this is comment line. - 171207_220926
# ----------------------------------------------------------------------------
Rule,Id,TxFlop,RxFlop,TxClock,RxClock,Comment
RULE_A,0,undef,undef,clk1,clk2,aaa
RULE_B,1,undef,undef,clk2,clk1,bbb
RULE_C,2,undef,undef,clk1,clk2,ccc
RULE_D,3,undef,undef,clk2,clk1,ddd
RULE_E,4,undef,undef,clk1,clk2,eee
RULE_F,5,undef,undef,clk2,clk1,fff
RULE_G,6,undef,undef,clk1,clk2,ggg
RULE_H,7,undef,undef,clk2,clk1,hhh
RULE_I,8,undef,undef,clk1,clk2,iii
RULE_J,9,undef,undef,clk2,clk1,jjj

# output - sample.tab
+------+----+--------+--------+---------+---------+---------+
| Rule | Id | TxFlop | RxFlop | TxClock | RxClock | Comment |
+------+----+--------+--------+---------+---------+---------+
| A    | 0  | undef  | undef  | clk1    | clk2    | aaa     |
| B    | 1  | undef  | undef  | clk2    | clk1    | bbb     |
| C    | 2  | undef  | undef  | clk1    | clk2    | ccc     |
| D    | 3  | undef  | undef  | clk2    | clk1    | ddd     |
| E    | 4  | undef  | undef  | clk1    | clk2    | eee     |
| F    | 5  | undef  | undef  | clk2    | clk1    | fff     |
| G    | 6  | undef  | undef  | clk1    | clk2    | ggg     |
| H    | 7  | undef  | undef  | clk2    | clk1    | hhh     |
| I    | 8  | undef  | undef  | clk1    | clk2    | iii     |
| J    | 9  | undef  | undef  | clk2    | clk1    | jjj     |
+------+----+--------+--------+---------+---------+---------+
