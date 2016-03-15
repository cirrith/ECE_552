library verilog;
use verilog.vl_types.all;
entity bits11_sext is
    port(
        \In\            : in     vl_logic_vector(10 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end bits11_sext;
