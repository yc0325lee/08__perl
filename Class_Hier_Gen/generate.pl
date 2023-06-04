# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : do_generation.pl
# Description : 
# Author : yc0325lee
# Created : 2018-11-19 23:24:03 by prince2103
# Modified : 2018-12-16 01:04:17 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

# remember the DATA position!
our $offset = tell(DATA);


# class inheritance hierarchies
our $href__hierarchy = {
    Shape__Common => {
        Shape__Base => {
            Shape__OneDimensional => {
                Shape__Dot => {},
                Shape__Line => {},
            },
            Shape__TwoDimensional => {
                Shape__Circle => {},
                Shape__Square => {},
                Shape__Triangle => {},
            },
            Shape__ThreeDimensional => {
                Shape__Sphere => {},
                Shape__Cube => {},
                Shape__Tetrahedron => {},
            },
        },
    },
    Meridian__Common => {
        Meridian__RuleBase => {
            Meridian__SinglePathRule => {
                Meridian__CNTL => {},
                Meridian__DATA => {},
                Meridian__W_CNTL => {},
                Meridian__W_DATA => {},
            },
            Meridian__MultiPathRule => {
                Meridian__INTERFACE => {},
                Meridian__U_INTERFACE => {},
                Meridian__W_INTERFACE => {},
                Meridian__W_GLITCH => {},
                Meridian__W_RECON_GROUPS => {},
            },
        },
    },
};

# attributes of each class
our $href__attribute = {
    # Shape
    Shape__Common => [qw(  )],
    Shape__Base => [qw( name color )],
    Shape__OneDimensional => [qw(  )], # Shape__OneDimensional
    Shape__Dot => [qw( thickness )],
    Shape__Line => [qw( length )],
    Shape__TwoDimensional => [qw(  )], # Shape__TwoDimensional
    Shape__Circle => [qw( radius )],
    Shape__Square => [qw( sideLength )],
    Shape__Triangle => [qw( baseLength height )],
    Shape__ThreeDimensional => [qw(  )], # Shape__ThreeDimensional
    Shape__Sphere => [qw( radius )],
    Shape__Cube => [qw( edgeLength )],
    Shape__Tetrahedron => [qw( edgeLength )],

    # Meridian
    Meridian__Common => [qw(  )],
    Meridian__RuleBase => [qw(  )],
    Meridian__SinglePathRule => [qw(  )],
    Meridian__CNTL => [qw(  )],
    Meridian__DATA => [qw(  )],
    Meridian__W_CNTL => [qw(  )],
    Meridian__W_DATA => [qw(  )],
    Meridian__MultiPathRule => [qw(  )],
    Meridian__INTERFACE => [qw(  )],
    Meridian__U_INTERFACE => [qw(  )],
    Meridian__W_INTERFACE => [qw(  )],
    Meridian__W_GLITCH => [qw(  )],
    Meridian__W_RECON_GROUPS => [qw(  )],
};


our $template_common = <<'END_OF_COMMON';
package __SOMECLASS__;

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
    @_==1 or confess "";
    my $either = shift; # class or object

    my ($sec, $min, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];
    $year += 1900;
    $month += 1;

    return sprintf("%04d%02d%02d_%02d%02d%02d",
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

    # do_nothing(); -> not used
}

sub dump {
    @_==1 or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    print Dumper($this), "\n"; # implement your own!
}

sub get_csv_object {
    @_==1 or confess "";
    my $either = shift; # class or object

    return Text::CSV->new({
        binary => 1,
        auto_diag => 1,
        allow_whitespace => 1,
    });
}

sub get_tab_object {
    @_==1 or confess "";
    my $either = shift; # class or object

    #return Text::Table->new();
}

sub write_table {
    @_==2 or confess "";
    my $either = shift; # class or object
    my $aref = shift;

    #print generate_table( rows => $aref ), "\n";
    #print generate_table( rows => $aref ), "\n";
    print generate_table( rows => $aref, header_row => 1 ), "\n";
    #print generate_table( rows => $aref, header_row => 1, separate_rows => 1 ), "\n";
}


1;
END_OF_COMMON



# -------------------------------------
# main

traverse($href__hierarchy);


# -------------------------------------
# Subroutines
# -------------------------------------
our $args_num_parent = 0;
our $args_num_myself = 0;

our @packageStack; # to calculate num_of_args!

sub __args_num_parent {
    my $count = 0;
    for(my $i = 0; $i < $#packageStack; $i++) {
        $count += @{$href__attribute->{$packageStack[$i]}};
    }
    return $count;
}
sub __args_num_myself {
    my $count = 0;
    for(my $i = 0; $i <= $#packageStack; $i++) {
        $count += @{$href__attribute->{$packageStack[$i]}};
    }
    return $count;
}

