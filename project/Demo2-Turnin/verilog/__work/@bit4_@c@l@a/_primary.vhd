library verilog;
use verilog.vl_types.all;
entity bit4_cla is
    port(
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        ci              : in     vl_logic;
        s               : out    vl_logic_vector(3 downto 0);
        p               : out    vl_logic;
        g               : out    vl_logic
    );
end bit4_cla;
