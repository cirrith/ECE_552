library verilog;
use verilog.vl_types.all;
entity dff_pipe is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        flush           : in     vl_logic;
        stall           : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic
    );
end dff_pipe;
