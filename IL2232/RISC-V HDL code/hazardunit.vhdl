library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;

entity hazardunit is  
  port ( clk   : in std_logic;
         reset : in std_logic;
         rs1   : in RegNr;
         rs2   : in RegNr;
         rd    : in RegNr;
         rexec : in RegNr;
         rmem  : in RegNr;
         rwb   : in RegNr;
         stall : out std_logic);
end entity;  

architecture RTL of hazardunit is
begin

  stall <= '1' when (rs1 /= 0 and rs1 = rexec) else -- Forwarding
           '1' when (rs2 /= 0 and rs2 = rexec) else -- Forwarding
           '1' when (rs1 /= 0 and rs1 = rmem)   else -- Forwarding
           '1' when (rs2 /= 0 and rs2 = rmem)   else -- Forwarding
           '1' when (rs1 /= 0 and rs1 = rwb)   else -- Forwarding
           '1' when (rs2 /= 0 and rs2 = rwb)   else -- Forwarding           
--           '1' when (rd /= 0  and rd = rexec)  else -- Forwarding
--           '1' when (rwb /= 0 and rwb = rwb) else   -- Forwarding
           '0';
  
end;
