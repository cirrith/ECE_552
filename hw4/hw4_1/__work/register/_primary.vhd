library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        data_width      : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        write           : in     vl_logic;
        wdata           : in     vl_logic_vector;
        rdata           : out    vl_logic_vector
    );
end \register\;
