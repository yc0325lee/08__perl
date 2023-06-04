# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : draw_tree.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-24 01:15:15 by yc0325lee
# Modified : 2019-06-17 23:49:15 by yc0325lee
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;


# class inheritance hierarchies
our $href__hierarchy = {

    Container => {
        Sequence => {
            MutableSequence => {
                __setitem__ => {},
                __delitem__ => {},
                insert => {},
                append => {},
                reverse => {},
                extend => {},
                pop => {},
                remove => {},
                __iadd__ => {},
            },
        },
    },

    #ios_base => {
    #    basic_ios => {
    #        basic_istream => {
    #            basic_ifstream => {
    #            },
    #        },
    #        basic_ostream => {
    #            basic_ofstream => {
    #            },
    #        },
    #    },
    #},

    #Vehicle => {
    #    LandVehicle => {
    #        FourWheelVehicle => {
    #            Car => {
    #                SportsCar => {},
    #                Truck => {},
    #                Estate => {},
    #            },
    #        },
    #        TwoWheelVehicle => {
    #            MotorCycle => {},
    #            Bicycle => {},
    #        },
    #    },
    #    WaterVehicle => {
    #        Boat => {
    #            SailingBoat =>{},
    #            MotorBoat =>{},
    #            CargoShip =>{},
    #        },
    #    },
    #    AirVehicle => {
    #        PoweredAirVehicle => {
    #            PropellerPlane => {},
    #            JetPlane => {},
    #        },
    #        UnpoweredAirVehicle => {
    #            Glider => {},
    #        },
    #    },
    #},
    #ios_base => {
    #    basic_ios => {
    #        basic_istream => {},
    #        basic_ostream => {},
    #    },
    #},
    #Employee => {
    #    SalariedEmployee => {
    #    },
    #    CommissionEmployee => {
    #        BasePlusCommissionEmployee => {
    #        },
    #    },
    #    HourlyEmployee => {
    #    },
    #},
    #Shape__Common => {
    #    Shape__Base => {
    #        Shape__OneDimensional => {
    #            Shape__Dot => {},
    #            Shape__Line => {},
    #        },
    #        Shape__TwoDimensional => {
    #            Shape__Circle => {},
    #            Shape__Square => {},
    #            Shape__Triangle => {},
    #        },
    #        Shape__ThreeDimensional => {
    #            Shape__Sphere => {},
    #            Shape__Cube => {},
    #            Shape__Cylinder => {},
    #            Shape__Tetrahedron => {},
    #        },
    #    },
    #},
    #Meridian__Common => {
    #    Meridian__RuleBase => {
    #        Meridian__SinglePathRule => {
    #            Meridian__CNTL => {},
    #            Meridian__DATA => {},
    #            Meridian__W_CNTL => {},
    #            Meridian__W_DATA => {},
    #        },
    #        Meridian__MultiPathRule => {
    #            Meridian__INTERFACE => {},
    #            Meridian__U_INTERFACE => {},
    #            Meridian__W_INTERFACE => {},
    #            Meridian__W_GLITCH => {},
    #            Meridian__W_RECON_GROUPS => {},
    #        },
    #    },
    #},
    #UniversityMember => {
    #    Employee => {
    #        Faculty => {
    #            Administrator => {
    #                AdministratorTeacher => {},
    #            },
    #            Teacher => {
    #                AdministratorTeacher => {},
    #            },
    #        },
    #        Staff => {},
    #    },
    #    Student => {
    #        GraduateStudent => {
    #            DoctoralStudent => {},
    #            MastersStudent => {},
    #        },
    #        UndergraduateStudent => {
    #            Freshman => {},
    #            Junior => {},
    #            Senior => {},
    #            Sophomore => {},
    #        },
    #    },
    #    Alumnus => {},
    #},
    #exception => {
    #    runtime_error => {
    #        overflow_error => {},
    #        underflow_error => {},
    #    },
    #    logic_error => {
    #        invalid_argument => {},
    #        length_error => {},
    #        out_of_range => {},
    #    },
    #    bad_alloc => {},
    #    bad_cast => {},
    #    bad_type_id => {},
    #    bad_exception => {},
    #},
};

