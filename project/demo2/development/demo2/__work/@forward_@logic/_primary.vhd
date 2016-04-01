library verilog;
use verilog.vl_types.all;
entity forward_logic is
    port(
        reg_1_src       : in     vl_logic_vector(2 downto 0);
        reg_2_src       : in     vl_logic_vector(2 downto 0);
        write_reg_mem   : in     vl_logic_vector(2 downto 0);
        write_reg_wb    : in     vl_logic_vector(2 downto 0);
        reg_write_mem   : in     vl_logic;
        reg_write_wb    : in     vl_logic;
        alu_result_mem  : in     vl_logic_vector(15 downto 0);
        wb              : in     vl_logic_vector(15 downto 0);
        a_forward       : out    vl_logic;
        b_forward       : out    vl_logic;
        forward_mem     : out    vl_logic;
        a_forward_data  : out    vl_logic_vector(15 downto 0);
        b_forward_data  : out    vl_logic_vector(15 downto 0)
    );
end forward_logic;
