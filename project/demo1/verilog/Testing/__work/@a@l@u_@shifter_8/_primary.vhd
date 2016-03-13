library verilog;
use verilog.vl_types.all;
entity alu_shifter_8 is
    port(
        \in\            : in     vl_logic_vector(15 downto 0);
        op              : in     vl_logic_vector(1 downto 0);
        sh              : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end alu_shifter_8;
