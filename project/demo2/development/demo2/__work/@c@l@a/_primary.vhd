library verilog;
use verilog.vl_types.all;
entity cla is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        ci              : in     vl_logic;
        s               : out    vl_logic_vector(15 downto 0);
        cout            : out    vl_logic
    );
end cla;
