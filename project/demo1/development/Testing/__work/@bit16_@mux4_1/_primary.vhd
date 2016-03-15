library verilog;
use verilog.vl_types.all;
entity bit16_mux4_1 is
    port(
        in0             : in     vl_logic_vector(15 downto 0);
        in1             : in     vl_logic_vector(15 downto 0);
        in2             : in     vl_logic_vector(15 downto 0);
        in3             : in     vl_logic_vector(15 downto 0);
        s               : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end bit16_mux4_1;
