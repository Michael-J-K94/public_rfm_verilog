#/* All verilog files, separated by spaces         */
set base_dir [getenv "BASE_DIR"]
set my_verilog_files [list $base_dir/src/rfm_unit_bank.v\
                           $base_dir/src/pe_cam.v\
                           $base_dir/src/pe16.v\
                           $base_dir/src/pe64.v\
                           $base_dir/src/pe256.v\
                           $base_dir/src/pe1024.v]

#/* Top-level Module                               */
set my_toplevel rfm_unit_bank

#/* Target frequency in MHz for optimization       */
set my_clk_freq_MHz [getenv "SYN_FREQ"]

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk
set my_reset_pin resetn

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0.1


#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/

set TSMC_STD_CELL [getenv "TSMC_STD_CELL"]
set search_path [concat  $search_path $TSMC_STD_CELL]
set alib_library_analysis_path $TSMC_STD_CELL

set link_library [concat  [list sc9_cln40g_base_rvt_tt_typical_max_0p90v_25c.db] [list dw_foundation.sldb]]
set target_library [format "%s%s" [getenv "TSMC_TARGET_LIB"] ".db" ]

define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"

analyze -f verilog $my_verilog_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

set my_period [expr ((1000 / $my_clk_freq_MHz))]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

#set_option -pipe 2

set_max_fanout 8 $my_toplevel

set_ideal_network $clk_name
set_clock_uncertainty 0.2 $clk_name
#set_dont_touch_network $clk_name
#set_dont_touch_network $my_reset_pin

set_driving_cell  -lib_cell INV_X1B_A12TR50  [all_inputs]

set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

#compile -ungroup_all -map_effort medium
#compile -incremental_mapping -map_effort medium
compile_ultra -no_auto_ungroup

check_design
report_constraint -all_violators

set output_path [format "%s" $base_dir/syn/output ]

exec mkdir -p $output_path

set filename [format "%s%s"  $my_toplevel "_syn.v"]
write -f verilog -output $output_path/$filename

set filename [format "%s%s"  $my_toplevel "_syn.sdc"]
write_sdc $output_path/$filename

set filename [format "%s%s"  $my_toplevel "_syn.sdf"]
write_sdf $output_path/$filename

redirect $output_path/area.rep {report_area -hier}
redirect $output_path/timing.rep { report_timing }
redirect $output_path/cell.rep { report_cell }
redirect $output_path/power.rep { report_power }

quit
