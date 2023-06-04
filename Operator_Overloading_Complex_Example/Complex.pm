# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Complex.pm
# Description : 
# Author : yc0325lee
# Created : 2018-12-16 22:47:30 by yc0325lee
# Modified : 2019-12-20 00:10:54 by yc0325lee
# ----------------------------------------------------------------------------
package Complex;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Common;

use overload "+" => \&__add;

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( Common );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;

our %Complex = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals
my @attributes = qw( Real Imag ); # object attributes
my %fields;
foreach my $key ( @attributes ) { $fields{$key} = undef; }

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Complex ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Complex{$datum}}; # read-only
    }
}

sub AUTOLOAD {
    my $this = shift;
    confess("[ERR ] instance method!") unless( ref($this) );
    my $ThisClass = ref($this); # classname of $this

    my $fieldname = $AUTOLOAD;
    $fieldname =~ s/.*:://;
    confess("[ERR ] Field $fieldname not exists in an object of class $ThisClass!")
        unless( exists $this->{'permitted'}->{$fieldname} );

    if( @_ ) { $this->{$fieldname} = shift; } # set()
    return $this->{$fieldname}; # get()
}

sub BEGIN { }
sub END { }
sub DESTROY { $count--; }
sub Debug {
    (@_==1 || @_==2) or confess "[ERR ]";
    my $either = shift;
    $Debug = shift if( @_ ); # debug-level : 0, 1, 2
    return $Debug;
}

sub attributes {
    @_==1 or confess "[ERR ]";
    my $either = shift;
    return @attributes; # [caution] returns array really!
}

# -------------------------------------
# class methods
sub new {
    (@_==1 || @_==3) or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my $this = $class->SUPER::new(0); # $this will be blessed up in the hierarchies!

    foreach my $key ( keys %fields ) { $this->{'permitted'}->{$key} = 1; } # define!
    foreach my $key ( keys %fields ) { $this->{$key} = 0.0; } # create!

    my $initializer = $CurrentClass . '::_init';
    $this->$initializer($_[0], $_[1]) if( @_ ); # explicit values

    $count++;

    return $this;
}

# -------------------------------------
# instance methods
sub _init {
    @_==3 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    foreach my $attribute ( keys %fields ) {
        if( @_ ) {
            $this->$attribute(shift(@_));
        } else {
            confess "[ERR ] Cannot find $attribute from input hash table!";
        }
    }
}

sub print {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    #printf("%s= ( %.3f , %.3f )\n", $this, $this->Real(), $this->Imag());
}

sub __add {
    @_==3 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $right = shift; # operand
    my $swapped = shift; # true if swapped

    return $ThisClass->new( $this->Real() + $right->Real(), $this->Imag() + $right->Imag() );
}

1;
