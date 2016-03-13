library verilog;
use verilog.vl_types.all;
entity bit1mux2_1 is
    port(
        in0             : in     vl_logic;
        in1             : in     vl_logic;
        s               : in     vl_logic;
        \out\           : out    vl_logic
    );
end bit1mux2_1;
