library verilog;
use verilog.vl_types.all;
entity cla_fa is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
<<<<<<< HEAD
        ci              : in     vl_logic;
        s               : out    vl_logic;
        p               : out    vl_logic;
        g               : out    vl_logic
=======
        cin             : in     vl_logic;
        s               : out    vl_logic;
        cout            : out    vl_logic
>>>>>>> 2e640e2555e217a06b6c352cc5c5f6091e568d2d
    );
end cla_fa;
