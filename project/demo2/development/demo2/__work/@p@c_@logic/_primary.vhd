library verilog;
use verilog.vl_types.all;
entity pc_logic is
    port(
        pc_code         : in     vl_logic_vector(1 downto 0);
        reg_1_data      : in     vl_logic_vector(15 downto 0);
        immediate       : in     vl_logic_vector(15 downto 0);
        pc2             : in     vl_logic_vector(15 downto 0);
        comp_code       : in     vl_logic_vector(1 downto 0);
        zf              : in     vl_logic;
        lt              : in     vl_logic;
        pc_ex           : out    vl_logic_vector(15 downto 0);
        pc_sel          : out    vl_logic
    );
end pc_logic;
