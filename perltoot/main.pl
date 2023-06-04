# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# Common.pm
# ----------------------------------------------------------------------------
{
package Common;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

#use Nothing; # user-defined module

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

sub print {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    die("[ERR ] $thisFunction must be defined!"); # pure virtual function
}


#1;



# ----------------------------------------------------------------------------
# Person.pm - autoloaded data methods
# ----------------------------------------------------------------------------
package Person;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

#use Common; # user-defined module

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( Common );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $population = 0;

our %Person = (
  population => \$population,
); # class attribute

# -------------------------------------
# file-scoped lexicals
my %fields = (
    name => undef,
    age => undef,
    sex => undef,
); # object attributes, initial values can be put here!

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Person ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Person{$datum}}; # read-only
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

    if( @_ ) {
        $this->{$fieldname} = shift; # set()
    }
    return $this->{$fieldname}; # get()
}

sub BEGIN { }
sub END { }
sub DESTROY { $population--; }

# -------------------------------------
# class methods
sub new {
    @==4 or confess "";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my $name = shift;
    my $age = shift;
    my $sex = shift; # 0 or 1

    my $this = $class->SUPER::new(); # $this will be blessed up in the hierarchies!

    foreach my $key ( keys %fields ) {
        $this->{'permitted'}->{$key} = 1; # just define!
    }

    foreach my $key ( keys %fields ) {
        $this->{$key} = $fields{$key}; # field creation & initial value
    }

    my $initializer = $CurrentClass . '::_init';
    $this->$initializer($name, $age, $sex);

	$population++;

    return $this;
}

# -------------------------------------
# instance methods
sub _init {
    @_==4 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $name = shift;
    my $age = shift;
    my $sex = shift;

    $this->name($name); #scalar
    $this->age($age); # scalar
    $this->sex($sex); # scalar
}

sub print {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    printf("name= %s, age= %s, sex= %s\n",
        $this->name(), $this->age(), $this->sex());
}


#1;
}



# ----------------------------------------------------------------------------
# Employee.pm - autoloaded data methods
# ----------------------------------------------------------------------------
{
package Employee;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

#use Person; # user-defined module

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( Person );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our %Employee = (
); # class attribute

# -------------------------------------
# file-scoped lexicals
my %fields = (
    id     => undef,
    salary => undef,
); # we can put default values here!

# -------------------------------------
# class methods
sub new {
    @==6 or confess "";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my $name = shift;
    my $age = shift;
    my $sex = shift; # base-class's attributes
    my $id = shift;
    my $salary = shift; # derived-class's attributes

    my $this = $class->SUPER::new($name, $age, $sex); # $this will be blessed up in the hierarchies!

    foreach my $key ( keys %fields ) {
        $this->{'permitted'}->{$key} = 1; # just define!
    }

    foreach my $key ( keys %fields ) {
        $this->{$key} = $fields{$key}; # field creation & initial value
    }

    my $initializer = $CurrentClass . '::_init';
    $this->$initializer($id, $salary);

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

    my $id = shift;
    my $salary = shift;

    $this->id($id); #scalar
    $this->salary($salary); # scalar
}

sub print {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    $this->SUPER::print(); # invokes base-class's version first!
    printf("          id= %s, salary= %s\n", $this->id(), $this->salary());
}


#1;
}



# ----------------------------------------------------------------------------
# main.pl
# ----------------------------------------------------------------------------
package main;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

#use Employee; # user-defined module

my @array = (
    [qw( Jane   32 0 0 100 )],
    [qw( Thomas 32 1 1 200 )],
    [qw( Daniel 32 1 2 300 )],
    [qw( Chalie 32 1 3 400 )],
    [qw( Stella 32 0 4 500 )],
);

my @objects;
for(my $i = 0; $i < @array; $i++) {
    my $object = Employee->new( @{$array[$i]} );
    push( @objects, $object);
}

for(my $i = 0; $i < @objects; $i++) {
    printf("object[%d] ", $i);
    $objects[$i]->print();
}

__END__
object[0] name= Jane, age= 32, sex= 0
          id= 0, salary= 100
object[1] name= Thomas, age= 32, sex= 1
          id= 1, salary= 200
object[2] name= Daniel, age= 32, sex= 1
          id= 2, salary= 300
object[3] name= Chalie, age= 32, sex= 1
          id= 3, salary= 400
object[4] name= Stella, age= 32, sex= 0
          id= 4, salary= 500
