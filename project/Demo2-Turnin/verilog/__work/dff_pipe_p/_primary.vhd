library verilog;
use verilog.vl_types.all;
entity dff_pipe_p is
    port(
        clk             : in     vl_logic;
        prst            : in     vl_logic;
        flush           : in     vl_logic;
        stall           : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic
    );
end dff_pipe_p;
