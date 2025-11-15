library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity BRISC_top_connect is
    port (
        -- External FPGA signals
        FPGA_CLK_50 : in  std_logic;                     -- 50 MHz board clock
        KEY         : in  std_logic_vector(1 downto 0);  -- Reset buttons
        LED         : out std_logic_vector(7 downto 0)   -- Status LEDs
    );
end entity BRISC_top_connect;

architecture rtl of BRISC_top_connect is

    ----------------------------------------------------------------------
    -- Internal signals to connect the FPGA with the BRISC core
    ----------------------------------------------------------------------
    signal clk   : std_logic;
    signal reset : std_logic_vector(0 downto 0);

    -- Optional: instruction and control signals (for standalone testing)
    signal instruction_data        : Word := (others => '0');
    signal load_instruction_enable : std_logic := '0';
    signal new_instruction         : std_logic := '0';

begin
    ----------------------------------------------------------------------
    -- Clock and reset mapping
    ----------------------------------------------------------------------
    clk        <= FPGA_CLK_50;
    reset(0)   <= not KEY(0);       -- Active-low reset from button

    ----------------------------------------------------------------------
    -- Instantiate BRISC core
    ----------------------------------------------------------------------
    u_core : entity work.BRISC_V
        port map (
            clk                     => clk,
            reset                   => reset,
            instruction_data        => instruction_data,
            load_instruction_enable => load_instruction_enable,
            new_instruction         => new_instruction
        );

    ----------------------------------------------------------------------
    -- Simple heartbeat process (to ensure synthesis keeps the design)
    -- This will toggle LED(0) at a visible rate.
    ----------------------------------------------------------------------
    process (clk)
        variable counter : unsigned(25 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            counter := counter + 1;
        end if;
        LED(0) <= counter(counter'high);
        LED(7 downto 1) <= (others => '0');
    end process;

end architecture rtl;
