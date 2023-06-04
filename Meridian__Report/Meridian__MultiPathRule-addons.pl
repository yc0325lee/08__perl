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


