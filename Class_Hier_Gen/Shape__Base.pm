# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Shape__Base.pm
# Description : 
# Author : yc0325lee
# Created : 2019-11-24 21:45:03 by yc0325lee
# Modified : 2019-11-24 21:45:03 by yc0325lee
# ----------------------------------------------------------------------------
package Shape__Base;

use strict;
use warnings;
use Carp;

use Shape__Common;

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( Shape__Common );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $count = 0;

our %Shape__Base = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals
my %fields = (
    name => undef,
    color => undef,
); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Shape__Base ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Shape__Base{$datum}}; # read-only
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

# -------------------------------------
# class methods
sub new {
    @_==3 or confess "";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my $name = shift;
    my $color = shift;

    my $this = $class->SUPER::new(
    ); # $this will be blessed up in the hierarchies!

    foreach my $key ( keys %fields ) { $this->{'permitted'}->{$key} = 1; } # define!
    foreach my $key ( keys %fields ) { $this->{$key} = $fields{$key}; } # create!

    my $initializer = $CurrentClass . '::_init';
    $this->$initializer(
        $name,
        $color,
    );

    $count++;

    return $this;
}

# -------------------------------------
# instance methods
sub _init {
    @_==3 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $name = shift;
    my $color = shift;

    $this->name($name);
    $this->color($color);
}

sub print {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    #$this->SUPER::print();
    #$this->dump();
}


1;
