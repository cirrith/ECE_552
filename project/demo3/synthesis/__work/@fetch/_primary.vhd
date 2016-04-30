library verilog;
use verilog.vl_types.all;
entity fetch is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall           : in     vl_logic;
        pc_ex           : in     vl_logic_vector(15 downto 0);
        pc_sel          : in     vl_logic;
        instruction     : out    vl_logic_vector(15 downto 0);
        pc2             : out    vl_logic_vector(15 downto 0);
        fet_stall       : out    vl_logic;
        err             : out    vl_logic
    );
end fetch;
