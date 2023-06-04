# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# main.pl
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Shape__Dot;
use Shape__Line;
use Shape__Circle;
use Shape__Square;
use Shape__Triangle;
use Shape__Sphere;
use Shape__Cube;
use Shape__Tetrahedron;

my @array = (
    Shape__Dot->new(0, 0, 0),
    Shape__Line->new(0, 0, 0),
    Shape__Circle->new(0, 0, 0),
    Shape__Square->new(0, 0, 0),
    Shape__Triangle->new(0, 0, 0, 0),
    Shape__Sphere->new(0, 0, 0),
    Shape__Cube->new(0, 0, 0),
    Shape__Tetrahedron->new(0, 0, 0),
);

# polymorphism
for(my $i = 0; $i < @array; $i++) {
    $array[$i]->dump();
}
