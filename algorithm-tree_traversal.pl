# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : algorithm-tree_traversal.pl
# Description : 
# Author : yc0325lee
# Created : 2019-01-09 00:36:00 by yc0325lee
# Modified : 2019-01-10 00:55:29 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

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
                Shape__Cylinder => {},
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
    UniversityMember => {
        Employee => {
            Faculty => {
                Administrator => {
                    AdministratorTeacher => {},
                },
                Teacher => {
                    AdministratorTeacher => {},
                },
            },
            Staff => {},
        },
        Student => {
            GraduateStudent => {
                DoctoralStudent => {},
                MastersStudent => {},
            },
            UndergraduateStudent => {
                Freshman => {},
                Junior => {},
                Senior => {},
                Sophomore => {},
            },
        },
        Alumnus => {},
    },
    exception => {
        runtime_error => {
            overflow_error => {},
            underflow_error => {},
        },
        logic_error => {
            invalid_argument => {},
            length_error => {},
            out_of_range => {},
        },
        bad_alloc => {},
        bad_cast => {},
        bad_type_id => {},
        bad_exception => {},
    },
};

# traversal
foreach my $rootName ( sort keys %{$href__hierarchy} ) {
    visit_node($href__hierarchy->{$rootName}, $rootName);
    #          -----------------------------  ---------
    #                     $this                 $name
}


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

    printf("[info] visiting node %s", $name);
    printf(" (%s)", 'root') if( __is_root_node($this) );
    printf(" (%s)", 'leaf') if( __is_leaf_node($this) );
    printf(" ...\n");

    my $i = 0; # n-th child
    foreach my $childName ( sort keys %{$this} ) {
        visit_node($this->{$childName}, $childName );
        $i++;
    }

    pop( @nodeStack );
}

__END__
[info] visiting node Meridian__Common (root) ...
[info] visiting node Meridian__RuleBase ...
[info] visiting node Meridian__MultiPathRule ...
[info] visiting node Meridian__INTERFACE (leaf) ...
[info] visiting node Meridian__U_INTERFACE (leaf) ...
[info] visiting node Meridian__W_GLITCH (leaf) ...
[info] visiting node Meridian__W_INTERFACE (leaf) ...
[info] visiting node Meridian__W_RECON_GROUPS (leaf) ...
[info] visiting node Meridian__SinglePathRule ...
[info] visiting node Meridian__CNTL (leaf) ...
[info] visiting node Meridian__DATA (leaf) ...
[info] visiting node Meridian__W_CNTL (leaf) ...
[info] visiting node Meridian__W_DATA (leaf) ...
[info] visiting node Shape__Common (root) ...
[info] visiting node Shape__Base ...
[info] visiting node Shape__OneDimensional ...
[info] visiting node Shape__Dot (leaf) ...
[info] visiting node Shape__Line (leaf) ...
[info] visiting node Shape__ThreeDimensional ...
[info] visiting node Shape__Cube (leaf) ...
[info] visiting node Shape__Cylinder (leaf) ...
[info] visiting node Shape__Sphere (leaf) ...
[info] visiting node Shape__Tetrahedron (leaf) ...
[info] visiting node Shape__TwoDimensional ...
[info] visiting node Shape__Circle (leaf) ...
[info] visiting node Shape__Square (leaf) ...
[info] visiting node Shape__Triangle (leaf) ...
[info] visiting node UniversityMember (root) ...
[info] visiting node Alumnus (leaf) ...
[info] visiting node Employee ...
[info] visiting node Faculty ...
[info] visiting node Administrator ...
[info] visiting node AdministratorTeacher (leaf) ...
[info] visiting node Teacher ...
[info] visiting node AdministratorTeacher (leaf) ...
[info] visiting node Staff (leaf) ...
[info] visiting node Student ...
[info] visiting node GraduateStudent ...
[info] visiting node DoctoralStudent (leaf) ...
[info] visiting node MastersStudent (leaf) ...
[info] visiting node UndergraduateStudent ...
[info] visiting node Freshman (leaf) ...
[info] visiting node Junior (leaf) ...
[info] visiting node Senior (leaf) ...
[info] visiting node Sophomore (leaf) ...
[info] visiting node exception (root) ...
[info] visiting node bad_alloc (leaf) ...
[info] visiting node bad_cast (leaf) ...
[info] visiting node bad_exception (leaf) ...
[info] visiting node bad_type_id (leaf) ...
[info] visiting node logic_error ...
[info] visiting node invalid_argument (leaf) ...
[info] visiting node length_error (leaf) ...
[info] visiting node out_of_range (leaf) ...
[info] visiting node runtime_error ...
[info] visiting node overflow_error (leaf) ...
[info] visiting node underflow_error (leaf) ...
