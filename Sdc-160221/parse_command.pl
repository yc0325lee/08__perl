# vim: ft=perl ts=3 sw=3 expandtab noma

# ----------------------------------------------------------------------------
# create_generated_clock -name CLK_BY_4 -source [get_pins {CLK_BY_4_reg/CP}] \
#  -divide_by 2 [get_pins {CLK_BY_4_reg/Q}] -comment "This is a SDC 1.9 command"
# ----------------------------------------------------------------------------
# create_generated_clock \
#    -name CLK_BY_4 \
#    -source [get_pins {CLK_BY_4_reg/CP}] \
#    -divide_by 2 \
#    [get_pins {CLK_BY_4_reg/Q}] \
#    -comment "This is a SDC 1.9 command"
# ----------------------------------------------------------------------------
# create_generated_clock (
#    -name      => CLK_BY_4,
#    -source    => [get_pins {CLK_BY_4_reg/CP}],
#    -divide_by => 2,
#    [get_pins {CLK_BY_4_reg/Q}],
#    -comment   => "This is a SDC 1.9 command"
# );
# ----------------------------------------------------------------------------
# declare create_generated_clock {
#    {-name                String                                      }
#    {-source              List                                        }
#    {-edges               List     {type_Float {length($length>=2}}   }
#    {-divide_by           Int      {1 && $par>=0}                     }
#    {-multiply_by         Int      {1 && $par>=0}                     }
#    {-edge_shift          List                                        }
#    {-duty_cycle          Float    {$par>=0 && $par <=100}            }
#    {-invert              Flag                                        }
#    {-combinational       Flag                                        }
#    {port_pin_list        List                                        }
#    {-add                 Flag                                        }
#    {-comment             String                                      }
#    {-master_clock        List                                        }
# } {param(-source) && param(port_pin_list) && !(param(-multiply_by) && param(-divide_by))}
# ----------------------------------------------------------------------------
# declare create_generated_clock {
#    {-name                String                                      }
#    {-source              List                                        }
#    {-edges               List     {type_Float {length($length>=2}}   }
#    {-divide_by           Int      {1 && $par>=0}                     }
#    {-multiply_by         Int      {1 && $par>=0}                     }
#    {-edge_shift          List                                        }
#    {-duty_cycle          Float    {$par>=0 && $par <=100}            }
#    {-invert              Flag                                        }
#    {-combinational       Flag                                        }
#    {port_pin_list        List                                        }
#    {-add                 Flag                                        }
#    {-comment             String                                      }
#    {-master_clock        List                                        }
# } {param(-source) && param(port_pin_list) && !(param(-multiply_by) && param(-divide_by))}
# ----------------------------------------------------------------------------

sub parse_command
{
   @_==3 or die "";
   my $version = shift;
   my $command = shift;
   my $arguments = shift;

   my $i = 0;
   my $num = $#arguments + 1;
   my $expected = undef;
   while( $i < $num )
   {
      my $aref = $arguments->[$i];
      if( $aref->[0] =~ m{-[a-zA-Z]*} )
      {
         # if here, par is key param!
         if( defined $expected )
         {
            warn("VALUE_NOT_SPECIFIED");
         }

         # finding descriptions of matching parameters
         foreach my $key ( keys %{ $predefined->{$version}->{$command} } )
         {
         }

      }
      else
      {
      }

      $i++;
   }



}
