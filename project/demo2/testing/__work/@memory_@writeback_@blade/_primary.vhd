library verilog;
use verilog.vl_types.all;
entity memory_writeback_blade is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        flush           : in     vl_logic;
        stall           : in     vl_logic;
        createdump_mem  : in     vl_logic;
        alu_result_mem  : in     vl_logic_vector(15 downto 0);
        reg_write_mem   : in     vl_logic;
        mem_data_mem    : in     vl_logic_vector(15 downto 0);
        wb_sel_mem      : in     vl_logic;
        write_reg_mem   : in     vl_logic_vector(2 downto 0);
        halt_mem        : in     vl_logic;
        createdump_wb   : out    vl_logic;
        alu_result_wb   : out    vl_logic_vector(15 downto 0);
        reg_write_wb    : out    vl_logic;
        mem_data_wb     : out    vl_logic_vector(15 downto 0);
        wb_sel_wb       : out    vl_logic;
        write_reg_wb    : out    vl_logic_vector(2 downto 0);
        halt_wb         : out    vl_logic
    );
end memory_writeback_blade;
