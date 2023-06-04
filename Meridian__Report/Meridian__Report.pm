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

use Meridian__Common;
use Meridian__INTERFACE;
use Meridian__U_INTERFACE;
use Meridian__W_GLITCH;
use Meridian__W_INTERFACE;
use Meridian__W_RECON_GROUPS;
use Meridian__CNTL;
use Meridian__DATA;
use Meridian__W_CNTL;
use Meridian__W_DATA;

# __ADDON_IMPORT_BEGIN__
foreach my $addonFile (qw(
    Meridian__RuleBase-addons.pl
    Meridian__RuleBase-sort_criteria.pl
    Meridian__SinglePathRule-addons.pl
    Meridian__MultiPathRule-addons.pl
)) {
    confess "[erro] $addonFile not exist!" unless( -e $addonFile );
    print "[info] importing $addonFile ...\n";

    #my $done = do $addonFile; # cannot see lexicals in this file!
    #unless( $done ) {
    #    confess "[erro] Cannot compile $addonFile: $@" if( $@ );
    #}

    my $done = eval `cat $addonFile`; # addonFile compiled in this scope!
    unless( $done ) {                 # -> must use this for $a & $b
        confess "[erro] cannot compile $addonFile: $@" if( $@ );
    }
}

# warn "couldn't parse $file: $@" if $@;
# warn "couldn't do $file: $!"    unless defined $return;
# warn "couldn't run $file"       unless $return;
# __ADDON_IMPORT_END__


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
