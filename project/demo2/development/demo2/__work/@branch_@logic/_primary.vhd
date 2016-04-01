library verilog;
use verilog.vl_types.all;
entity branch_logic is
    port(
        comp_code       : in     vl_logic_vector(1 downto 0);
        zf              : in     vl_logic;
        lt              : in     vl_logic;
        branch          : out    vl_logic
    );
end branch_logic;
