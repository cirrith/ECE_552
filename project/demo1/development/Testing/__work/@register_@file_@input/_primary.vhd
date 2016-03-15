library verilog;
use verilog.vl_types.all;
entity register_file_input is
    port(
        poss_des        : in     vl_logic_vector(8 downto 0);
        write_reg_sel   : in     vl_logic_vector(1 downto 0);
        write_reg       : out    vl_logic_vector(2 downto 0)
    );
end register_file_input;
