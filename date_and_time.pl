# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# date_and_time.pl
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Time::Local qw( timelocal timegm );

our ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

sub getTime {
    ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
}

sub 

# -------------------------------------
# localtime
printf("\n# localtime\n");
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
    localtime(time);

printf("sec= %d\n", $sec);
printf("min= %d\n", $min);
printf("hour= %d\n", $hour);
printf("mday= %d\n", $mday);
printf("mon= %d\n", $mon);
printf("year= %d\n", $year);
printf("wday= %d\n", $wday);
printf("yday= %d\n", $yday);
printf("isdst= %d\n", $isdst);

my $now = sprintf("%02d%02d%02d_%02d%02d%02d",
    ($year + 1900) % 100, $mon + 1, $mday, $hour, $min, $sec);
printf("now= %s\n", $now);

my $localtime = localtime;
printf("localtime= %s\n", $localtime);


# -------------------------------------
# gmtime
printf("\n# gmtime\n");
my $gmtime = gmtime();
printf("gmtime= %s\n", $gmtime);

printf("gmtime_start= %d\n", gmtime());
sleep(5);
printf("gmtime_end= %d\n", gmtime());


# -------------------------------------
# timelocal
printf("\n# timelocal\n");
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my $time0 = sprintf("%02d%02d%02d_%02d%02d%02d",
    ($year + 1900) % 100, $mon + 1, $mday, $hour, $min, $sec);
my $epoch0 = timelocal($sec, $min, $hour, $mday, $mon, $year); # to epoch
printf("time0= %s, epoch0= %d\n", $time0, $epoch0);

sleep(5);

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my $time1 = sprintf("%02d%02d%02d_%02d%02d%02d",
    ($year + 1900) % 100, $mon + 1, $mday, $hour, $min, $sec);
my $epoch1 = timelocal($sec, $min, $hour, $mday, $mon, $year); # to epoch
printf("time1= %s, epoch1= %d\n", $time1, $epoch1);

# recovery
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($epoch0);
$time0 = sprintf("%02d%02d%02d_%02d%02d%02d",
    ($year + 1900) % 100, $mon + 1, $mday, $hour, $min, $sec);

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($epoch1);
$time1 = sprintf("%02d%02d%02d_%02d%02d%02d",
    ($year + 1900) % 100, $mon + 1, $mday, $hour, $min, $sec);

printf("recovered-time0= %s\n", $time0);
printf("recovered-time1= %s\n", $time1);
