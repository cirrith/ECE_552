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
<<<<<<< HEAD
        eq              : out    vl_logic
=======
        zf              : out    vl_logic
>>>>>>> 2e640e2555e217a06b6c352cc5c5f6091e568d2d
    );
end alu;
