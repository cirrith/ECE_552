library verilog;
use verilog.vl_types.all;
entity register_file_input is
    port(
        poss_des        : in     vl_logic_vector(8 downto 0);
<<<<<<< HEAD
        write_reg_sel   : in     vl_logic_vector(1 downto 0);
=======
        write_back_sel  : in     vl_logic;
>>>>>>> 2e640e2555e217a06b6c352cc5c5f6091e568d2d
        write_reg       : out    vl_logic_vector(2 downto 0)
    );
end register_file_input;
