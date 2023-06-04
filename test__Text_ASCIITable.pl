# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test__Text_ASCIITable.pl
# Description : 
# Author : yc0325lee
# Created : 2019-12-02 23:05:01 by yc0325lee
# Modified : 2019-12-02 23:21:15 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

use Text::ASCIITable;

my $table = Text::ASCIITable->new();

$table->setCols( qw( Rule  Id  TxFlop  RxFlop  TxClock  RxClock  Comment ) );
$table->setColWidth( 'Comment', 10, 1 );

$table->addRow( qw( A     0   undef   undef   clk1     clk2     aaa-trailing-traling     ) ); # row[0]
$table->addRow( qw( B     1   undef   undef   clk2     clk1     bbb-trailing-traling     ) ); # row[1]
$table->addRow( qw( C     2   undef   undef   clk1     clk2     ccc-trailing-traling     ) ); # row[2]
$table->addRow( qw( D     3   undef   undef   clk2     clk1     ddd-trailing-traling     ) ); # row[3]
$table->addRow( qw( E     4   undef   undef   clk1     clk2     eee-trailing-traling     ) ); # row[4]
$table->addRow( qw( F     5   undef   undef   clk2     clk1     fff-trailing-traling     ) ); # row[5]
$table->addRow( qw( G     6   undef   undef   clk1     clk2     ggg-trailing-traling     ) ); # row[6]
$table->addRow( qw( H     7   undef   undef   clk2     clk1     hhh-trailing-traling     ) ); # row[7]
$table->addRow( qw( I     8   undef   undef   clk1     clk2     iii-trailing-traling     ) ); # row[8]
$table->addRow( qw( J     9   undef   undef   clk2     clk1     jjj-trailing-traling     ) ); # row[9]

print $table->draw();
#print $table, "\n"; # this is also ok!
