# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : README.TXT
# Description : 
# Author : yc0325lee
# Created : 2018-12-18 00:04:17 by yc0325lee
# Modified : 2019-01-10 00:58:00 by yc0325lee
# ----------------------------------------------------------------------------
#
# o inheritance hierarchy
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
# ----------------------------------------------------------------------------
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__Common.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
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
# package globals
our $VERSION = 0.00;
our @ISA = qw( );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

# -------------------------------------
# universal methods
sub UNIVERSAL::now {
    @_==1 or confess "[ERR ]";
    my $either = shift; # class or object

    my ($sec, $min, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];
    $year += 1900;
    $month += 1;

    return sprintf("%04d%02d%02d_%02d%02d%02d",
        $year, $month, $day, $hour, $min, $sec);
}

sub UNIVERSAL::new {
    @_==2 or confess "[ERR ]";
    my $class = shift;
    my $anything = shift;
    my $this = {};
    return bless($this, $class); # blessed-href -> object
}

sub UNIVERSAL::__init__ {
    @_==1 or confess "[ERR ]";
    my $this = shift;

    # do_nothing(); -> not used
}

sub dump {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    print Dumper($this), "\n"; # implement your own!
}

sub get_csv_object {
    @_==1 or confess "[ERR ]";
    my $either = shift; # class or object

    return Text::CSV->new({
        binary => 1,
        auto_diag => 1,
        allow_whitespace => 1,
    });
}

sub get_tab_object {
    @_==1 or confess "[ERR ]";
    my $either = shift; # class or object

    #return Text::Table->new();
}

