# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__SinglePathRule.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__SinglePathRule;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Meridian__RuleBase;

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( Meridian__RuleBase );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__SinglePathRule = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__SinglePathRule ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__SinglePathRule{$datum}}; # read-only
    }
}

sub AUTOLOAD {
    my $this = shift;
    confess("[ERR ] $AUTOLOAD -> instance method!") unless( ref($this) );
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
    my $either = shift;
    @attributes = @_ if( @_ );
    return @attributes; # [caution] returns array really!
}

sub maxLen {
    (@_==2 || @_==3) or confess "[ERR ]";
    my $either = shift;
    my $attr = shift;

    $maxLen->{$attr} = shift if( @_ ); # set
    return $maxLen->{$attr}; # get
}


# -------------------------------------
# class methods
sub new {
    @_==2 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my $href = shift;

    my $this = $class->SUPER::new($href); # $this will be blessed up in the hierarchies!

    foreach my $attr ( @attributes ) { $this->{'permitted'}->{$attr} = 1; } # define!
    foreach my $attr ( @attributes ) { $this->{$attr} = undef; } # create!

    my $initializer = $CurrentClass . "::__init__"; # to invoke specific version
    $this->$initializer($href);

    $count++;

    return $this;
}


# -------------------------------------
# instance methods
sub __init__ {
    @_==2 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $href = shift;
    foreach my $attr ( @attributes ) {
        if( exists $href->{$attr} && defined $href->{$attr} ) {
            $this->$attr($href->{$attr});
        } else {
            confess "[ERR ] Cannot find $attr from input hash table!";
        }
    }
}


1;
