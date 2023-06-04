# vim: ft=tcl ts=4 sw=4 expandtab noma
# ----------------------------------------------------------------------------

set sdc_version 2.0

proc declare {proc defargs {cond 1}} {
    variable procdefs
    variable proccond
    variable sdc_version 

    # checking for duplicate of declaration
    if { ![info exists procdefs($sdc_version,$proc)] } {
        set procdefs($sdc_version,$proc) $defargs
        set proccond($sdc_version,$proc) $cond
        # --------------------------------------------------------------
        # declare create_clock  { { ... } { ... } ... { ... } }  { ... }
        #         ------------  -------------------------------  -------
        #               |                      |                    |
        #               |                      |                    $cond
        #               |                      $defargs
        #               $proc
        #
        # -> set procdefs(2.0,create_clock) $defargs
        # -> set proccond(2.0,create_clock) $cond
        # --------------------------------------------------------------
    } else {
        puts stderr "FATAL ERROR: Procedure \"$proc\" of version \
                     $sdc_version already declared!"
        exit -1
    }

    # declarating sdc-command as procedure in slave Tcl-interpreter
    sdc$sdc_version eval "
        __proc $proc {args} {
            __return \[parse_command $sdc_version $proc \$args\]
        } "
        # --------------------------------------------------------------
        # proc create_clock { args } {
        #     return [parse_command 2.0 create_clock $args]
        # }
        # --------------------------------------------------------------
}

declare create_clock {
    { -period        Float  {$par>=0}                                             }
    { -name          String                                                       }
    { -comment       String                                                       }
    { -waveform      List   {type_Float {length($length>=2 && ($length % 2)==0)}} }
    {  port_pin_list List                                                         }
    { -add           Flag                                                         }
} {param(-period) && (param(-name) || param(port_pin_list))}
# ----------------------------------------------------------------------------
# set procdefs(2.0,create_clock) {
#     { -period        Float  {$par>=0}                                             }
#     { -name          String                                                       }
#     { -comment       String                                                       }
#     { -waveform      List   {type_Float {length($length>=2 && ($length % 2)==0)}} }
#     {  port_pin_list List                                                         }
#     { -add           Flag                                                         }
# }
# set proccond(2.0,create_clock) {param(-period) && (param(-name) || param(port_pin_list))}
# ----------------------------------------------------------------------------


proc create_clock { args } {
    return [parse_command 1.9 create_clock $args]
}


declare create_generated_clock {
    { -name          String                                  }
    { -source        List                                    }
    { -edges         List   {type_Float {length($length>=2}} }
    { -divide_by     Int    {1 && $par>=0}                   }
    { -multiply_by   Int    {1 && $par>=0}                   }
    { -edge_shift    List                                    }
    { -duty_cycle    Float  {$par>=0 && $par <=100}          }
    { -invert        Flag                                    }
    { -combinational Flag                                    }
    {  port_pin_list List                                    }
    { -add           Flag                                    }
    { -comment       String                                  }
    { -master_clock  List                                    }
} {param(-source) && param(port_pin_list) && !(param(-multiply_by) && param(-divide_by))}
