# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : misc__use_vars_vs_our.pl
# - author : yc0325lee
# - created : 2022-11-05 09:45:07 by lee2103
# - modified : 2022-11-05 09:45:07 by lee2103
# - description : 
# ----------------------------------------------------------------------------
our associates a simple name with a package variable in the current package
for use within the current scope. When use strict 'vars' is in effect, our
lets you use declared global variables without qualifying them with package
names, within the lexical scope of the our declaration. In this way our
differs from use vars , which is package scoped.

use vars qw( $scalar @array %hash &subroutine);
our ($scalar @array %hash &subroutine);
