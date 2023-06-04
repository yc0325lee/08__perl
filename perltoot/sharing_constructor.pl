# ----------------------------------------------------------------------------
# Common.pm
# ----------------------------------------------------------------------------
package Common;

# --------------------
# use pragma or module
use strict; # pragma
use Carp;   # core module

sub UNIVERSAL::new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    return $self;
}

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(); # searches @ISA to find new()...
    my $caller = caller(); # caller's package-name

    no strict "refs";
    my $hashname = $caller . '::fields';
    foreach my $key ( keys %$hashname ) { # '_permitted' field
        $self->{'_permitted'}->{$key} = $hashname->{$key};
    }
    foreach my $key ( keys %$hashname ) { # real fields
        $self->{$key} = $hashname->{$key};
    }

    bless ($self, $class); # reconsecrate
    _init($self);         # initialize real fields
    return $self;          # return object(blessed reference)
}

# How about using 'UNIVERSAL->can()'?


1;


# ----------------------------------------------------------------------------
# Parent.pm
# ----------------------------------------------------------------------------
package Parent;

# --------------------
# use pragma or module
use strict; # pragma
use Carp;   # core module


# ---------------
# package globals
our @ISA = qw( Common );
our $AUTOLOAD;
our %Parent = (
    data1 => "",
    data2 => "",
    data3 => "",
);


# -------------------
# file-scoped lexcals
our %fields = (
    first  => undef,
    second => undef,
    third  => undef,
);


# --------------
# Common methods
sub AUTOLOAD {
    die "" if( @_==0 );
    my $self = shift;
    confess("[ERROR] $self is not an object!") unless( ref($self) );
    my $class = ref($self);
    my $name = $AUTOLOAD;
    $name =~ s/.*://;     # strip fully-qualified portion
    unless( exists $self->{'_permitted'}->{$name} ) {
        croak("Can't access $name field in class $class!");
    }
    $self->{$name} = shift if( @_ );
    return $self->{$name};
}
sub BEGIN { }
sub END { }
sub DESTROY { }


# -------------
# Class methods
#sub new {
#    my $class = shift;
#    my $self  = $class->SUPER::new(); # searches @ISA to find new()...
#
#    # '_permitted' field
#    foreach my $key ( keys %fields ) {
#        $self->{'_permitted'}->{$key} = $fields{$key};
#    }
#
#    # real fields
#    foreach my $key ( keys %fields ) {
#        $self->{$key} = $fields{$key};
#    }
#
#    bless ($self, $class); # reconsecrate
#    _init($self);          # initialize real fields
#    return $self;          # return object(blessed reference)
#}

sub _init {
    @_==1 or die "";
    my $self = shift;  # blessed-reference
    $self->first(0);   # scalar
    $self->second([]); # anonymous array
    $self->third({});  # anonymous hash
}


# --------------
# Object methods

# No we don't need the following object methods:
# sub first { ... }
# sub second { ... }
# sub third { ... }

1;


# ----------------------------------------------------------------------------
# Child.pm - autoloaded data methods
# ----------------------------------------------------------------------------
package Child;

# --------------------
# use pragma or module
use strict; # pragma
use Carp;   # core module


# ---------------
# package globals
our @ISA = qw( Parent );
our $AUTOLOAD;
our %Child = (
    data4 => "",
    data5 => "",
);


# -------------------
# file-scoped lexcals
our %fields = (
    fourth => undef,
    fifth  => undef,
);


# --------------
# Common methods
sub AUTOLOAD {
    die "" if( @_==0 );
    my $self = shift;
    confess("[ERROR] $self is not an object!") unless( ref($self) );
    my $class = ref($self);
    my $name = $AUTOLOAD;
    $name =~ s/.*://;     # strip fully-qualified portion
    unless( exists $self->{'_permitted'}->{$name} ) {
        croak("Can't access $name field in class $class!");
    }
    $self->{$name} = shift if( @_ );
    return $self->{$name};
}
sub BEGIN { }
sub END { }
sub DESTROY { }


# -------------
# Class methods
#sub new {
#    my $class = shift;
#    my $self  = $class->SUPER::new(); # searches @ISA to find new()...
#
#    # '_permitted' field
#    foreach my $key ( keys %fields ) {
#        $self->{'_permitted'}->{$key} = $fields{$key};
#    }
#
#    # real fields
#    foreach my $key ( keys %fields ) {
#        $self->{$key} = $fields{$key};
#    }
#
#    bless ($self, $class); # reconsecrate
#    _init($self);          # initialize real fields
#    return $self;          # return object(blessed reference)
#}

sub _init {
    @_==1 or die "";
    my $self = shift; # blessed-reference
    $self->fourth(0); # scalar
    $self->fifth(0);  # scalar
}


# --------------
# Object methods

# No we don't need the following object methods:
# sub fourth { ... }
# sub fifth { ... }


1;


# ----------------------------------------------------------------------------
# main.pl
# ----------------------------------------------------------------------------
package main;

use strict;
use Data::Dumper;

my $a = Parent->new();
print Dumper($a);


my $b = Child->new();
print Dumper($b);


