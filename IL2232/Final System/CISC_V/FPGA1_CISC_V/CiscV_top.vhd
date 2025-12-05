LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CiscV_top IS
   PORT(
      -- Clock input (50 MHz dalla board)
      CLOCK_50     : IN  std_logic;
      
      -- Reset button (KEY0)
      KEY          : IN  std_logic_vector(0 downto 0);
      
      -- GPIO pins
      GPIO_0       : INOUT std_logic_vector(9 downto 0);
      
      -- LED for debug (optional)
      LED          : OUT std_logic_vector(7 downto 0)
   );
END CiscV_top;

ARCHITECTURE structural OF CiscV_top IS

   -- Component declarations
   COMPONENT CiscV
      PORT(
         clk         : IN  std_logic;
         s_active    : IN  std_logic_vector(0 downto 0);
         s_data      : IN  std_logic_vector(1 downto 0);
         sreset      : IN  std_logic_vector(0 downto 0);
         com_enable  : OUT std_logic_vector(0 downto 0);
         m_active    : OUT std_logic_vector(0 downto 0);
         addr        : OUT std_logic_vector(1 downto 0);
         m_data      : OUT std_logic_vector(1 downto 0);
         clk_out     : OUT std_logic_vector(0 downto 0)
      );
   END COMPONENT;
   
   COMPONENT clock_divider
      PORT(
         clk_in      : IN  std_logic;
         reset       : IN  std_logic;
         clk_out     : OUT std_logic
      );
   END COMPONENT;

   -- Internal signals
   SIGNAL clk_1mhz       : std_logic;
   SIGNAL reset_n        : std_logic;
   SIGNAL reset_sync     : std_logic;
   
   -- CiscV signals
   SIGNAL s_active_sig   : std_logic_vector(0 downto 0);
   SIGNAL s_data_sig     : std_logic_vector(1 downto 0);
   SIGNAL sreset_sig     : std_logic_vector(0 downto 0);
   SIGNAL com_enable_sig : std_logic_vector(0 downto 0);
   SIGNAL m_active_sig   : std_logic_vector(0 downto 0);
   SIGNAL addr_sig       : std_logic_vector(1 downto 0);
   SIGNAL m_data_sig     : std_logic_vector(1 downto 0);
   SIGNAL clk_out_sig    : std_logic_vector(0 downto 0);

BEGIN

   -- ===================================
   -- Reset synchronization
   -- ===================================
   reset_n <= KEY(0);  -- Active LOW reset button
   
   reset_sync_proc: PROCESS(CLOCK_50, reset_n)
      VARIABLE reset_shift : std_logic_vector(2 downto 0) := "000";
   BEGIN
      IF reset_n = '0' THEN
         reset_shift := "000";
         reset_sync <= '1';
      ELSIF rising_edge(CLOCK_50) THEN
         reset_shift := reset_shift(1 downto 0) & '1';
         reset_sync <= NOT reset_shift(2);
      END IF;
   END PROCESS;
   
   sreset_sig(0) <= reset_sync;

   -- ===================================
   -- Clock Divider: 50 MHz -> 1 MHz
   -- ===================================
   clk_div: clock_divider
      PORT MAP(
         clk_in   => CLOCK_50,
         reset    => reset_sync,
         clk_out  => clk_1mhz
      );

   -- ===================================
   -- CiscV Processor Instance
   -- ===================================
   processor: CiscV
      PORT MAP(
         clk        => clk_1mhz,
         s_active   => s_active_sig,
         s_data     => s_data_sig,
         sreset     => sreset_sig,
         com_enable => com_enable_sig,
         m_active   => m_active_sig,
         addr       => addr_sig,
         m_data     => m_data_sig,
         clk_out    => clk_out_sig
      );

   -- ===================================
   -- GPIO Mapping - GPIO_0 Header
   -- ===================================
   -- Input signals da GPIO_0 (Pin 1, 3, 5)
   s_active_sig(0) <= GPIO_0(0);  
   s_data_sig(0)   <= GPIO_0(1);  
   s_data_sig(1)   <= GPIO_0(2);  
   
   -- Output signals su GPIO_0
   GPIO_0(3) <= com_enable_sig(0);  
   GPIO_0(4) <= m_active_sig(0);    
   GPIO_0(5) <= addr_sig(0);        
   GPIO_0(6) <= addr_sig(1);        
   GPIO_0(7) <= m_data_sig(0);      
   GPIO_0(8) <= m_data_sig(1);      
   GPIO_0(9) <= clk_out_sig(0);     
   
   -- ===================================
   -- Debug LEDs
   -- ===================================
   LED(0) <= com_enable_sig(0);
   LED(1) <= m_active_sig(0);
   LED(2) <= addr_sig(0);
   LED(3) <= addr_sig(1);
   LED(4) <= m_data_sig(0);
   LED(5) <= m_data_sig(1);
   LED(6) <= clk_out_sig(0);
   LED(7) <= clk_1mhz;

END structural;