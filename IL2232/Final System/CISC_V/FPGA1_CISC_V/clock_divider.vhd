LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY clock_divider IS
   PORT(
      clk_in   : IN  std_logic;  -- 50 MHz input clock
      reset    : IN  std_logic;  -- Active HIGH reset
      clk_out  : OUT std_logic   -- 1 MHz output clock
   );
END clock_divider;

ARCHITECTURE rtl OF clock_divider IS
   
   -- to divide 50 MHz in 1 MHz:
   -- 50 MHz / 1 MHz = 50
   -- We need to count 25 toggles (50/2)
   CONSTANT DIV_VALUE : integer := 25;
   
   SIGNAL counter : integer range 0 to DIV_VALUE-1 := 0;
   SIGNAL clk_reg : std_logic := '0';
   
BEGIN

   divider_proc: PROCESS(clk_in, reset)
   BEGIN
      IF reset = '1' THEN
         counter <= 0;
         clk_reg <= '0';
      ELSIF rising_edge(clk_in) THEN
         IF counter = DIV_VALUE-1 THEN
            counter <= 0;
            clk_reg <= NOT clk_reg;
         ELSE
            counter <= counter + 1;
         END IF;
      END IF;
   END PROCESS;
   
   clk_out <= clk_reg;

END rtl;