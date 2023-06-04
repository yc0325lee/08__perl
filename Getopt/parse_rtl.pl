# vim: ft=perl ts=4 sw=4 tw=78 expandtab
# ----------------------------------------------------------------------------
# - file : parse_rtl.pl
# - author : yc0325lee
# - created : 2023-05-21 00:30:36 by yc032
# - modified : 2023-05-21 00:30:36 by yc032
# - description : 
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

# - Getopt::Long from core module for
# ; Getopt::Long::config()
# ; GetOptions() function
use Getopt::Long;

# - Verilog::Getopt provides
# ; standardized handling of options similar to Verilog/VCS and cc/GCC.
use Verilog::Getopt;

our $VERSION = '3.456';
our $Debug = 0;

# -------------------------------------
# command line arguments handling
my $opt_output_filename = undef;
my @opt_files;

autoflush STDOUT 1;
autoflush STDERR 1;

# Option parsing
my $Opt = new Verilog::Getopt(filename_expansion=>1);
my $Opt_Cells;
my $Opt_Modules;
my $Opt_ModFiles;
my $Opt_InFiles;
my $Opt_Missing = 1;
my $Opt_Missing_Modules;
my $Opt_TopModule;
my $Opt_ResolveFiles;
my $Opt_Synthesis;
my $Opt_Instance;
my $Opt_Forest;
my $opt_skiplist;
my $opt_language_standard = '1800-2001';
my @Opt_Skiplist_Names;
my $Opt_Xml;

# - GetOptions()
# ; parses the command line from @ARGV, recognizing and removing specified
#   options and their possible values.
# ; handles posix standard double-dash(--) options
# ; snarf matched arguments asap and matched removed from @ARGV
# ; GetOptions returns true to indicate success. It returns false when the
#   function detected one or more errors during option parsing. These errors are
#   signalled using warn() and can be trapped with $SIG{__WARN__}.
# ; Getopt::Long::config("no_auto_abbrev","no_pass_through")
#   auto_abbrev
#   -> allow option names to be abbreviated to uniqueness
#      opposite= no_auto_abbrev
#   pass_through
#   ->  With pass_through anything that is unknown, ambiguous or supplied with
#       an invalid option will not be flagged as an error. Instead the unknown
#       option(s) will be passed to the catchall <> if present, otherwise
#       through to @ARGV.
#      opposite= no_pass_through
GetOptions("debug" => \&debug); # '--debug' swallowed

@ARGV = $Opt->parameter(@ARGV); # ; filter out options for targets
                                #   returns options not filtered
                                # ; we should capture and extract the
                                #   followings because GetOptions() can not
                                #   handle the followings:
                                #   '-v'
                                #   '-y'
                                #   '+libext+'
                                #   '+incdir+'
                                #   '+define+'
                                #   '-DNAME' or '-DVALUE=3'
                                #   '-ILIBDIR'

Getopt::Long::config("no_auto_abbrev","no_pass_through");
if( !GetOptions(
        "help"             => \&usage,
        "debug"            => \&debug,
        "o=s"              => \$opt_output_filename,
        "cells!"           => \$Opt_Cells,
        "module-files!"    => \$Opt_ModFiles,
        "modules!"         => \$Opt_Modules,
        "input-files!"     => \$Opt_InFiles,
        "resolve-files!"   => \$Opt_ResolveFiles,
        "skiplist=s"       => \$opt_skiplist,
        "sv!"              => sub { shift; language_standard("1800-2017"); },
        "language=s"       => sub { shift; language_standard(shift); },
        "missing!"         => \$Opt_Missing,
        "missing-modules!" => \$Opt_Missing_Modules,
        "synthesis!"       => \$Opt_Synthesis,
        "top-module=s"     => \$Opt_TopModule,
        "version"          => sub { print "Version $VERSION\n"; exit(0); },
        "forest"           => \$Opt_Forest,
        "instance"         => \$Opt_Instance,
        "xml!"             => \$Opt_Xml,
        "<>"               => \&parameter, # catch all
    )
) {
    die "%Error: Bad usage, try 'vhier --help'\n";
    my $fileline = __FILE__ . ":" . __LINE__;
    die "%Error: [$fileline] Bad usage! See help plz.\n";
}

if (!@opt_files) {
    my $fileline = __FILE__ . ":" . __LINE__;
    die "%Error: [$fileline] No input filenames specified.\n";
}


# -------------------------------------
# subroutines
sub usage {
    print "[warn] not yet implemented!\n";
    exit(1);
}

sub debug {
    $Debug = 1;
}

sub language_standard {
    @_==1 or die "";
    my $standard = shift;
    die "" unless( $standard =~ m/^1800-\d{4}$/ );
    $opt_language_standard = $standard;
}

sub parameter {
    my $param = shift;
    if ($param =~ /^--?/) {
        die "%Error: vhier: Unknown parameter: $param\n";
    } else {
        push @opt_files, "$param"; # Must quote to convert Getopt to string, bug298
    }
}

sub __dump_argv {
    # debug utility
    print("# __dump_argv\n");
    for( my $i = 0; $i < @ARGV; $i++ ) {
        print("ARGV[$i]= $ARGV[$i]\n");
    }
    print("\n");
}
