# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__MultiPathRule.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__MultiPathRule;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Meridian__RuleBase;

# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__RuleBase );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__MultiPathRule = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__MultiPathRule ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__MultiPathRule{$datum}}; # read-only
    }
}

sub AUTOLOAD {
    my $this = shift;
    confess("[erro] $AUTOLOAD -> instance method!") unless( ref($this) );
    my $ThisClass = ref($this); # classname of $this

    my $fieldname = $AUTOLOAD;
    $fieldname =~ s/.*:://;
    confess("[erro] field $fieldname not exists in an object of class $ThisClass!")
        unless( exists $this->{'permitted'}->{$fieldname} );

    if( @_ ) { $this->{$fieldname} = shift; } # set()
    return $this->{$fieldname}; # get()
}

sub BEGIN { }
sub END { }
sub DESTROY { $count--; }
sub Debug {
    (@_==1 || @_==2) or confess "[erro]";
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
    (@_==2 || @_==3) or confess "[erro]";
    my $either = shift;
    my $attr = shift;

    $maxLen->{$attr} = shift if( @_ ); # set
    return $maxLen->{$attr}; # get
}


# -------------------------------------
# class methods
sub new {
    @_==2 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );

    my $href__chunk = shift;

    my $this = $class->SUPER::new($href__chunk); # $this will be blessed up in the hierarchies!

    foreach my $attr ( @attributes ) { $this->{'permitted'}->{$attr} = 1; } # define!
    foreach my $attr ( @attributes ) { $this->{$attr} = undef; } # create!

    my $initializer = $CurrentClass . "::__init__"; # to invoke specific version
    $this->$initializer($href__chunk);

    $count++;

    return $this;
}


# -------------------------------------
# instance methods
sub __init__ {
    @_==2 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $href__chunk = shift;
    foreach my $attr ( @attributes ) {
        if( exists $href__chunk->{$attr} && defined $href__chunk->{$attr} ) {
            $this->$attr($href__chunk->{$attr});
        } else {
            confess "[erro] cannot find $attr field from input junk hash table!";
        }
    }
}


1;
