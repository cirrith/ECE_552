library verilog;
use verilog.vl_types.all;
entity bits5_sext is
    port(
        \In\            : in     vl_logic_vector(4 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end bits5_sext;
