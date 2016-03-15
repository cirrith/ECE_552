library verilog;
use verilog.vl_types.all;
entity alu_shifter is
    port(
        \In\            : in     vl_logic_vector(15 downto 0);
        cnt             : in     vl_logic_vector(3 downto 0);
        op              : in     vl_logic_vector(1 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end alu_shifter;
