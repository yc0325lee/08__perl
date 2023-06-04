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


