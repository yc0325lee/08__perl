# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__README.pm
# Description : 
# Author : yc0325lee
# Created : 2018-12-18 00:04:17 by yc0325lee
# Modified : 2019-01-10 01:00:32 by yc0325lee
# ----------------------------------------------------------------------------
#
# o inheritance hierarchy
# 
#     Meridian__Common
#     |   
#     +---Meridian__RuleBase           ::initialize_globals() ----+
#     |   |                            ::write_header()           |
#     |   |                            ::calcLen()                |
#     |   |                            ::write_rpt()              |
#     |   |                            ::write_csv()              |
#     |   |                            ::print()                  |
#     |   |                            ::sort_criterion()         |
#     |   |                                                       |
#     |   +---Meridian__MultiPathRule  ::is_SinglePathRule()      |
#     |   |   |                        ::is_MultiPathRule()       |
#     |   |   |                                                   | all leaf-classes share
#     |   |   +---Meridian__INTERFACE                             | these functions!
#     |   |   |                                                   | -> smaller number of lines!
#     |   |   +---Meridian__U_INTERFACE                           |
#     |   |   |                                                   |
#     |   |   +---Meridian__W_GLITCH                              |
#     |   |   |                                                   |
#     |   |   +---Meridian__W_INTERFACE                           |
#     |   |   |                                                   |
#     |   |   +---Meridian__W_RECON_GROUPS                        |
#     |   |                                                       |
#     |   +---Meridian__SinglePathRule ::is_SinglePathRule()      |
#     |       |                        ::is_MultiPathRule()   ----+
#     |       |
#     |       +---Meridian__CNTL
#     |       |   
#     |       +---Meridian__DATA
#     |       |   
#     |       +---Meridian__W_CNTL
#     |       |   
#     |       +---Meridian__W_DATA
#     |
#     +---Meridian__Report    ::read_rpt()
#                             ::write_tab()
#                             ::write_csv()
#                             ::write_rpt()
#
# ----------------------------------------------------------------------------
