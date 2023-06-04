# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__README.pm
# - author : yc0325lee
# - created : 2022-10-23 13:29:14 by lee2103
# - modified : 2022-10-23 13:29:14 by lee2103
# - description : 
# ----------------------------------------------------------------------------
#
# - inheritance hierarchy
# 
#     Meridian__Common
#     |   
#     +---Meridian__RuleBase           ::initialize_globals() ----+
#     |   |                            ::write_header()           |
#     |   |                            ::calcLen()                |
#     |   |                            ::write_rpt()              |
#     |   |                            ::write_csv()              |
#     |   |                            ::print()                  |
#     |   |                            ::sort_criterion()         |
#     |   |                                                       |
#     |   +---Meridian__MultiPathRule  ::is_SinglePathRule()      |
#     |   |   |                        ::is_MultiPathRule()       |
#     |   |   |                                                   | all leaf-classes share
#     |   |   +---Meridian__INTERFACE                             | these functions!
#     |   |   |                                                   | -> smaller number of lines!
#     |   |   +---Meridian__U_INTERFACE                           |
#     |   |   |                                                   |
#     |   |   +---Meridian__W_GLITCH                              |
#     |   |   |                                                   |
#     |   |   +---Meridian__W_INTERFACE                           |
#     |   |   |                                                   |
#     |   |   +---Meridian__W_RECON_GROUPS                        |
#     |   |                                                       |
#     |   +---Meridian__SinglePathRule ::is_SinglePathRule()      |
#     |       |                        ::is_MultiPathRule()   ----+
#     |       |
#     |       +---Meridian__CNTL
#     |       |   
#     |       +---Meridian__DATA
#     |       |   
#     |       +---Meridian__W_CNTL
#     |       |   
#     |       +---Meridian__W_DATA
#     |
#     +---Meridian__Report    ::read_rpt()
#                             ::write_tab()
#                             ::write_csv()
#                             ::write_rpt()
#
#
# - each rule's attributes(fields)
# ; set in the middle of importing report dynamically
#
# ----------------------------------------------------------------------------
{
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__RuleBase.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__RuleBase;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__Common );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__RuleBase = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__RuleBase ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__RuleBase{$datum}}; # read-only
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
}
{
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__InterfaceBase.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__InterfaceBase;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__MultiPathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__InterfaceBase = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__InterfaceBase ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__InterfaceBase{$datum}}; # read-only
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__INTERFACE.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__INTERFACE;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__InterfaceBase );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__INTERFACE = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__INTERFACE ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__INTERFACE{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__U_INTERFACE.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__U_INTERFACE;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__InterfaceBase );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__U_INTERFACE = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__U_INTERFACE ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__U_INTERFACE{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__W_INTERFACE.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__W_INTERFACE;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__InterfaceBase );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__W_INTERFACE = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_INTERFACE ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_INTERFACE{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__W_GLITCH.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__W_GLITCH;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__MultiPathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__W_GLITCH = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_GLITCH ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_GLITCH{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__W_RECON_GROUPS.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__W_RECON_GROUPS;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__MultiPathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__W_RECON_GROUPS = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_RECON_GROUPS ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_RECON_GROUPS{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__SinglePathRule.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__SinglePathRule;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
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
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__SinglePathRule ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__SinglePathRule{$datum}}; # read-only
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__CNTL.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__CNTL;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__SinglePathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__CNTL = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__CNTL ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__CNTL{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__DATA.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__DATA;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__SinglePathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__DATA = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__DATA ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__DATA{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__W_CNTL.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__W_CNTL;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__SinglePathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__W_CNTL = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_CNTL ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_CNTL{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__W_DATA.pm
# - description : 
# - author : lee2103
# - created : 2022-10-23 21:57:06 by lee2103
# - modified : 2022-10-23 21:57:06 by lee2103
# ----------------------------------------------------------------------------
package Meridian__W_DATA;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals - class data
our $VERSION = 0.00;
our @ISA = qw( Meridian__SinglePathRule );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;
our $maxLen = {};

our %Meridian__W_DATA = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals - instance data
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_DATA ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_DATA{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__Report.pm
# Description : 
# Author : yc0325lee
# Created : 2018-12-16 14:38:17 by yc0325lee
# Modified : 2019-01-10 00:49:14 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__Report;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__RuleBase-members.pm
# Description : 
# Author : yc0325lee
# Created : 2018-12-18 22:59:26 by yc0325lee
# Modified : 2019-01-09 22:59:07 by yc0325lee
# ----------------------------------------------------------------------------

# -------------------------------------
# class methods
sub Meridian__RuleBase::initialize_class_data {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) { $class->maxLen($attr,length($attr)); }
}

sub Meridian__RuleBase::write_header {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) {
        printf("%-*s  ", $class->maxLen($attr), $attr);
    }
    printf("\n");
    foreach my $attr ( @attributes ) {
        printf("%-*s  ", $class->maxLen($attr), '-' x $class->maxLen($attr));
    }
    printf("\n");
}


# -------------------------------------
# instance methods
sub Meridian__RuleBase::calcLen {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my @attributes = $ThisClass->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    return unless( @attributes );
    
    my $firstAttr = $attributes[0];
    for(my $i = 0; $i < @{$this->$firstAttr()}; $i++) {
        foreach my $attr ( @attributes ) {
            my $value = $this->$attr()->[$i];
            if( length($value) > $this->maxLen($attr) ) {
                $this->maxLen($attr,length($value));
            }
        }
    }
}

sub Meridian__RuleBase::write_rpt {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    printf("[info] invoking %s() for %s ...\n", $thisFunction, $ThisClass) if( 0 );
    my @attributes = $ThisClass->attributes(); # each class's attributes
    return unless( @attributes );

    my $firstAttr = $attributes[0];
    for(my $i = 0; $i < @{$this->$firstAttr()}; $i++) {
        foreach my $attr ( @attributes ) {
            printf("%-*s  ", $this->maxLen($attr), $this->$attr()->[$i]);
        }
        printf("\n");
    }
}

sub Meridian__RuleBase::write_csv {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    printf("[info] invoking %s() for %s ...\n", $thisFunction, $ThisClass) if( 0 );
    my @attributes = $ThisClass->attributes(); # each class's attributes
    return unless( @attributes );

    my $firstAttr = $attributes[0];
    for(my $i = 0; $i < @{$this->$firstAttr()}; $i++) {
        my @array;
        foreach my $attr ( @attributes ) {
            push( @array, $this->$attr()->[$i] );
        }
        print join(',', @array), "\n";
    }
}

sub Meridian__RuleBase::print {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    my @attributes = $ThisClass->attributes(); # each class's attributes
    print "[info] printing ", $this, " ...\n";
}


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__RuleBase-sort_criteria.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-21 00:23:55 by yc0325lee
# Modified : 2019-01-09 22:59:21 by yc0325lee
# ----------------------------------------------------------------------------


# ------------------------------------------------
# $a & $b are package globals of Meridian__Report!
our $href__sort_criteria = {
    Meridian__CNTL => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__DATA => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__W_CNTL => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__W_DATA => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__INTERFACE => sub { $a->Signal()->[0] cmp $b->Signal()->[0] },
    Meridian__U_INTERFACE => sub { $a->Signal()->[0] cmp $b->Signal()->[0] },
    Meridian__W_INTERFACE => sub { $a->Signal()->[0] cmp $b->Signal()->[0] },
    Meridian__W_GLITCH => sub { $a->VictimFlop()->[0] cmp $b->VictimFlop()->[0] },
    Meridian__W_RECON_GROUPS => sub { $a->ReconPoint()->[0] cmp $b->ReconPoint()->[0] },
};

sub Meridian__RuleBase::sort_criterion {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );
    my $thisFunction = (caller(0))[3];

    return $href__sort_criteria->{$class};
}


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__SinglePathRule-addons.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-19 23:05:20 by yc0325lee
# Modified : 2019-01-09 22:59:14 by yc0325lee
# ----------------------------------------------------------------------------

# -------------------------------------
# class methods
sub Meridian__SinglePathRule::is_SinglePathRule {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );
    return 1; # true
}

sub Meridian__SinglePathRule::is_MultiPathRule {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );
    return 0; # false
}


# -------------------------------------
# instance methods


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__MultiPathRule-addons.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-19 23:07:56 by yc0325lee
# Modified : 2019-01-09 22:59:00 by yc0325lee
# ----------------------------------------------------------------------------

# -------------------------------------
# class methods
sub Meridian__MultiPathRule::is_SinglePathRule {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );
    return 0; # false
}

