library verilog;
use verilog.vl_types.all;
entity extra_logic is
    port(
        reg_1_src       : in     vl_logic_vector(2 downto 0);
        reg_2_src       : in     vl_logic_vector(2 downto 0);
        write_reg_mem   : in     vl_logic_vector(2 downto 0);
        write_reg_wb    : in     vl_logic_vector(2 downto 0);
        reg_write_mem   : in     vl_logic;
        reg_write_wb    : in     vl_logic;
        alu_result_mem  : in     vl_logic_vector(15 downto 0);
        wb              : in     vl_logic_vector(15 downto 0);
        pc_sel          : in     vl_logic;
        halt_dec        : in     vl_logic;
        halt_exe        : in     vl_logic;
        halt_mem        : in     vl_logic;
        halt_wb         : in     vl_logic;
        mem_read_mem    : in     vl_logic;
        flush_ifde      : out    vl_logic;
        flush_deex      : out    vl_logic;
        flush_exme      : out    vl_logic;
        flush_mewb      : out    vl_logic;
        stall_fetch     : out    vl_logic;
        stall_ifde      : out    vl_logic;
        stall_deex      : out    vl_logic;
        stall_exme      : out    vl_logic;
        stall_mewb      : out    vl_logic;
        a_forward       : out    vl_logic;
        b_forward       : out    vl_logic;
        a_forward_data  : out    vl_logic_vector(15 downto 0);
        b_forward_data  : out    vl_logic_vector(15 downto 0)
    );
end extra_logic;
