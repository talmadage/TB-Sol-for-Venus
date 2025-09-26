library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;


entity nodCache is
  port (   clk              : in std_logic;
           reset            : in std_logic;
           boot             : in std_logic;
           
           -- Inputs to the Dcache
           reqAdr           : in MemoryAddress;           
           en               : in OneBit;
           rw               : in OneBit;           
           wrdata           : in  Word;           
           data             : out Word;           
           complete         : out OneBit;
           bs               : in std_logic_vector(3 downto 0);
           
           -- Avalon outputs
           mm_address       : out std_logic_vector(31 downto 0);
           mm_read          : out std_logic;
           mm_write         : out std_logic;
           mm_readdata      : in std_logic_vector(31 downto 0);
           mm_writedata     : out std_logic_vector(31 downto 0);
           mm_byteenable    : out std_logic_vector(3 downto 0);
           waitrequest      : in std_logic
           );
end entity;

architecture RTL of nodCache is  
begin

  mm_address <= std_logic_vector(reqAdr);
  mm_read <= '1' when (rw="0" and en="1") else '0';
  mm_write <= '1' when (rw="1" and en="1") else '0';
  mm_writedata <= std_logic_vector(wrdata);
  data <= unsigned(mm_readdata);
  mm_byteenable <= bs;

  complete <= "1" when (waitrequest = '0' and en="1") else "0";
  
end;