sub Meridian__MultiPathRule::is_MultiPathRule {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );
    return 1; # true
}


# -------------------------------------
# instance methods




# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( Meridian__Common );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $Debug = 0;
our $count = 0;

our $maxLen = {};
our $regex__rule;

our %Meridian__Report = (
  count => \$count,
); # class attribute


# -------------------------------------
# file-scoped lexicals
my @attributes = qw(
    Meridian__CNTL
    Meridian__DATA
    Meridian__W_CNTL
    Meridian__W_DATA
    Meridian__INTERFACE
    Meridian__U_INTERFACE
    Meridian__W_INTERFACE
    Meridian__W_GLITCH
    Meridian__W_RECON_GROUPS
); # object attributes

foreach my $attr ( @attributes ) { # init $maxLen
    $maxLen->{$attr} = length($attr);
}

our @rules = @attributes;
foreach my $rule ( @rules ) { $rule =~ s/Meridian__//; }
my $joined = join('|', @rules);
$regex__rule = qr{$joined}; # init $regex__rule


# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__Report ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[erro] trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__Report{$datum}}; # read-only
    }
}

sub AUTOLOAD {
    my $this = shift;
    confess("[erro] instance method!") unless( ref($this) );
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
    @_==1 or confess "[erro]";
    my $either = shift;
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
sub initialize_class_data {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) { $class->maxLen($attr,length($attr)); }
}

