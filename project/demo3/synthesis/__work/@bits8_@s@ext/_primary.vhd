library verilog;
use verilog.vl_types.all;
entity bits8_sext is
    port(
        \In\            : in     vl_logic_vector(7 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end bits8_sext;
