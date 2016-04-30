library verilog;
use verilog.vl_types.all;
entity pc_inc is
    port(
        pc              : in     vl_logic_vector(15 downto 0);
        pc2             : out    vl_logic_vector(15 downto 0)
    );
end pc_inc;
