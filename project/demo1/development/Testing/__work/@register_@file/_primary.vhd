library verilog;
use verilog.vl_types.all;
entity register_file is
    generic(
        width           : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        read1data       : out    vl_logic_vector(15 downto 0);
        read2data       : out    vl_logic_vector(15 downto 0);
        err             : out    vl_logic;
        read1regsel     : in     vl_logic_vector(2 downto 0);
        read2regsel     : in     vl_logic_vector(2 downto 0);
        writeregsel     : in     vl_logic_vector(2 downto 0);
        writedata       : in     vl_logic_vector(15 downto 0);
        write           : in     vl_logic
    );
end register_file;