sub __now {
    my ($sec, $min, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];
    $year += 1900;
    $month += 1;
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d",
        $year, $month, $day, $hour, $min, $sec);
}

sub __write_header {
    @_==2 or confess "";
    my $outFH = shift;
    my $filename = shift;

    my $user = `whoami`; chomp($user);
    my $now = __now();

    print $outFH <<"END_OF_HEADER";
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : $filename
# Description : 
# Author : $user
# Created : $now by $user
# Modified : $now by $user
# ----------------------------------------------------------------------------
END_OF_HEADER
}

sub __is_root_node {
    @_==1 or confess "";
    my $href = shift;
    return @packageStack == 1;
}

sub __is_leaf_node {
    @_==1 or confess "";
    my $href = shift;
    return !(keys %{$href}); # if there is no child!
}

our @leaves; # let's store the name of leaf-node!

sub traverse {
    @_==1 or confess "";
    my $href = shift;

    confess "" unless( ref($href) );


    foreach my $myself ( sort keys %{$href} ) {
        push( @packageStack, $myself );

        # write parent-first & child-later!
        if( __is_root_node($href->{$myself}) ) {
            write_root_class(undef, $myself);
        }
        else {
            # ----------------------------------------- #
            # $packageStack[$#packageStack-1] -> parent #
            # $packageStack[$#packageStack] -> myself   #
            # ----------------------------------------- #
            my $parent = $packageStack[$#packageStack-1];
            write_leaf_class($parent, $myself);

            if( __is_leaf_node($href->{$myself}) ) {
                printf("[debug] %s is leaf-node!\n", $myself) if(1);
                push(@leaves, $myself);
            }
        }

        traverse( $href->{$myself} );

        # write_main()
        if( __is_root_node($href->{$myself}) ) {
            write_main(\@leaves);
            $#leaves = -1; # empty
        }

        pop( @packageStack );
    }
}

sub write_root_class {
    @_==2 or confess "";
    my $parent = shift;
    my $myself = shift;

    my $inFile = 'Someclass__Common.pm';
    my $outFile = $myself . '.pm';

    print "[info] writing $outFile ...\n";
    open(my $outFH, '>', $outFile) or confess "";
    __write_header($outFH, $outFile);
    my $lines = $template_common;
    $lines =~ s/__SOMECLASS__/$myself/g;
    print $outFH $lines;
    close($outFH) or confess "";
}

sub write_leaf_class {
    @_==2 or confess "";
    my $parent = shift;
    my $myself = shift;

    my $outFile = $myself . '.pm';

    print "[info] writing $outFile ...\n";
    open(my $outFH, '>', $outFile) or confess "";

    __write_header($outFH, $outFile); # header

    seek(DATA, $offset, 0); # rewind DATA handle!
    while( <DATA> ) {
        s/__SOMECLASS__/$myself/g;

        if( m/__BASECLASS__/ ) {
            if( defined $parent ) {
                s/__BASECLASS__/$parent/g;
            }
            else {
                s/__BASECLASS__//g;
                next if( m/^use/ );
            }
        }

        s/__NEW_NUM_ARGS__/sprintf("%d", __args_num_myself()+1)/eg;
        s/__INIT_NUM_ARGS__/sprintf("%d", __args_num_myself()-__args_num_parent()+1)/eg;


        if( 0 ) { }
        elsif( m/__ATTRIBUTES__/ ) {
            die "" unless( exists $href__attribute->{$myself} );
            my @arguments;
            push( @arguments, @{$href__attribute->{$myself}} );
            foreach my $attr ( @arguments ) {
                printf($outFH "    %s => undef,\n", $attr);
            }
        }
        elsif( m/__NEW_ARGS_PASS__/ ) {
            my @arguments;
            for(my $i = 0; $i <= $#packageStack; $i++) { # current-class included
                die "" unless( exists $href__attribute->{$packageStack[$i]} );
                push( @arguments, @{$href__attribute->{$packageStack[$i]}} );
            }
            foreach my $attr ( @arguments ) {
                printf($outFH "    my \$%s = shift;\n", $attr);
            }
        }
        elsif( m/__ARGS_TO_BASE_NEW__/ ) {
            my @arguments;
            for(my $i = 0; $i < $#packageStack; $i++) { # base-classes' only
                die "" unless( exists $href__attribute->{$packageStack[$i]} );
                push( @arguments, @{$href__attribute->{$packageStack[$i]}} );
            }
            foreach my $attr ( @arguments ) {
                printf($outFH "        \$%s,\n", $attr);
            }
        }
        elsif( m/__ARGS_TO_INIT__/ ) { # current-class only
            my @arguments;
            push( @arguments, @{$href__attribute->{$myself}} );
            foreach my $attr ( @arguments ) {
                printf($outFH "        \$%s,\n", $attr);
            }
        }
        elsif( m/__INIT_ARGS_PASS__/ ) {
            my @arguments;
            push( @arguments, @{$href__attribute->{$myself}} );
            foreach my $attr ( @arguments ) {
                printf($outFH "    my \$%s = shift;\n", $attr);
            }
        }
        elsif( m/__INIT_ARGS_SET__/ ) {
            my @arguments;
            push( @arguments, @{$href__attribute->{$myself}} );
            foreach my $attr ( @arguments ) {
                printf($outFH "    \$this->%s(\$%s);\n", $attr, $attr);
            }
        }
        else {
            print $outFH $_; # default echo
        }
    }

    close($outFH) or confess "";
}

sub write_main {
    @_==1 or confess "";
    my $aref_leaf = shift;

    my $prefix = $aref_leaf->[0];
    $prefix =~ s/__.+//;
    my $outFile = 'main_' . $prefix . '.pl';

    print "[info] writing $outFile ...\n";
    open(my $outFH, '>', $outFile) or confess "";
    __write_header($outFH, $outFile); # header

    print $outFH <<'END_OF_MAIN';
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

END_OF_MAIN

    foreach my $leaf ( @{$aref_leaf} ) {
        printf($outFH "use %s;\n", $leaf);
    }

    print $outFH <<'END_OF_MAIN';

my @array = (
END_OF_MAIN

    foreach my $leaf ( @{$aref_leaf} ) {
        printf($outFH "    %s->new(%s),\n",
            $leaf,
            join(",", 0 .. @{$href__attribute->{$leaf}}-1)
            #         -    ------------------------------
            # range:  min ~ max
        );
    }

    print $outFH <<'END_OF_MAIN';
);

# polymorphism
for(my $i = 0; $i < @array; $i++) {
    $array[$i]->dump();
}
END_OF_MAIN

    close($outFH) or confess "";
}

sub write_main_181121_003416 {
    @_==0 or confess "";

    my $outFile = 'main.pl';

    print "[info] writing $outFile ...\n";
    open(my $outFH, '>', $outFile) or confess "";
    __write_header($outFH, $outFile); # header

    print $outFH <<'END_OF_MAIN';
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;

use Shape__Dot;
use Shape__Line;
use Shape__Circle;
use Shape__Square;
use Shape__Triangle;
use Shape__Sphere;
use Shape__Cube;
use Shape__Tetrahedron;

my @array = (
    Shape__Dot->new(0, 0, 0),
    Shape__Line->new(0, 0, 0),
    Shape__Circle->new(0, 0, 0),
    Shape__Square->new(0, 0, 0),
    Shape__Triangle->new(0, 0, 0, 0),
    Shape__Sphere->new(0, 0, 0),
    Shape__Cube->new(0, 0, 0),
    Shape__Tetrahedron->new(0, 0, 0),
);

# polymorphism
for(my $i = 0; $i < @array; $i++) {
    $array[$i]->dump();
}
END_OF_MAIN

    close($outFH) or confess "";
}

__END__
package __SOMECLASS__;

use strict;
use warnings;
use Carp;

use __BASECLASS__;

# -------------------------------------
# package globals
our $VERSION = 0.00;
our @ISA = qw( __BASECLASS__ );
our $CurrentClass = __PACKAGE__;
our $AUTOLOAD;

our $count = 0;

our %__SOMECLASS__ = (
  count => \$count,
); # class attribute

# -------------------------------------
# file-scoped lexicals
my %fields = (
    __ATTRIBUTES__
); # object attributes

# -------------------------------------
# special functions - don't touch
foreach my $datum ( keys %__SOMECLASS__ ) {
    no strict "refs";
    *{$datum} = sub {
        @_==1 or confess("[ERR ] Trying to modify read-only class attribute!");
        my $either = shift;
        return ${$__SOMECLASS__{$datum}}; # read-only
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
    @_==__NEW_NUM_ARGS__ or confess "";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    __NEW_ARGS_PASS__

    my $this = $class->SUPER::new(
        __ARGS_TO_BASE_NEW__
    ); # $this will be blessed up in the hierarchies!

    foreach my $key ( keys %fields ) { $this->{'permitted'}->{$key} = 1; } # define!
    foreach my $key ( keys %fields ) { $this->{$key} = $fields{$key}; } # create!

    my $initializer = $CurrentClass . '::_init';
    $this->$initializer(
        __ARGS_TO_INIT__
    );

    $count++;

    return $this;
}

# -------------------------------------
# instance methods
sub _init {
    @_==__INIT_NUM_ARGS__ or confess "";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    __INIT_ARGS_PASS__

    __INIT_ARGS_SET__
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
