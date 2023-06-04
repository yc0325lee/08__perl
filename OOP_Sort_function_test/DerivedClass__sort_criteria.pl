# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : sort_criteria.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-20 23:44:03 by yc0325lee
# Modified : 2019-01-03 23:52:38 by yc0325lee
# ----------------------------------------------------------------------------
our $sort_criteria = {
    BaseClass => sub {
        #confess "[ERR ] BaseClass::sort_criterion not defined!";
        $a->name() cmp $b->name()
    },
    DerivedClass_A => sub {
        $a->field1() <=> $b->field1() || $a->name() cmp $b->name()
    }
    DerivedClass_B => sub {
        $a->field2() <=> $b->field2() || $a->name() cmp $b->name()
    },
    # ----------------------------------------------------------
    # [caution] $a and $b are package global of caller's package
    #           $main::a and $main::b in this example!
    # ----------------------------------------------------------
};

sub BaseClass::sort_criterion {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    return $sort_criteria->{$class}; # returns a reference to subroutine
}
