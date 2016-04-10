library verilog;
use verilog.vl_types.all;
entity decode is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        instruction     : in     vl_logic_vector(15 downto 0);
        pc2             : in     vl_logic_vector(15 downto 0);
        write_reg_in    : in     vl_logic_vector(2 downto 0);
        write_data      : in     vl_logic_vector(15 downto 0);
        reg_write_in    : in     vl_logic;
        pc_det_forward  : in     vl_logic;
        pc_det_forward_data: in     vl_logic_vector(15 downto 0);
        pc_ex           : out    vl_logic_vector(15 downto 0);
        pc_code         : out    vl_logic_vector(1 downto 0);
        pc_sel          : out    vl_logic;
        reg_1_data      : out    vl_logic_vector(15 downto 0);
        reg_2_data      : out    vl_logic_vector(15 downto 0);
        reg_1_src       : out    vl_logic_vector(2 downto 0);
        reg_2_src       : out    vl_logic_vector(2 downto 0);
        immediate       : out    vl_logic_vector(15 downto 0);
        check_a         : out    vl_logic;
        check_b         : out    vl_logic;
        write_reg_out   : out    vl_logic_vector(2 downto 0);
        reg_write_out   : out    vl_logic;
        alu_op_code     : out    vl_logic_vector(3 downto 0);
        pass_thr_sel    : out    vl_logic;
        alu_b_src       : out    vl_logic;
        mem_write       : out    vl_logic;
        mem_read        : out    vl_logic;
        wb_sel          : out    vl_logic;
        createdump      : out    vl_logic;
        halt            : out    vl_logic
    );
end decode;
