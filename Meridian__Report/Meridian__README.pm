# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# - file : Meridian__README.pm
# - author : yc0325lee
# - created : 2022-10-23 13:29:14 by lee2103
# - modified : 2022-10-23 13:29:14 by lee2103
# - description : 
# ----------------------------------------------------------------------------
#
# - inheritance hierarchy
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
#
# - each rule's attributes(fields)
# ; set in the middle of importing report dynamically
#
# ----------------------------------------------------------------------------
