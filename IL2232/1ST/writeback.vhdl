library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;

entity writeback is  
  port (   clk      : in std_logic;
           reset    : in std_logic;
           --fromExec : in WritebackPacket;
           fromMem  : in WritebackPacket;
           toDecode : out WritebackPacket);
end entity;  

architecture RTL of writeback is
  
begin

  toDecode <= fromMem; --fromExec when (fromExec.dstReg /= 0) else fromMem;
    
  
end;
