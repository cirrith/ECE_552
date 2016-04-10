library verilog;
use verilog.vl_types.all;
entity write_back is
    port(
        alu_result      : in     vl_logic_vector(15 downto 0);
        mem_data        : in     vl_logic_vector(15 downto 0);
        sel             : in     vl_logic;
        wb              : out    vl_logic_vector(15 downto 0)
    );
end write_back;
