# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : misc__special_symbols.pl
# - author : yc0325lee
# - created : 2022-11-05 09:43:05 by lee2103
# - modified : 2022-11-05 09:43:05 by lee2103
# - description : 
# ----------------------------------------------------------------------------

# to find the current package:
$this_pack = __PACKAGE__;

# to find the caller's package:
$that_pack = caller();

# see the descriptions of the special symbols
# ; __FILE__ , __LINE__ , and __PACKAGE__ in perldata (1);
