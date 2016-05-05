echo "********** CS552 Reading files begin ********************"
set my_verilog_files [list ALU.v ALU_ANDN.v ALU_Bit4_CLA.v ALU_CLA.v ALU_CLA_FA.v ALU_Shifter.v ALU_Shifter_1.v ALU_Shifter_2.v ALU_Shifter_4.v ALU_Shifter_8.v ALU_XOR.v Bit1_Mux2_1.v Bit1_Mux4_1.v Bit4_CLA.v Bits8_SExt.v Bit16_Mux4_1.v Bit16_Mux8_1.v Bits5_SExt.v Bits5_ZExt.v Bits11_SExt.v Branch_Logic.v cache.v CLA.v CLA_FA.v Decode.v Decode_Execute_Blade.v dff.v dff_pipe.v dff_pipe_p.v Execute.v Execute_Memory_Blade.v Extender.v Extra_Logic2.v Fetch.v Fetch_Decode_Blade.v final_memory.syn.v four_bank_mem.v Forward_Logic.v Imm_Selecter.v imem_system.v Memory.v Memory_Writeback_Blade.v mem_system.v memory2c.syn.v memory2c_align.syn.v memc.syn.v memv.syn.v PC.v PC_inc.v PC_Logic.v proc.v Processor_Control.v Register.v Register_File.v Register_File_Bypass.v Register_File_Input.v stallmem.syn.v Write_Back.v  ]
set my_toplevel proc
define_design_lib WORK -path ./WORK
analyze -f verilog $my_verilog_files
elaborate $my_toplevel -architecture verilog
echo "********** CS552 Reading files end ********************"
echo "********** CS552 Linking all modules begin ********************"
link
echo "********** CS552 Linking all modules end **********************"
echo "********** CS552 Checking design of all modules begin**********"
check_design -summary
echo "********** CS552 Checking design of all modules end************"
report_hierarchy > synth/hierarchy.txt
set filename [format "%s%s"  $my_toplevel ".syn.v"]
write -f verilog $my_toplevel -output synth/$filename -hierarchy
quit