sub new {
    @_==2 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );

    my $inFile = shift;

    my $this = $class->SUPER::new($inFile); # $this will be blessed up in the hierarchies!

    foreach my $attr ( @attributes ) { $this->{'permitted'}->{$attr} = 1; } # define!
    foreach my $attr ( @attributes ) { $this->{$attr} = undef; } # create!

    my $initializer = $CurrentClass . "::__init__";
    $this->$initializer($inFile);

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

    my $inFile = shift;

    foreach my $attr ( @attributes ) {
        $this->$attr( [] );
        $attr->initialize_class_data(); # $attr -> classname
    }

    $this->read_rpt($inFile);
}

our @attrName; # global -> __swallow_line() can access this
sub __swallow_line {
    @_==3 or confess "[erro]";
    my $href__chunk = shift;
    my $aref__attrName = shift;
    my $aref__attrValue = shift;

    for(my $i = 0; $i < @{$aref__attrName}; $i++) {
        my $attr = $aref__attrName->[$i];
        my $value = $aref__attrValue->[$i];
        if( $attr eq 'RuleName' ) {
            $value =~ s/:$//; # remove colon(:) in $rulename
        }
        push( @{$href__chunk->{$attr}}, $value );
        # ------------------------------------------------------------------
        # $href__chunk->{'attr0'} = [qw( val00, val01, val02, val03, ... )];
        # $href__chunk->{'attr1'} = [qw( val10, val11, val12, val13, ... )];
        # $href__chunk->{'attr2'} = [qw( val20, val21, val22, val23, ... )];
        # ... ... 
        # ... ... 
        # ------------------------------------------------------------------
    }
}

sub read_rpt {
    @_==2 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $inFile = shift;
    
    print "[info] reading ", $inFile, " ...\n";
    open(my $inFH, '<', $inFile) or confess "[erro]";
    while( <$inFH> ) {
        if( 0 ) { }
        elsif( m/^RuleName/ ) {
            @attrName = split;
        }
        # -------------------------------------------------
        # elsif( m/^($regex__single):/ ) {
        #     my $rulename = $1;
        #     my $classname = 'Meridian__' . $rulename;
        #     my $href__chunk = {};
        #     __swallow_line($href__chunk);
        #     my $ruleInst = $classname->new($href__chunk);
        #     push( @{$this->$classname}, $ruleInst );
        # }
        # elsif( m/^($regex__multiple):/ ) {
        #     my $rulename = $1;
        #     my $classname = 'Meridian__' . $rulename;
        #     my $href__chunk = {};
        #     __swallow_line($href__chunk);
        #     $_ = <$inFH>;
        #     while( m/^($rulename):/ ) {
        #         __swallow_line($href__chunk);
        #         $_ = <$inFH>;
        #     }
        #     my $ruleInst = $classname->new($href__chunk);
        #     push( @{$this->$classname}, $ruleInst );
        # }
        # -------------------------------------------------
        elsif( m/^($regex__rule):/ ) {
            my $rulename = $1;
            my $classname = 'Meridian__' . $rulename;
            my $href__chunk = {};
            my @attrValue;

            # - dynamic attributes - for the first time encounter
            # ; $classname->attributes() must be empty initially!
            unless( $classname->attributes() > 0 ) {
                $classname->attributes(@attrName);
                $classname->initialize_class_data();
            }

            s/\s+\././g; # remove unexpected whitespaces due to genblk label
            @attrValue = split;
            __swallow_line($href__chunk, \@attrName, \@attrValue);
            if( $classname->is_MultiPathRule() ) { # consume more lines!
                $_ = <$inFH>;
                while( m/^($rulename):/ ) {
                    s/\s+\././g; # remove unexpected whitespaces due to genblk label
                    @attrValue = split;
                    __swallow_line($href__chunk, \@attrName, \@attrValue);
                    $_ = <$inFH>;
                }
            }
            my $ruleInst = $classname->new($href__chunk);
            push( @{$this->$classname}, $ruleInst );
        }
        else {
            # do_nothing();
        }
    }
    close($inFH) or confess "[erro]";

    #$this->SUPER::print();
    #$this->dump();
}

