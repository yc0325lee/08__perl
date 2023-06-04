# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : main.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-16 14:38:46 by yc0325lee
# Modified : 2019-01-10 00:51:05 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

#use Meridian__Report;
use Meridian__Report_bundle;

# configure - it's possible to customize the rule attributes
#Meridian__CNTL->attributes(qw( RuleName TxFlop RxFlop ClockDomains Info ));
#Meridian__DATA->attributes(qw( RuleName TxFlop RxFlop ClockDomains Info ));
#Meridian__W_CNTL->attributes(qw( RuleName TxFlop RxFlop ClockDomains Info ));
#Meridian__W_DATA->attributes(qw( RuleName TxFlop RxFlop ClockDomains Info ));
#Meridian__INTERFACE->attributes(qw( RuleName Signal ClockDomains Info ));
#Meridian__U_INTERFACE->attributes(qw( RuleName Signal ClockDomains Info ));
#Meridian__W_INTERFACE->attributes(qw( RuleName Signal ClockDomains Info ));
#Meridian__W_GLITCH->attributes(qw( RuleName DriverFlop VictimFlop ClockDomains Info ));
#Meridian__W_RECON_GROUPS->attributes(qw( RuleName DriverFlop ReconPoint ReconDepth ClockDomains Info));

my $input = "sample.in";
my $report = Meridian__Report->new($input);
$report->write_tab();
$report->write_rpt();
$report->write_csv();

#print "[DGB] report= ", Dumper($report), "\n";