# drawing
#visit_node($href__hierarchy, $href__hierarchy->{'Shape__Common'}, 'Shape__Common', 0);
#visit_node($href__hierarchy, $href__hierarchy->{'Meridian__Common'}, 'Meridian__Common', 0);
#visit_node($href__hierarchy, $href__hierarchy->{'UniversityMember'}, 'UniversityMember', 0);
foreach my $rootName ( sort keys %{$href__hierarchy} ) {
    visit_node($href__hierarchy, $href__hierarchy->{$rootName}, $rootName, 0);
}


# -------------------------------------
# Subroutines
# -------------------------------------
our @nodeStack; # to calculate num_of_args!
our @indentStack;

sub __is_root_node { return @nodeStack == 1; }
sub __is_leaf_node {
    @_==1 or confess "";
    my $href = shift;
    return !(keys %{$href}); # if there is no child!
}
sub __depth { return @nodeStack-1; }

our @leaves; # let's store the name of leaf-node!

sub visit_node {
    @_==4 or confess "error";
    my $parent = shift;
    my $this = shift;
    my $name = shift;
    my $rank = shift;

    if( @indentStack ) {
        print join('', @indentStack[0 .. $#indentStack-1], '+---'), $name, "\n";
        if( keys(%{$parent})-1 == $rank ) {
            $indentStack[$#indentStack] = '    '; # we don't need '|' any more!
        }
    } else {
        print '', $name, "\n"; # root-node!
    }


    push( @nodeStack, $this );
    push( @indentStack, '|   ' );

    my $i = 0; # n-th child
    foreach my $childName ( sort keys %{$this} ) {
        print join('', @indentStack), "\n";
        visit_node( $this, $this->{$childName}, $childName, $i );
        $i++;
    }

    pop( @indentStack );
    pop( @nodeStack );

    print "\n" unless( @indentStack ); # newline at the end of output
}

__END__
Shape__Common
|   
+---Shape__Base
    |   
    +---Shape__OneDimensional
    |   |   
    |   +---Shape__Dot
    |   |   
    |   +---Shape__Line
    |   
    +---Shape__ThreeDimensional
    |   |   
    |   +---Shape__Cube
    |   |   
    |   +---Shape__Sphere
    |   |   
    |   +---Shape__Tetrahedron
    |   
    +---Shape__TwoDimensional
        |   
        +---Shape__Circle
        |   
        +---Shape__Square
        |   
        +---Shape__Triangle

Meridian__Common
|   
+---Meridian__RuleBase
    |   
    +---Meridian__MultiPathRule
    |   |   
    |   +---Meridian__INTERFACE
    |   |   
    |   +---Meridian__U_INTERFACE
    |   |   
    |   +---Meridian__W_GLITCH
    |   |   
    |   +---Meridian__W_INTERFACE
    |   |   
    |   +---Meridian__W_RECON_GROUPS
    |   
    +---Meridian__SinglePathRule
        |   
        +---Meridian__CNTL
        |   
        +---Meridian__DATA
        |   
        +---Meridian__W_CNTL
        |   
        +---Meridian__W_DATA

UniversityMember
|   
+---Alumnus
|   
+---Employee
|   |   
|   +---Faculty
|   |   |   
|   |   +---Administrator
|   |   |   |   
|   |   |   +---AdministratorTeacher
|   |   |   |
|   |   +---Teacher
|   |   
|   +---Staff
|   
+---Student
    |   
    +---AbsentStudent
    |   
    +---GraduateStudent
    |   
    +---UndergraduateStudent

Vehicle
|   
+---AirVehicle
|   |   
|   +---PoweredAirVehicle
|   |   |   
|   |   +---JetPlane
|   |   |   
|   |   +---PropellerPlane
|   |   
|   +---UnpoweredAirVehicle
|       |   
|       +---Glider
|   
+---LandVehicle
|   |   
|   +---FourWheelVehicle
|   |   |   
|   |   +---Car
|   |       |   
|   |       +---Estate
|   |       |   
|   |       +---SportsCar
|   |       |   
|   |       +---Truck
|   |   
|   +---TwoWheelVehicle
|       |   
|       +---Bicycle
|       |   
|       +---MotorCycle
|   
+---WaterVehicle
    |   
    +---Boat
        |   
        +---CargoShip
        |   
        +---MotorBoat
        |   
        +---SailingBoat

