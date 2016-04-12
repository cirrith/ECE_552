library verilog;
use verilog.vl_types.all;
entity pc is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pc              : out    vl_logic_vector(15 downto 0);
        pc2             : in     vl_logic_vector(15 downto 0);
        pc_ex           : in     vl_logic_vector(15 downto 0);
        pc_sel          : in     vl_logic;
        stall           : in     vl_logic
    );
end pc;
