# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# DerivedClass_A.pm
# ----------------------------------------------------------------------------
package DerivedClass_A;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use BaseClass;

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( BaseClass );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $data1 = 1;

our %DerivedClass_A = (
  data1 => \$data1,
); # class attribute

# -------------------------------------
# file-scoped lexicals
my %fields = (
    field1 => undef,
); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %DerivedClass_A ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$DerivedClass_A{$datum}}; # read-only
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
sub DESTROY { }


# -------------------------------------
# class methods
sub new {
    @==4 or confess "";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my $name = shift;
    my $field0 = shift;
    my $field1 = shift;

    my $this = $class->SUPER::new($name, $field0); # $this will be blessed up in the hierarchies!

    foreach my $key ( keys %fields ) {
        $this->{'permitted'}->{$key} = 1; # just define!
    }

    foreach my $key ( keys %fields ) {
        $this->{$key} = $fields{$key};
    }

    my $initializer = $CurrentClass . '::_init';
    $this->$initializer($field1);

    return $this;
}


# -------------------------------------
# instance methods
sub _init {
    @_==2 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $field1 = shift;

    $this->field1($field1); # scalar
}

sub print {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    $this->SUPER::print(); # invokes base-class's version first!
    printf("field1= %d\n", $this->field1());
}


1;
