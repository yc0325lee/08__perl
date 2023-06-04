# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Someclass__Common.pm
# Description : 
# Author : yc0325lee
# Created : 2018-11-19 23:38:19 by prince2103
# Modified : 2018-11-19 23:38:37 by prince2103
# ----------------------------------------------------------------------------
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# __SOMECLASS__.pm
# ----------------------------------------------------------------------------
package __SOMECLASS__;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

BEGIN { $ENV{PERL_TEXT_CSV}='Text::CSV_PP'; }
use Text::CSV;
use Text::Table::Tiny qw( generate_table );

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

# -------------------------------------
# universal methods
sub UNIVERSAL::now {
    @_==1 or confess "";
    my $either = shift; # class or object

    my ($sec, $min, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];
    $year += 1900;
    $month += 1;

    return sprintf("%04d%02d%02d_%02d%02d%02d",
        $year, $month, $day, $hour, $min, $sec);
}

sub UNIVERSAL::new {
    @_==1 or confess "";
    my $class = shift;
    my $this = {}; # hash-ref -> object
    return bless($this, $class);
}

sub UNIVERSAL::_init {
    @_==1 or confess "";
    my $this = shift;

    # do_nothing(); -> not used
}

sub dump {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    print Dumper($this), "\n"; # implement your own!
}

sub get_csv_object {
    @_==1 or confess "";
    my $either = shift; # class or object

    return Text::CSV->new({
        binary => 1,
        auto_diag => 1,
        allow_whitespace => 1,
    });
}

sub get_tab_object {
    @_==1 or confess "";
    my $either = shift; # class or object

    #return Text::Table->new();
}

sub write_table {
    @_==2 or confess "";
    my $either = shift; # class or object
    my $aref = shift;

    #print generate_table( rows => $aref ), "\n";
    #print generate_table( rows => $aref ), "\n";
    print generate_table( rows => $aref, header_row => 1 ), "\n";
    #print generate_table( rows => $aref, header_row => 1, separate_rows => 1 ), "\n";
}


1;
