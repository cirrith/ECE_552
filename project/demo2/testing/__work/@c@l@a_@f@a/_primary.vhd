library verilog;
use verilog.vl_types.all;
entity cla_fa is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci              : in     vl_logic;
        s               : out    vl_logic;
        p               : out    vl_logic;
        g               : out    vl_logic
    );
end cla_fa;
