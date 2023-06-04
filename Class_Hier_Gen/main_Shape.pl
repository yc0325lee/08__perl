# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : main_Shape.pl
# Description : 
# Author : yc0325lee
# Created : 2019-11-24 21:45:03 by yc0325lee
# Modified : 2019-11-24 21:45:03 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Shape__Dot;
use Shape__Line;
use Shape__Cube;
use Shape__Sphere;
use Shape__Tetrahedron;
use Shape__Circle;
use Shape__Square;
use Shape__Triangle;

my @array = (
    Shape__Dot->new(0),
    Shape__Line->new(0),
    Shape__Cube->new(0),
    Shape__Sphere->new(0),
    Shape__Tetrahedron->new(0),
    Shape__Circle->new(0),
    Shape__Square->new(0),
    Shape__Triangle->new(0,1),
);

# polymorphism
for(my $i = 0; $i < @array; $i++) {
    $array[$i]->dump();
}
