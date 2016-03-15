library verilog;
use verilog.vl_types.all;
entity bit1_mux4_1 is
    port(
        in0             : in     vl_logic;
        in1             : in     vl_logic;
        in2             : in     vl_logic;
        in3             : in     vl_logic;
        s               : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic
    );
end bit1_mux4_1;
