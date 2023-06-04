# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__Common.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__Common;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

BEGIN { $ENV{PERL_TEXT_CSV}='Text::CSV_PP'; }
use Text::CSV;
use Text::Table::Tiny qw( generate_table );

# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

# -------------------------------------
# universal methods
sub UNIVERSAL::now {
    @_==1 or confess "[erro]";
    my $either = shift; # class or object

    my ($sec, $min, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];
    $year += 1900;
    $month += 1;

    return sprintf("%04d%02d%02d_%02d%02d%02d",
        $year, $month, $day, $hour, $min, $sec);
}

sub UNIVERSAL::new {
    @_==2 or confess "[erro]";
    my $class = shift;
    my $anything = shift;
    my $this = {};
    return bless($this, $class); # blessed-href -> object
}

sub UNIVERSAL::__init__ {
    @_==1 or confess "[erro]";
    my $this = shift;

    # do_nothing(); -> not used
}

sub dump {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    print Dumper($this), "\n"; # implement your own!
}

sub get_csv_object {
    @_==1 or confess "[erro]";
    my $either = shift; # class or object

    return Text::CSV->new({
        binary => 1,
        auto_diag => 1,
        allow_whitespace => 1,
    });
}

sub get_tab_object {
    @_==1 or confess "[erro]";
    my $either = shift; # class or object

    #return Text::Table->new();
}

sub write_ascii_table {
    @_==2 or confess "[erro]";
    my $either = shift; # class or object
    my $aref = shift;

    #print generate_table( rows => $aref ), "\n";
    #print generate_table( rows => $aref ), "\n";
    print generate_table( rows => $aref, header_row => 1 ), "\n";
    #print generate_table( rows => $aref, header_row => 1, separate_rows => 1 ), "\n";
}


1;
