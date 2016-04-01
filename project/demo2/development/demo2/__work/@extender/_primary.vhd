library verilog;
use verilog.vl_types.all;
entity extender is
    port(
        extend          : in     vl_logic_vector(10 downto 0);
        imm5s           : out    vl_logic_vector(15 downto 0);
        imm5z           : out    vl_logic_vector(15 downto 0);
        imm8s           : out    vl_logic_vector(15 downto 0);
        dis11           : out    vl_logic_vector(15 downto 0)
    );
end extender;
