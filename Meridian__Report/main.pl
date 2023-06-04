# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : main.pl
# - author : yc0325lee
# - created : 2022-10-23 13:30:12 by lee2103
# - modified : 2022-10-23 13:30:12 by lee2103
# - description : 
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use Meridian__Report;
#use Meridian__Report_bundle;

# configure - it's possible to customize the rule attributes at first
# configure - it's possible to customize the rule attributes at first
# configure rule attributes before importing
# ; 
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

# re-configure rule attributes after importing
Meridian__CNTL->attributes(qw( RuleName TxFlop RxFlop ));
Meridian__DATA->attributes(qw( RuleName TxFlop RxFlop ));
Meridian__W_CNTL->attributes(qw( RuleName TxFlop RxFlop ));
Meridian__W_DATA->attributes(qw( RuleName TxFlop RxFlop ));
Meridian__INTERFACE->attributes(qw( RuleName Signal ));
Meridian__U_INTERFACE->attributes(qw( RuleName Signal ));
Meridian__W_INTERFACE->attributes(qw( RuleName Signal ));
Meridian__W_GLITCH->attributes(qw( RuleName DriverFlop VictimFlop ));
Meridian__W_RECON_GROUPS->attributes(qw( RuleName DriverFlop ReconPoint ReconDepth ));

$report->write_tab();
$report->write_rpt();
$report->write_csv();

if( 0 ) {
    print("\n\n");
    print("Meridian__CNTL->attributes()= ", join(" ", Meridian__CNTL->attributes()), "\n");
    print("Meridian__DATA->attributes()= ", join(" ", Meridian__DATA->attributes()), "\n");
    print("Meridian__W_CNTL->attributes()= ", join(" ", Meridian__W_CNTL->attributes()), "\n");
    print("Meridian__W_DATA->attributes()= ", join(" ", Meridian__W_DATA->attributes()), "\n");
    print("Meridian__INTERFACE->attributes()= ", join(" ", Meridian__INTERFACE->attributes()), "\n");
    print("Meridian__U_INTERFACE->attributes()= ", join(" ", Meridian__U_INTERFACE->attributes()), "\n");
    print("Meridian__W_INTERFACE->attributes()= ", join(" ", Meridian__W_INTERFACE->attributes()), "\n");
    print("Meridian__W_GLITCH->attributes()= ", join(" ", Meridian__W_GLITCH->attributes()), "\n");
    print("Meridian__W_RECON_GROUPS->attributes()= ", join(" ", Meridian__W_RECON_GROUPS->attributes()), "\n");
}

if( 0 ) {
    print "\n\n[DGB] report= ", Dumper($report), "\n";
}
