library verilog;
use verilog.vl_types.all;
entity execute_memory_blade is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        flush           : in     vl_logic;
        stall           : in     vl_logic;
        mem_write_exe   : in     vl_logic;
        mem_read_exe    : in     vl_logic;
        reg_2_data_exe  : in     vl_logic_vector(15 downto 0);
        createdump_exe  : in     vl_logic;
        alu_result_exe  : in     vl_logic_vector(15 downto 0);
        reg_write_exe   : in     vl_logic;
        wb_sel_exe      : in     vl_logic;
        write_reg_exe   : in     vl_logic_vector(2 downto 0);
        halt_exe        : in     vl_logic;
        mem_write_mem   : out    vl_logic;
        mem_read_mem    : out    vl_logic;
        reg_2_data_mem  : out    vl_logic_vector(15 downto 0);
        createdump_mem  : out    vl_logic;
        alu_result_mem  : out    vl_logic_vector(15 downto 0);
        reg_write_mem   : out    vl_logic;
        wb_sel_mem      : out    vl_logic;
        write_reg_mem   : out    vl_logic_vector(2 downto 0);
        halt_mem        : out    vl_logic
    );
end execute_memory_blade;
