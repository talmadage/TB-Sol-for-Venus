library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dtekv_lib.all;
use work.debug.all;

entity exec_stage is  
  port (   clk     : in std_logic;
           reset   : in std_logic;           
           Decoded : in ExecPacket;
           Mem     : out MemoryPacket;
           stall   : in std_logic);
end entity;

architecture RTL of exec_stage is 
  signal ALU_res: Word;
  signal A,B : Word;
  signal nMem : MemoryPacket;
begin

  A <= decoded.operand1;
  B <= decoded.operand2;

  process(A,B,decoded)
    variable tmp : unsigned(63 downto 0);
  begin
    ALU_res <= A;
   case decoded.opcode is
      when opADD_SUB => ALU_res <= A + B;
                        if (decoded.cin_sra = "1") then
                          ALU_res <= A - B;
                        end if;
      when opAND     => ALU_res <= A and B;
      when opOR      => ALU_res <= A or B;
      when opXOR     => ALU_res <= A xor B;
                        
      when opSRL_SRA => ALU_res <= shift_right(A, to_integer(B(4 downto 0)));
                        if (decoded.cin_sra = "1") then
                          ALU_res <= unsigned(shift_right(signed(A), to_integer(B(4 downto 0))));
                        end if;
      when opSLL     => ALU_res <=  shift_left(A, to_integer(B(4 downto 0)));
      when opSLT     => ALU_res <= to_unsigned(1,32);
                        if (signed(A) >= signed(B)) then
                          ALU_res <= to_unsigned(0,32);
                        end if;

      when opSLTU    => ALU_res <= to_unsigned(1,32);
                        if (A >= B) then
                          ALU_res <= to_unsigned(0,32);
                        end if;

--      when opDIV     => if (B = 0) then
--                          ALU_res <= (others=>'0');
--                        else
--                          ALU_res <=to_unsigned(to_integer(A)/to_integer(B),32);
--                          ALU_res <= A / B;
--                        end if;


--      when opMUL     => tmp := A * B;
--                        ALU_res <= tmp(31 downto 0);
                        
      --when opREM     => 
      --when opREMU    => 
                        
      when others => --printf("Error: Unknown opcode: " & integer'image(to_integer(decoded.opcode)) & "\n");
    end case;
  end process;
  
  
  process(reset,clk,stall,decoded,alu_res,nmem)
  begin
    if (reset = '1') then
      Mem.mem_en <= "0";
      Mem.dstReg <= (others=>'0');
      Mem.adr <= (others=>'0');
    elsif (clk'event and clk='1') then

      if (stall = '0') then        
        Mem.mem_en   <= Decoded.mem_en;
        Mem.mem_rw   <= Decoded.mem_rw;
        Mem.mem_len  <= Decoded.mem_len;
        Mem.sign_ext <= Decoded.mem_se;
        Mem.adr      <= ALU_res;
        Mem.dstReg   <= Decoded.dstReg;
        Mem.data     <= Decoded.operand3;
      end if;
      
    end if;
  end process;
    
  
end;
