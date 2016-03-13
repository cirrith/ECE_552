library verilog;
use verilog.vl_types.all;
entity alu_cla is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
<<<<<<< HEAD
        ci              : in     vl_logic;
        s               : out    vl_logic_vector(15 downto 0);
        co              : out    vl_logic
=======
        cin             : in     vl_logic;
        s               : out    vl_logic_vector(15 downto 0);
        cout            : out    vl_logic
>>>>>>> 2e640e2555e217a06b6c352cc5c5f6091e568d2d
    );
end alu_cla;
