###############################################################################
set sdc_version 1.9
###############################################################################
create_clock -name CLK1 -period 10.000000 -comment "for block rev1" -waveform { 0.000000 5.000000 } \
 [get_ports {CLK1}]