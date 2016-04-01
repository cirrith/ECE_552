library verilog;
use verilog.vl_types.all;
entity execute is
    port(
        alu_b_src       : in     vl_logic;
        comp_code       : in     vl_logic_vector(1 downto 0);
        alu_op_code     : in     vl_logic_vector(3 downto 0);
        pass_thr_sel    : in     vl_logic;
        reg_1_data      : in     vl_logic_vector(15 downto 0);
        reg_2_data      : in     vl_logic_vector(15 downto 0);
        reg_1_src       : in     vl_logic_vector(2 downto 0);
        reg_2_src       : in     vl_logic_vector(2 downto 0);
        immediate       : in     vl_logic_vector(15 downto 0);
        pc_code         : in     vl_logic_vector(1 downto 0);
        pc2             : in     vl_logic_vector(15 downto 0);
        a_forward       : in     vl_logic;
        b_forward       : in     vl_logic;
        a_forward_data  : in     vl_logic_vector(15 downto 0);
        b_forward_data  : in     vl_logic_vector(15 downto 0);
        alu_result      : out    vl_logic_vector(15 downto 0);
        pc_ex           : out    vl_logic_vector(15 downto 0);
        pc_sel          : out    vl_logic
    );
end execute;
