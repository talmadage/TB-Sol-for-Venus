library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;

entity mem_stage is  
  port (   clk       : in std_logic;
           reset     : in std_logic;
           mem_packet : in MemoryPacket;
           wb_packet : out WritebackPacket;

           data_adr : out MemoryAddress;
           data_in  : in Word;
           data_out : out Word;
           data_bs  : out std_logic_vector(3 downto 0);
           data_en  : out OneBit;
           data_rw  : out OneBit;
           data_rdy : in OneBit;           
           stall_out : out std_logic);
end entity;  

architecture RTL of mem_stage is
  signal internal_stall : std_logic;
  signal internal_data_in : Word;

  
begin

  
--  internal_stall <= '1' when (data_rdy_n='1'and mem_packet.mem_en="1") else '0';


  internal_stall <= '1' when (mem_packet.mem_en="1" and data_rdy="0") else '0';
                    
  
  stall_out <= internal_stall;
  
  -- Always work with word-based addresses
  data_adr <=  mem_packet.adr(31 downto 2) & "00";
  data_out <= shift_left(mem_packet.data, 8*to_integer(mem_packet.adr(1 downto 0)));				  
  data_bs <= "0001" when (mem_packet.mem_len="00" and mem_packet.adr(1 downto 0) = "00") else
             "0010" when (mem_packet.mem_len="00" and mem_packet.adr(1 downto 0) = "01") else
             "0100" when (mem_packet.mem_len="00" and mem_packet.adr(1 downto 0) = "10") else
             "1000" when (mem_packet.mem_len="00" and mem_packet.adr(1 downto 0) = "11") else  
             "0011" when (mem_packet.mem_len="01" and mem_packet.adr(1 downto 0) = "00") else				 
             "1100" when (mem_packet.mem_len="01" and mem_packet.adr(1 downto 0) = "10") else				 
             "1111";

  -- Only access buss when we are idle
  data_en <= mem_packet.mem_en;
  data_rw <= mem_packet.mem_rw;
  
  internal_data_in <= shift_right(data_in, 8*to_integer(mem_packet.adr(1 downto 0)));
  
  process(clk,reset,mem_packet,internal_stall,data_rdy,internal_data_in,data_in)
    variable b0,b1,b2,b3 : Byte;
  begin
    if (reset = '1') then
      wb_packet.dstReg <= (others=>'0');
    elsif (clk='1' and clk'event) then
      
      wb_packet.dstReg <= (others=>'0');

      -- Non memory packet
      if (mem_packet.mem_en = "0") then
        wb_packet.result <= mem_packet.adr;
        wb_packet.dstReg <= mem_packet.dstReg;		 
      end if;

      if (mem_packet.mem_en = "1" and mem_packet.mem_rw="0" and data_rdy = "1") then        
        wb_packet.dstReg <= mem_packet.dstReg;
        case mem_packet.mem_len is
          -- Load a 8-bit value and possibly extend it
          when "00" => wb_packet.result <= internal_data_in;
                       if (internal_data_in(7) = '1' and mem_packet.sign_ext = "1") then
                         wb_packet.result <= "111111111111111111111111" &  internal_data_in(7 downto 0);
                       end if;

          -- Load a 16-bit value and possible extend it
          when "01" => wb_packet.result <= internal_data_in;
                       if (internal_data_in(15) = '1' and mem_packet.sign_ext = "1") then
                         wb_packet.result <= "1111111111111111" & data_in(15 downto 0);
                       end if;
															
          -- Load a 32-bit value
          when "10" => wb_packet.result <= data_in;
          --printf("Loaded Word: " & integer'image(to_integer(extern_loadword(to_integer(mem_packet.adr)))) & " from Adress: " & integer'image(to_integer(mem_packet.adr)));
          when  others => 
        end case;                              
      end if; --Capture data_rdy
		
    end if;
  end process;
      
  
end architecture RTL;

