library verilog;
use verilog.vl_types.all;
entity processor_control is
    port(
        op_code         : in     vl_logic_vector(4 downto 0);
        op_min          : in     vl_logic_vector(1 downto 0);
        write_reg_sel   : out    vl_logic_vector(1 downto 0);
        reg_write       : out    vl_logic;
        pc_code         : out    vl_logic_vector(1 downto 0);
        comp_code       : out    vl_logic_vector(1 downto 0);
        alu_op_code     : out    vl_logic_vector(3 downto 0);
        alu_b_src       : out    vl_logic;
        pass_thr_sel    : out    vl_logic;
        imm_sel         : out    vl_logic_vector(1 downto 0);
        mem_read        : out    vl_logic;
        mem_write       : out    vl_logic;
        wb_sel          : out    vl_logic;
        createdump      : out    vl_logic;
        halt            : out    vl_logic
    );
end processor_control;