sub write_ascii_table {
    @_==2 or confess "[ERR ]";
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
# File : Meridian__RuleBase.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__RuleBase;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__RuleBase ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__RuleBase{$datum}}; # read-only
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__MultiPathRule.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__MultiPathRule;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__MultiPathRule ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__MultiPathRule{$datum}}; # read-only
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__InterfaceBase.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__InterfaceBase;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw(  ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__InterfaceBase ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__InterfaceBase{$datum}}; # read-only
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__INTERFACE.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__INTERFACE;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName Signal ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__INTERFACE ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__INTERFACE{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__U_INTERFACE.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__U_INTERFACE;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName Signal ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__U_INTERFACE ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__U_INTERFACE{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__W_INTERFACE.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__W_INTERFACE;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName Signal ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_INTERFACE ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_INTERFACE{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__W_GLITCH.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__W_GLITCH;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName DriverFlop VictimFlop ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_GLITCH ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_GLITCH{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__W_RECON_GROUPS.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__W_RECON_GROUPS;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName DriverFlop ReconPoint ReconDepth ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_RECON_GROUPS ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_RECON_GROUPS{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
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
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__CNTL.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__CNTL;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName TxFlop RxFlop ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__CNTL ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__CNTL{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__DATA.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__DATA;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName TxFlop RxFlop ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__DATA ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__DATA{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__W_CNTL.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__W_CNTL;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName TxFlop RxFlop ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_CNTL ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_CNTL{$datum}}; # read-only
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
    $this->calcLen(); # leaf-class only
}


1;
}
{
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__W_DATA.pm
# Description : 
# Author : yc0325lee
# Created : 2019-01-10 00:56:58 by yc0325lee
# Modified : 2019-01-10 00:56:58 by yc0325lee
# ----------------------------------------------------------------------------
package Meridian__W_DATA;

use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


# -------------------------------------
# package globals
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
# file-scoped lexicals
my @attributes = qw( RuleName TxFlop RxFlop ClockDomains Info ); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %Meridian__W_DATA ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__W_DATA{$datum}}; # read-only
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
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$Meridian__Report{$datum}}; # read-only
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

sub maxLen {
    (@_==2 || @_==3) or confess "[ERR ]";
    my $either = shift;
    my $attr = shift;

    $maxLen->{$attr} = shift if( @_ ); # set
    return $maxLen->{$attr}; # get
}


# -------------------------------------
# class methods
sub initialize_globals {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) { $class->maxLen($attr,length($attr)); }
}

sub new {
    @_==2 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

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
    @_==2 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $inFile = shift;

    foreach my $attr ( @attributes ) {
        $this->$attr( [] );
        $attr->initialize_globals(); # $attr -> classname
    }

    $this->read_rpt($inFile);
}

our @attrName; # global -> __swallow_line() can access this
sub __swallow_line {
    my $href = shift;
    my @attrValue = split;
    for(my $i = 0; $i < @attrName; $i++) {
        if( $attrName[$i] eq 'RuleName' ) {
            $attrValue[$i] =~ s/:$//; # remove colon(:) upon $rulename
        }
        push( @{$href->{$attrName[$i]}}, $attrValue[$i] );
    }
}

sub read_rpt {
    @_==2 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my $inFile = shift;
    
    print "[INFO] reading ", $inFile, " ...\n";
    open(my $inFH, '<', $inFile) or confess "[ERR ]";
    while( <$inFH> ) {
        if( 0 ) { }
        elsif( m/^RuleName/ ) {
            @attrName = split;
        }
        #elsif( m/^($regex__single):/ ) {
        #    my $rulename = $1;
        #    my $classname = 'Meridian__' . $rulename;
        #    my $href__chunk = {};
        #    __swallow_line($href__chunk);
        #    my $ruleInst = $classname->new($href__chunk);
        #    push( @{$this->$classname}, $ruleInst );
        #}
        #elsif( m/^($regex__multiple):/ ) {
        #    my $rulename = $1;
        #    my $classname = 'Meridian__' . $rulename;
        #    my $href__chunk = {};
        #    __swallow_line($href__chunk);
        #    $_ = <$inFH>;
        #    while( m/^($rulename):/ ) {
        #        __swallow_line($href__chunk);
        #        $_ = <$inFH>;
        #    }
        #    my $ruleInst = $classname->new($href__chunk);
        #    push( @{$this->$classname}, $ruleInst );
        #}
        elsif( m/^($regex__rule):/ ) {
            my $rulename = $1;
            my $classname = 'Meridian__' . $rulename;
            my $href__chunk = {};
            __swallow_line($href__chunk);
            if( $classname->is_MultiPathRule() ) { # consume more lines!
                $_ = <$inFH>;
                while( m/^($rulename):/ ) {
                    __swallow_line($href__chunk);
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
    close($inFH) or confess "[ERR ]";

    #$this->SUPER::print();
    #$this->dump();
}

sub write_tab {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
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
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    foreach my $attr ( @attributes ) {
        my $classname = $attr;
        my $rulename = $classname; $rulename =~ s/Meridian__//;
        my @attributes = $classname->attributes();

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
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    foreach my $attr ( @attributes ) {
        my $classname = $attr;
        my $rulename = $classname; $rulename =~ s/Meridian__//;
        my @attributes = $classname->attributes();

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
sub Meridian__RuleBase::initialize_globals {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) { $class->maxLen($attr,length($attr)); }
}

sub Meridian__RuleBase::write_header {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

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
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
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
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    printf("[INFO] Invoking %s() for %s ...\n", $thisFunction, $ThisClass) if( 0 );
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
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    printf("[INFO] Invoking %s() for %s ...\n", $thisFunction, $ThisClass) if( 0 );
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
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    my @attributes = $ThisClass->attributes(); # each class's attributes
    print "[INFO] printing ", $this, " ...\n";
}


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__RuleBase-sort_criteria.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-21 00:23:55 by yc0325lee
# Modified : 2019-01-09 22:59:21 by yc0325lee
# ----------------------------------------------------------------------------

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
}; # $a & $b are package globals of Meridian__Report!

sub Meridian__RuleBase::sort_criterion {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );
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
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );
    return 1;
}

sub Meridian__SinglePathRule::is_MultiPathRule {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );
    return 0;
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
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );
    return 0;
}

sub Meridian__MultiPathRule::is_MultiPathRule {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );
    return 1;
}


# -------------------------------------
# instance methods




1;
}