sub write_tab {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    foreach my $attr ( @attributes ) {
        my $classname = $attr;
        my $rulename = $classname; $rulename =~ s/Meridian__//;
        my $aref_tab = [];
        my @attributes = $classname->attributes();

        next unless( $classname->count() ); # don't do if there's no item

        printf("\n# %s - %d\n", $rulename, $classname->count());

        push( @{$aref_tab}, \@attributes ); # header
        my $aref_inst = $this->$attr();
        my $sortFunc = $classname->sort_criterion();
        my $i = 0;
        foreach my $ruleInst ( sort $sortFunc @{$aref_inst} ) {
            for(my $i = 0; $i < @{$ruleInst->RuleName()}; $i++) {
                my $aref_row = [];
                foreach my $attr ( @attributes ) {
                    push( @{$aref_row}, $ruleInst->$attr()->[$i] );
                }
                push( @{$aref_tab}, $aref_row ); # row[$i]
            }
            if(
                $attr->is_MultiPathRule()  && # -> multi-path rule!
                $i != $#$aref_inst # -> no delimitter for the last inst!
            ) {
                push( @{$aref_tab}, [] ); # empty-row as delimitter!
            }
            $i++;
        }
        $attr->write_ascii_table($aref_tab);
    }
}

sub write_csv {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    foreach my $attr ( @attributes ) {
        my $classname = $attr;
        my $rulename = $classname; $rulename =~ s/Meridian__//;
        my @attributes = $classname->attributes();

        next unless( $classname->count() ); # don't do if there's no item

        printf("\n# %s - %d\n", $rulename, $classname->count());
        print join(',', @attributes), "\n";
        my $aref_inst = $this->$attr();
        my $sortFunc = $classname->sort_criterion();
        my $i = 0;
        foreach my $ruleInst ( sort $sortFunc @{$aref_inst} ) {
            $ruleInst->write_csv();
            if(
                $attr->is_MultiPathRule()  && # -> multi-path rule!
                $i != $#$aref_inst # -> no delimitter for the last inst!
            ) {
                printf("%s\n", ',' x $#attributes); # empty-row as delimitter!
            }
            $i++;
        }
    }
}

sub write_rpt {
    @_==1 or confess "[erro]";
    my $this = shift; # blessed-ref
    confess("[erro] class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    foreach my $attr ( @attributes ) {
        my $classname = $attr;
        my $rulename = $classname; $rulename =~ s/Meridian__//;
        my @attributes = $classname->attributes();

        next unless( $classname->count() ); # don't do if there's no item

        printf("\n# %s - %d\n", $rulename, $classname->count());
        $classname->write_header();
        my $aref_inst = $this->$attr();
        my $sortFunc = $classname->sort_criterion();
        my $i = 0;
        foreach my $ruleInst ( sort $sortFunc @{$aref_inst} ) {
            $ruleInst->write_rpt();
            if(
                $attr->is_MultiPathRule()  && # -> multi-path rule!
                $i != $#$aref_inst # -> no delimitter for the last inst!
            ) {
                printf("\n"); # empty-row as delimitter!
            }
            $i++;
        }
    }
}


1;
}
