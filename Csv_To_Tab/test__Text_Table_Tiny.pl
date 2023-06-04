# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : test__Text_Table_Tiny.pl
# Description : 
# Author : yc0325lee
# Created : 2018-11-23 00:09:21 by prince2103
# Modified : 2019-11-18 00:39:40 by yc0325lee
# Configurations
#   $Text::Table::Tiny::COLUMN_SEPARATOR = '|';
#   $Text::Table::Tiny::ROW_SEPARATOR = '-';
#   $Text::Table::Tiny::CORNER_MARKER = '+';
#   $Text::Table::Tiny::HEADER_ROW_SEPARATOR = '=';
#   $Text::Table::Tiny::HEADER_CORNER_MARKER = 'O';
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Text::Table::Tiny qw( generate_table );

my $rows = [
    [qw( Rule  Id  TxFlop  RxFlop  TxClock  RxClock  Comment )], # header
    [qw( A     0   undef   undef   clk1     clk2     aaa     )], # row[0]
    [qw( B     1   undef   undef   clk2     clk1     bbb     )], # row[1]
    [qw( C     2   undef   undef   clk1     clk2     ccc     )], # row[2]
    [qw( D     3   undef   undef   clk2     clk1     ddd     )], # row[3]
    [qw( E     4   undef   undef   clk1     clk2     eee     )], # row[4]
    [qw( F     5   undef   undef   clk2     clk1     fff     )], # row[5]
    [qw( G     6   undef   undef   clk1     clk2     ggg     )], # row[6]
    [qw( H     7   undef   undef   clk2     clk1     hhh     )], # row[7]
    [qw( I     8   undef   undef   clk1     clk2     iii     )], # row[8]
    [qw( J     9   undef   undef   clk2     clk1     jjj     )], # row[9]
];

print "# generate_table(rows => \$rows);\n";
print generate_table(rows => $rows);
print "\n\n";

print "# generate_table(rows => \$rows, header_row => 1);\n";
print generate_table(rows => $rows, header_row => 1);
print "\n\n";

print "# generate_table(rows => \$rows, header_row => 1, separate_rows => 1);\n";
print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
print "\n\n";

# configured
$Text::Table::Tiny::COLUMN_SEPARATOR = '';
$Text::Table::Tiny::CORNER_MARKER = '';
print "# generate_table(rows => \$rows, header_row => 1);\n";
print "# \$Text::Table::Tiny::COLUMN_SEPARATOR = '';\n";
print "# \$Text::Table::Tiny::CORNER_MARKER = '';\n";
#print generate_table(rows => $rows, header_row => 1);
print generate_table(rows => $rows);
print "\n\n";


__END__

# generate_table(rows => $rows);
+------+----+--------+--------+---------+---------+---------+
| Rule | Id | TxFlop | RxFlop | TxClock | RxClock | Comment |
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

# generate_table(rows => $rows, header_row => 1);
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

# generate_table(rows => $rows, header_row => 1, separate_rows => 1);
+------+----+--------+--------+---------+---------+---------+
| Rule | Id | TxFlop | RxFlop | TxClock | RxClock | Comment |
O======O====O========O========O=========O=========O=========O
| A    | 0  | undef  | undef  | clk1    | clk2    | aaa     |
+------+----+--------+--------+---------+---------+---------+
| B    | 1  | undef  | undef  | clk2    | clk1    | bbb     |
+------+----+--------+--------+---------+---------+---------+
| C    | 2  | undef  | undef  | clk1    | clk2    | ccc     |
+------+----+--------+--------+---------+---------+---------+
| D    | 3  | undef  | undef  | clk2    | clk1    | ddd     |
+------+----+--------+--------+---------+---------+---------+
| E    | 4  | undef  | undef  | clk1    | clk2    | eee     |
+------+----+--------+--------+---------+---------+---------+
| F    | 5  | undef  | undef  | clk2    | clk1    | fff     |
+------+----+--------+--------+---------+---------+---------+
| G    | 6  | undef  | undef  | clk1    | clk2    | ggg     |
+------+----+--------+--------+---------+---------+---------+
| H    | 7  | undef  | undef  | clk2    | clk1    | hhh     |
+------+----+--------+--------+---------+---------+---------+
| I    | 8  | undef  | undef  | clk1    | clk2    | iii     |
+------+----+--------+--------+---------+---------+---------+
| J    | 9  | undef  | undef  | clk2    | clk1    | jjj     |
+------+----+--------+--------+---------+---------+---------+

# generate_table(rows => $rows, header_row => 1);
# $Text::Table::Tiny::COLUMN_SEPARATOR = '';
# $Text::Table::Tiny::CORNER_MARKER = '';
-----------------------------------------------------
 Rule  Id  TxFlop  RxFlop  TxClock  RxClock  Comment 
-----------------------------------------------------
 A     0   undef   undef   clk1     clk2     aaa     
 B     1   undef   undef   clk2     clk1     bbb     
 C     2   undef   undef   clk1     clk2     ccc     
 D     3   undef   undef   clk2     clk1     ddd     
 E     4   undef   undef   clk1     clk2     eee     
 F     5   undef   undef   clk2     clk1     fff     
 G     6   undef   undef   clk1     clk2     ggg     
 H     7   undef   undef   clk2     clk1     hhh     
 I     8   undef   undef   clk1     clk2     iii     
 J     9   undef   undef   clk2     clk1     jjj     
-----------------------------------------------------
