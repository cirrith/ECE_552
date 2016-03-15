library verilog;
use verilog.vl_types.all;
entity pc_inc is
    port(
        curr_pc         : in     vl_logic_vector(15 downto 0);
        inc_pc          : out    vl_logic_vector(15 downto 0)
    );
end pc_inc;
