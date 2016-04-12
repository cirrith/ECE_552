library verilog;
use verilog.vl_types.all;
entity branch_logic is
    port(
        comp_code       : in     vl_logic_vector(1 downto 0);
        reg_1_data      : in     vl_logic_vector(15 downto 0);
        pc_det_forward  : in     vl_logic;
        pc_det_forward_data: in     vl_logic_vector(15 downto 0);
        branch          : out    vl_logic
    );
end branch_logic;
