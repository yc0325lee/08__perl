# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : main_Meridian.pl
# Description : 
# Author : yc0325lee
# Created : 2019-11-24 21:45:02 by yc0325lee
# Modified : 2019-11-24 21:45:02 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Meridian__INTERFACE;
use Meridian__U_INTERFACE;
use Meridian__W_GLITCH;
use Meridian__W_INTERFACE;
use Meridian__W_RECON_GROUPS;
use Meridian__CNTL;
use Meridian__DATA;
use Meridian__W_CNTL;
use Meridian__W_DATA;

my @array = (
    Meridian__INTERFACE->new(),
    Meridian__U_INTERFACE->new(),
    Meridian__W_GLITCH->new(),
    Meridian__W_INTERFACE->new(),
    Meridian__W_RECON_GROUPS->new(),
    Meridian__CNTL->new(),
    Meridian__DATA->new(),
    Meridian__W_CNTL->new(),
    Meridian__W_DATA->new(),
);

# polymorphism
for(my $i = 0; $i < @array; $i++) {
    $array[$i]->dump();
}
