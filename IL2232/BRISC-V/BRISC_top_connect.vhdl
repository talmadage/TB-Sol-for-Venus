library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity BRISC_top_connect is
    port (
        -- Standard FPGA signals
        FPGA_CLK_50 : in  std_logic;                     -- 50 MHz board clock
        KEY         : in  std_logic_vector(1 downto 0);  -- Reset buttons
        LED         : out std_logic_vector(7 downto 0);  -- Status LEDs
        
        -- GPIO Header for external communication
        GPIO_0      : inout std_logic_vector(9 downto 0)  -- 10 GPIO pins
    );
end entity BRISC_top_connect;

architecture rtl of BRISC_top_connect is

    ----------------------------------------------------------------------
    -- Internal signals to connect FPGA with BRISC core
    ----------------------------------------------------------------------
    signal clk   : std_logic;
    signal reset : std_logic_vector(0 downto 0);

    -- Optional: instruction and control signals (for standalone testing)
    signal instruction_data        : Word := (others => '0');
    signal load_instruction_enable : std_logic := '0';
    signal new_instruction         : std_logic := '0';
    
    -- Separate signals for input and output
    signal io_ports_out : unsigned(IOPorts-1 downto 0);
    signal io_ports_in  : unsigned(IOPorts-1 downto 0);

begin
    ----------------------------------------------------------------------
    -- Clock and reset mapping
    ----------------------------------------------------------------------
    clk        <= FPGA_CLK_50;
    reset(0)   <= not KEY(0);       -- Active-low reset from button

    ----------------------------------------------------------------------
    -- Instantiate BRISC core with separated I/O
    ----------------------------------------------------------------------
    u_core : entity work.BRISC_V
        port map (
            clk                     => clk,
            reset                   => reset,
            instruction_data        => instruction_data,
            load_instruction_enable => load_instruction_enable,
            new_instruction         => new_instruction,
            io_ports_out            => io_ports_out,
            io_ports_in             => io_ports_in
        );

    ----------------------------------------------------------------------
    -- GPIO bidirectional control
    ----------------------------------------------------------------------
    -- Data pins (0-7): Bidirectional
    -- Drive when outputting, otherwise high-impedance
    GPIO_0(7 downto 0) <= std_logic_vector(io_ports_out(7 downto 0)) 
                          when io_ports_out(8) = '1' else (others => 'Z');
    
    -- TX_VALID (pin 8): Output only
    GPIO_0(8) <= std_logic(io_ports_out(8));
    
    -- RX_READY (pin 9): Input only (high-impedance from FPGA side)
    GPIO_0(9) <= 'Z';
    
    -- Read GPIO state back into internal signal
    io_ports_in <= unsigned(GPIO_0);

    ----------------------------------------------------------------------
    -- Debug LEDs (shows first 8 bits of I/O data)
    ----------------------------------------------------------------------
    process (clk)
        variable counter : unsigned(25 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            counter := counter + 1;
            
            -- LED(0) = Heartbeat
            LED(0) <= counter(counter'high);
            
            -- LED(7 downto 1) = GPIO input state
            LED(7 downto 1) <= std_logic_vector(io_ports_in(6 downto 0));
        end if;
    end process;

end architecture rtl;