#####################################################

#  Created by Design Compiler write_sdc on Fri Sep 15 16:41:59 2000

#####################################################
set sdc_version 1.1

create_clock -period 20 -waveform {0 10} [get_ports {Clk1}]
create_clock -period 5 -waveform {0 2.5} [get_ports {Clk2}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[0]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[1]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[2]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[3]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[4]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[5]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[6]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[7]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[8]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[9]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[10]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[11]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[12]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[13]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[14]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[15]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[16]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[17]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[18]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[19]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[20]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[21]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[22]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[23]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[24]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[25]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[26]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[27]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[28]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[29]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[30]}]
set_input_delay 1 -clock "Clk1" [get_ports {Data_In[31]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[0]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[1]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[2]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[3]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[4]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[5]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[6]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[7]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[8]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[9]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[10]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[11]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[12]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[13]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[14]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[15]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[16]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[17]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[18]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[19]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[20]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[21]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[22]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[23]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[24]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[25]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[26]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[27]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[28]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[29]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[30]}]
set_output_delay 1 -clock "Clk2" [get_ports {Data_Out[31]}]
set_false_path\
	-from     [list [get_cells {Data_Internal_reg[0]}]\
		   [get_cells {Data_Internal_reg[1]}]\
		   [get_cells {Data_Internal_reg[2]}]\
		   [get_cells {Data_Internal_reg[3]}]\
		   [get_cells {Data_Internal_reg[4]}]\
		   [get_cells {Data_Internal_reg[5]}]\
		   [get_cells {Data_Internal_reg[6]}]\
		   [get_cells {Data_Internal_reg[7]}]\
		   [get_cells {Data_Internal_reg[8]}]\
		   [get_cells {Data_Internal_reg[9]}]\
		   [get_cells {Data_Internal_reg[10]}]\
		   [get_cells {Data_Internal_reg[11]}]\
		   [get_cells {Data_Internal_reg[12]}]\
		   [get_cells {Data_Internal_reg[13]}]\
		   [get_cells {Data_Internal_reg[14]}]\
		   [get_cells {Data_Internal_reg[15]}]\
		   [get_cells {Data_Internal_reg[16]}]\
		   [get_cells {Data_Internal_reg[17]}]\
		   [get_cells {Data_Internal_reg[18]}]\
		   [get_cells {Data_Internal_reg[19]}]\
		   [get_cells {Data_Internal_reg[20]}]\
		   [get_cells {Data_Internal_reg[21]}]\
		   [get_cells {Data_Internal_reg[22]}]\
		   [get_cells {Data_Internal_reg[23]}]\
		   [get_cells {Data_Internal_reg[24]}]\
		   [get_cells {Data_Internal_reg[25]}]\
		   [get_cells {Data_Internal_reg[26]}]\
		   [get_cells {Data_Internal_reg[27]}]\
		   [get_cells {Data_Internal_reg[28]}]\
		   [get_cells {Data_Internal_reg[29]}]\
		   [get_cells {Data_Internal_reg[30]}]\
		   [get_cells {Data_Internal_reg[31]}]] \
	-to       [list [get_cells {Data_Sync_reg[0]}]\
		   [get_cells {Data_Sync_reg[1]}]\
		   [get_cells {Data_Sync_reg[2]}]\
		   [get_cells {Data_Sync_reg[3]}]\
		   [get_cells {Data_Sync_reg[4]}]\
		   [get_cells {Data_Sync_reg[5]}]\
		   [get_cells {Data_Sync_reg[6]}]\
		   [get_cells {Data_Sync_reg[7]}]\
		   [get_cells {Data_Sync_reg[8]}]\
		   [get_cells {Data_Sync_reg[9]}]\
		   [get_cells {Data_Sync_reg[10]}]\
		   [get_cells {Data_Sync_reg[11]}]\
		   [get_cells {Data_Sync_reg[12]}]\
		   [get_cells {Data_Sync_reg[13]}]\
		   [get_cells {Data_Sync_reg[14]}]\
		   [get_cells {Data_Sync_reg[15]}]\
		   [get_cells {Data_Sync_reg[16]}]\
		   [get_cells {Data_Sync_reg[17]}]\
		   [get_cells {Data_Sync_reg[18]}]\
		   [get_cells {Data_Sync_reg[19]}]\
		   [get_cells {Data_Sync_reg[20]}]\
		   [get_cells {Data_Sync_reg[21]}]\
		   [get_cells {Data_Sync_reg[22]}]\
		   [get_cells {Data_Sync_reg[23]}]\
		   [get_cells {Data_Sync_reg[24]}]\
		   [get_cells {Data_Sync_reg[25]}]\
		   [get_cells {Data_Sync_reg[26]}]\
		   [get_cells {Data_Sync_reg[27]}]\
		   [get_cells {Data_Sync_reg[28]}]\
		   [get_cells {Data_Sync_reg[29]}]\
		   [get_cells {Data_Sync_reg[30]}]\
		   [get_cells {Data_Sync_reg[31]}]] 
set_operating_conditions "fast_25_1.20" -library "ssc_core_fast"
set_wire_load_model  -name "10KGATES" -library "ssc_core_fast"