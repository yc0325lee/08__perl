# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : misc__use_vs_require.pl
# - author : yc0325lee
# - created : 2022-11-05 09:19:28 by lee2103
# - modified : 2022-11-05 09:19:28 by lee2103
# - description : 
# ----------------------------------------------------------------------------

use Module;
BEGIN { require 'Module.pm'; 'Module'->import; }


use Module LIST;
BEGIN { require 'Module.pm'; 'Module'->import( LIST ); }


use Module ();
BEGIN { require 'Module.pm'; }


# - require
# ; load in external functions from a library at runtime
# ; 실행시간에 module을 load


# - use
# ; load in a module at compile time
# ; compile time loading
# ; automatic import
