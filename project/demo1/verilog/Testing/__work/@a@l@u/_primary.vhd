library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        op_code         : in     vl_logic_vector(3 downto 0);
        pc2             : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(15 downto 0);
        lt              : out    vl_logic;
        eq              : out    vl_logic
    );
end alu;
