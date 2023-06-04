# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__RuleBase-sort_criteria.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-21 00:23:55 by yc0325lee
# Modified : 2019-01-09 22:59:21 by yc0325lee
# ----------------------------------------------------------------------------


# ------------------------------------------------
# $a & $b are package globals of Meridian__Report!
our $href__sort_criteria = {
    Meridian__CNTL => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__DATA => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__W_CNTL => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__W_DATA => sub { $a->RxFlop()->[0] cmp $b->RxFlop()->[0] },
    Meridian__INTERFACE => sub { $a->Signal()->[0] cmp $b->Signal()->[0] },
    Meridian__U_INTERFACE => sub { $a->Signal()->[0] cmp $b->Signal()->[0] },
    Meridian__W_INTERFACE => sub { $a->Signal()->[0] cmp $b->Signal()->[0] },
    Meridian__W_GLITCH => sub { $a->VictimFlop()->[0] cmp $b->VictimFlop()->[0] },
    Meridian__W_RECON_GROUPS => sub { $a->ReconPoint()->[0] cmp $b->ReconPoint()->[0] },
};

sub Meridian__RuleBase::sort_criterion {
    @_==1 or confess "[erro]";
    my $class = shift;
    confess("[erro] instance method invocated on class method!") if( ref($class) );
    my $thisFunction = (caller(0))[3];

    return $href__sort_criteria->{$class};
}


