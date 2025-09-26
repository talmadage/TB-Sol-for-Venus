library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;



entity noiCache is
  port (   clk              : in std_logic;
           reset            : in std_logic;
           boot             : in std_logic;
           
           -- Inputs to the cache
           reqAdr           : in MemoryAddress;
           -- Outputs
           instr            : out Word;
           instrValid       : out std_logic;
           
           -- Avalon outputs
           mm_address       : out std_logic_vector(31 downto 0);
           mm_read          : out std_logic;
           mm_readdata      : in std_logic_vector(31 downto 0);
           waitrequest      : in std_logic
           );
end entity;

architecture RTL of noiCache is

  
    
begin
  mm_address <= std_logic_vector(reqAdr);
  mm_read <= '1';

  instr <= unsigned(mm_readdata);
  instrValid <= '1' when (waitrequest = '0') else
                '0';
  
end;
