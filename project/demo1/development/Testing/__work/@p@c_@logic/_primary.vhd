library verilog;
use verilog.vl_types.all;
entity pc_logic is
    port(
        pc_code         : in     vl_logic_vector(2 downto 0);
        comp_code       : in     vl_logic_vector(1 downto 0);
        curr_pc         : in     vl_logic_vector(15 downto 0);
        eq              : in     vl_logic;
        lt              : in     vl_logic;
        rs              : in     vl_logic_vector(15 downto 0);
        im8             : in     vl_logic_vector(15 downto 0);
        dis             : in     vl_logic_vector(15 downto 0);
        pc2             : out    vl_logic_vector(15 downto 0);
        nxt_pc          : out    vl_logic_vector(15 downto 0)
    );
end pc_logic;
