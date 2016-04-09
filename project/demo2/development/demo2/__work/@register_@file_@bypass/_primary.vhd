library verilog;
use verilog.vl_types.all;
entity register_file_bypass is
    port(
        reg_1_data      : out    vl_logic_vector(15 downto 0);
        reg_2_data      : out    vl_logic_vector(15 downto 0);
        err             : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        reg_1_src       : in     vl_logic_vector(2 downto 0);
        reg_2_src       : in     vl_logic_vector(2 downto 0);
        write_reg       : in     vl_logic_vector(2 downto 0);
        write_data      : in     vl_logic_vector(15 downto 0);
        write           : in     vl_logic
    );
end register_file_bypass;
