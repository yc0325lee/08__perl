# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test_map.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-19 21:47:31 by yc0325lee
# Modified : 2018-12-21 00:54:31 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

my @attributes = qw(
    Meridian__CNTL
    Meridian__DATA
    Meridian__W_CNTL
    Meridian__W_DATA
    Meridian__INTERFACE
    Meridian__U_INTERFACE
    Meridian__W_INTERFACE
    Meridian__W_GLITCH
    Meridian__W_RECON_GROUPS
); # object attributes

print "@attributes\n";

my @rules = @attributes;

print "attributes= @attributes\n";
print "rules= @rules\n";
foreach my $rule ( @rules ) { $rule =~ s/Meridian__//; }
print "rules= @rules\n";

my $string = join('|', @rules);
my $regex = qr{$string};
print "string= $string\n";
print "regex= $regex\n";


__END__
Meridian__CNTL Meridian__DATA Meridian__W_CNTL Meridian__W_DATA Meridian__INTERFACE Meridian__U_INTERFACE Meridian__W_INTERFACE Meridian__W_GLITCH Meridian__W_RECON_GROUPS
attributes= Meridian__CNTL Meridian__DATA Meridian__W_CNTL Meridian__W_DATA Meridian__INTERFACE Meridian__U_INTERFACE Meridian__W_INTERFACE Meridian__W_GLITCH Meridian__W_RECON_GROUPS
rules= Meridian__CNTL Meridian__DATA Meridian__W_CNTL Meridian__W_DATA Meridian__INTERFACE Meridian__U_INTERFACE Meridian__W_INTERFACE Meridian__W_GLITCH Meridian__W_RECON_GROUPS
rules= CNTL DATA W_CNTL W_DATA INTERFACE U_INTERFACE W_INTERFACE W_GLITCH W_RECON_GROUPS
string= CNTL|DATA|W_CNTL|W_DATA|INTERFACE|U_INTERFACE|W_INTERFACE|W_GLITCH|W_RECON_GROUPS
regex= (?^:CNTL|DATA|W_CNTL|W_DATA|INTERFACE|U_INTERFACE|W_INTERFACE|W_GLITCH|W_RECON_GROUPS)
