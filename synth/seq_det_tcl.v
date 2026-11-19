# code for seq_det_tcl
  ...
     remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog ../rtl/seq_det.v

elaborate seq_det

link

create_clock -period 20 clock

check_design

current_design  seq_det

compile_ultra



write_file -f verilog -hier -output seq_det_netlist.v
...
  

