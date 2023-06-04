# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : README.TXT
# Description : 
# Author : yc0325lee
# Created : 2018-11-21 00:02:34 by prince2103
# Modified : 2018-11-21 00:56:02 by prince2103
# ----------------------------------------------------------------------------

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
