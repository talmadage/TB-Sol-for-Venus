library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE WORK.types_pkg.ALL;

entity BRISC_top_no_io is
    port (
        clk      : in  std_logic; 
        reset    : in std_logic_vector(0 downto 0);

        data_addr_wire_out           : out MemoryAddress;
        we_wire_out                  : out std_logic;
        data4mem_wire_out            : out Word;
        data2mem_wire_out            : out Word;
        data4io_wire_out             : out Word;
        data2io_wire_out             : out Word
    );
end entity BRISC_top_no_io;

architecture Structural of BRISC_top_no_io is

    -- Component Declarations

    component bs_interface
        port (
            clk				: in std_logic;
			com_enable		: in std_logic;
			m_active		: in std_logic;
			tx_data			: in unsigned(1 downto 0);
			addr			: in unsigned(1 downto 0);
			s_active		: out std_logic;
			rx_data			: out unsigned(1 downto 0);

			data_addr		: out MemoryAddress;
			we				: out std_logic;
			data4mem		: in Word;					-- Data from memory
			data2mem		: out Word;					-- Data to memory
			data4io			: in Word;					-- Data from IO 
			data2io			: out Word					-- Data to IO 
        );
    end component;

    component CiscV
        port(
            clk:IN std_logic;
            s_active:IN std_logic_vector(0 downto 0);
            s_data:IN std_logic_vector(1 downto 0);
            sreset:IN std_logic_vector(0 downto 0);
            com_enable:OUT std_logic_vector(0 downto 0);
            m_active:OUT std_logic_vector(0 downto 0);
            addr:OUT std_logic_vector(1 downto 0);
            m_data:OUT std_logic_vector(1 downto 0);
            clk_out:OUT std_logic_vector(0 downto 0)

        );
    end component;

    -- Internal signals to connect modules
    signal clk_out_wire         : std_logic_vector(0 downto 0);
    signal com_enable_wire      : std_logic_vector(0 downto 0);
    signal m_active_wire        : std_logic_vector(0 downto 0);
    signal m_data_wire          : std_logic_vector(1 downto 0);
    signal addr_wire            : std_logic_vector(1 downto 0);
    signal s_active_wire        : std_logic_vector(0 downto 0);
    signal s_data_wire          : unsigned(1 downto 0);

begin

    -- Instantiate Module1
    
    U3: bs_interface
        port map(
            clk	=> clk_out_wire(0),
			com_enable => com_enable_wire(0),
			m_active => m_active_wire(0),
			tx_data => unsigned(m_data_wire),
			addr => unsigned(addr_wire),
			s_active => s_active_wire(0),
			rx_data => s_data_wire,
			data_addr => data_addr_wire_out,
			we => we_wire_out,
			data4mem => data4mem_wire_out,
			data2mem => data2mem_wire_out,
			data4io => data4io_wire_out,
			data2io => data2io_wire_out
        );

    U4: CiscV
        port map(

        clk => clk,
        s_active => s_active_wire,
        s_data => std_logic_vector(s_data_wire),
        sreset => reset,
        com_enable => com_enable_wire,
        m_active => m_active_wire,
        addr => addr_wire,
        m_data => m_data_wire,
        clk_out => clk_out_wire

        );

end architecture Structural;
