library verilog;
use verilog.vl_types.all;
entity alu_andn is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end alu_andn;
