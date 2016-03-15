library verilog;
use verilog.vl_types.all;
entity pc is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        new_pc          : in     vl_logic_vector(15 downto 0);
        write           : in     vl_logic;
        curr_pc         : out    vl_logic_vector(15 downto 0)
    );
end pc;
