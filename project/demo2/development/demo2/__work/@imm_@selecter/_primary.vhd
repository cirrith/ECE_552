library verilog;
use verilog.vl_types.all;
entity imm_selecter is
    port(
        extend          : in     vl_logic_vector(10 downto 0);
        imm_sel         : in     vl_logic_vector(2 downto 0);
        pc2             : in     vl_logic_vector(15 downto 0);
        immediate       : out    vl_logic_vector(15 downto 0)
    );
end imm_selecter;
