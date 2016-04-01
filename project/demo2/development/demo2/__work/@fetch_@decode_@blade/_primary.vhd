library verilog;
use verilog.vl_types.all;
entity fetch_decode_blade is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        flush           : in     vl_logic;
        stall           : in     vl_logic;
        instruction_fet : in     vl_logic_vector(15 downto 0);
        pc2_fet         : in     vl_logic_vector(15 downto 0);
        instruction_dec : out    vl_logic_vector(15 downto 0);
        pc2_dec         : out    vl_logic_vector(15 downto 0)
    );
end fetch_decode_blade;
