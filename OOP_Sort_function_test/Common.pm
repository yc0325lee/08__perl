# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# Common.pm
# ----------------------------------------------------------------------------
package Common;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

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

    my ($sec, $min, $hour, $day, $month, $year ) = (localtime)[0,1,2,3,4,5];
    $year += 1900;
    $month += 1;

    return
        sprintf("%04d%02d%02d_%02d%02d%02d",
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

    # -------------------------
    # do_nothing(); -> not used
    # -------------------------
}

sub UNIVERSAL::print {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    printf("[INFO] ", $this->name(), $this->field0());
}


1;
