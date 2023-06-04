# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : util__merge_packages.pl
# Description : 
# Author : yc0325lee
# Created : 2019-01-09 22:23:59 by yc0325lee
# Modified : 2019-01-10 00:54:10 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

# class inheritance hierarchies
our $href__hierarchy = {
    Meridian__README => {},
    Meridian__Common => {
        Meridian__RuleBase => {
            Meridian__SinglePathRule => {
                Meridian__CNTL => {},
                Meridian__DATA => {},
                Meridian__W_CNTL => {},
                Meridian__W_DATA => {},
            },
            Meridian__MultiPathRule => {
                Meridian__InterfaceBase => {
                    Meridian__INTERFACE => {},
                    Meridian__U_INTERFACE => {},
                    Meridian__W_INTERFACE => {},
                },
                Meridian__W_GLITCH => {},
                Meridian__W_RECON_GROUPS => {},
            },
        },
    },
    Meridian__Report => {},
};

visit_node($href__hierarchy->{'Meridian__README'}, 'Meridian__README');
visit_node($href__hierarchy->{'Meridian__Common'}, 'Meridian__Common'); # all packages recursively
visit_node($href__hierarchy->{'Meridian__Report'}, 'Meridian__Report');


# -------------------------------------
# Subroutines
# -------------------------------------
our @nodeStack;

sub __is_root_node {
    @_==1 or confess "";
    my $href = shift;
    return @nodeStack == 1;
}
sub __is_leaf_node {
    @_==1 or confess "";
    my $href = shift;
    return !(keys %{$href}); # if there is no child!
}
sub __depth { return @nodeStack-1; }

our @leaves; # let's store the name of leaf-node!

sub visit_node {
    @_==2 or confess "[err ]";
    my $this = shift;
    my $name = shift;

    push( @nodeStack, $this );

    printf(STDERR "[info] writing package %s ...\n", $name);
    print "{\n" unless( $name eq 'Meridian__README' ); # opening curly-brace
    write_package( $name . '.pm' );
    print "}\n" unless( $name eq 'Meridian__README' ); # closing curly-brace

    my $i = 0; # n-th child
    foreach my $childName ( sort keys %{$this} ) {
        visit_node($this->{$childName}, $childName );
        $i++;
    }

    pop( @nodeStack );
}

sub write_package {
    @_==1 or confess "[err ]";
    my $inFile = shift;
    confess "[err ]" unless( -e $inFile );
    
    open(my $inFH, '<', $inFile) or confess "[err ]";
    my @addonFiles;
    while( <$inFH> ) {
        next if( m/use Meridian__[^;]+;/ ); # skip
        if( $inFile eq 'Meridian__Report.pm' &&
            m/__ADDON_IMPORT_BEGIN__/ .. /__ADDON_IMPORT_END__/
        ) {
            if( 0 ) { }
            elsif( m/Meridian__.*\.pl/ ) {
                push( @addonFiles, (split)[0] ); # push addonFile in array
            }
            elsif( m/__ADDON_IMPORT_END__/ ) {
                foreach my $addonFile ( @addonFiles ) {
                    printf(STDERR "[info] writing addon %s ...\n", $addonFile);
                    write_package($addonFile); # recursive call!
                }
            }
            next; # ignore in-between
        }

        print; # default-echo
    }
    close($inFH) or confess "[err ]";
}

__END__
[info] writing package Meridian__README ...
[info] writing package Meridian__Common ...
[info] writing package Meridian__RuleBase ...
[info] writing package Meridian__MultiPathRule ...
[info] writing package Meridian__INTERFACE ...
[info] writing package Meridian__U_INTERFACE ...
[info] writing package Meridian__W_GLITCH ...
[info] writing package Meridian__W_INTERFACE ...
[info] writing package Meridian__W_RECON_GROUPS ...
[info] writing package Meridian__SinglePathRule ...
[info] writing package Meridian__CNTL ...
[info] writing package Meridian__DATA ...
[info] writing package Meridian__W_CNTL ...
[info] writing package Meridian__W_DATA ...
[info] writing package Meridian__Report ...
[info] writing addon Meridian__RuleBase-addons.pl ...
[info] writing addon Meridian__RuleBase-sort_criteria.pl ...
[info] writing addon Meridian__SinglePathRule-addons.pl ...
[info] writing addon Meridian__MultiPathRule-addons.pl ...
