echo "********** CS552 Reading files begin ********************"
set my_verilog_files [list ALU.v ALU_ANDN.v ALU_Bit4_CLA.v ALU_CLA.v ALU_CLA_FA.v ALU_Shifter.v ALU_Shifter_1.v ALU_Shifter_2.v ALU_Shifter_4.v ALU_Shifter_8.v ALU_XOR.v Bit1_Mux2_1.v Bit1_Mux4_1.v Bit4_CLA.v Bits8_SExt.v Bit16_Mux4_1.v Bit16_Mux8_1.v Bits5_SExt.v Bits5_ZExt.v Bits11_SExt.v Branch_Logic.v cache.v CLA.v CLA_FA.v Decode.v Decode_Execute_Blade.v dff.v dff_pipe.v dff_pipe_p.v Execute.v Execute_Memory_Blade.v Extender.v Extra_Logic2.v Fetch.v Fetch_Decode_Blade.v final_memory.syn.v four_bank_mem.v Forward_Logic.v Imm_Selecter.v Memory.v Memory_Writeback_Blade.v memory2c.syn.v memory2c_align.syn.v PC.v PC_inc.v PC_Logic.v proc.v Processor_Control.v Register.v Register_File.v Register_File_Bypass.v Register_File_Input.v stallmem.syn.v Write_Back.v  ]
set my_toplevel proc
define_design_lib WORK -path ./WORK
analyze -f verilog $my_verilog_files
elaborate $my_toplevel -architecture verilog
echo "********** CS552 Reading files end ********************"
current_design proc
#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk

#/* Target frequency in MHz for optimization       */
set my_clk_freq_MHz 1000

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0.1


#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/
set verilogout_show_unconnected_pins "true"


# analyze -f verilog $my_verilog_files
# elaborate $my_toplevel -architecture verilog
# current_design $my_toplevel

report_hierarchy 
link
uniquify

set my_period [expr 1000 / $my_clk_freq_MHz]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
} 

set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

compile -map_effort low  -area_effort low

check_design -summary
report_constraint -all_violators

set filename [format "%s%s"  $my_toplevel ".syn.v"]
write -hierarchy -f verilog $my_toplevel -output synth/$filename
set filename [format "%s%s"  $my_toplevel ".ddc"]
write -hierarchy -format ddc -output synth/$filename

report_reference > synth/reference_report.txt
report_area > synth/area_report.txt
report_cell > synth/cell_report.txt
report_timing -max_paths 20 > synth/timing_report.txt
report_power > synth/power_report.txt

quit

