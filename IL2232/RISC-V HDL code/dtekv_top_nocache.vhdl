library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;

entity dtekv_top is
  port ( clk   : in std_logic;
         reset : in std_logic;
         avm_instr_read_adr     : out std_logic_vector(31 downto 0);
         avm_instr_read_data    : in std_logic_vector(31 downto 0);
         avm_instr_read         : out std_logic;
         avm_instr_read_waitreq : in std_logic;

         avm_ctrl_slave_data      : in std_logic_vector(7 downto 0);
         avm_ctrl_slave_write     : in std_logic;
         avm_ctrl_slave_waitreq   : out std_logic;

         avm_data_adr           : out std_logic_vector(31 downto 0);
         avm_data_read          : out std_logic;
         avm_data_write         : out std_logic;
         avm_data_read_data     : in std_logic_vector(31 downto 0);
         avm_data_write_data    : out std_logic_vector(31 downto 0);
         avm_data_write_byten   : out std_logic_vector(3 downto 0);
         avm_data_waitreq       : in std_logic
         );
end entity;  


architecture RTL of dtekv_top is

  signal go : std_logic := '0';
  
  signal icache_adr : MemoryAddress;
  signal icache_instr : Word;
  signal icache_instr_valid : std_logic;


  -- From MemStage -> DCache
  signal dcache_adr : MemoryAddress;
  signal dcache_en  : OneBit;
  signal dcache_rw  : OneBit;
  signal dcache_wrdata : Word;
  signal dcache_lddata : Word;
  signal dcache_complete : OneBit;
  signal dcache_bs : std_logic_vector(3 downto 0);
  
  signal if_to_exec : ExecPacket;
  signal exec_to_wb : WritebackPacket;
  signal mem_to_wb  : WritebackPacket;
  signal wb_to_dec  : WritebackPacket;
  signal exec_to_mem : MemoryPacket;

  signal dcache_stall : std_logic;

  signal drs1, drs2, drd : RegNr;
  signal hazard     : std_logic;

  signal data_en, data_rw : std_logic;
  signal local_avm_data_adr           : MemoryAddress;
  signal local_avm_data_read_data     : Word;
  signal local_avm_data_write_data    : Word;
  signal hazard_or_stall : std_logic;

begin

  -- Description
  go <= '1' when (avm_ctrl_slave_write='1' and avm_ctrl_slave_data="11110000") else '0';
  avm_ctrl_slave_waitreq <= '0';


  IFD0: if_decode port map (clk, reset, go,
                            icache_adr,
                            icache_instr, icache_instr_valid,                            
                            if_to_exec,
                            wb_to_dec,
                            drs1, drs2, drd,
                            hazard,dcache_stall);

  ICACHE0: noiCache port map (clk, reset, go,
                              icache_adr,
                              icache_instr, icache_instr_valid,
                              avm_instr_read_adr, avm_instr_read,
                              avm_instr_read_data,avm_instr_read_waitreq);
                           
  DCACHE0: nodCache port map (clk, reset, go,
                              dcache_adr, dcache_en, dcache_rw,
                              dcache_wrdata, dcache_lddata, dcache_complete,
                              dcache_bs,

                              avm_data_adr, avm_data_read, avm_data_write,
                              avm_data_read_data, avm_data_write_data,
                              avm_data_write_byten,
                              avm_data_waitreq);
                                                                                    

  EXE0: exec_stage  port map (clk, reset, if_to_exec, exec_to_mem, dcache_stall);

  DC0: mem_stage port map (clk, reset, exec_to_mem, mem_to_wb,
                           
                           dcache_adr, dcache_lddata, dcache_wrdata,
                           dcache_bs, dcache_en, dcache_rw, dcache_complete,

                           dcache_stall);
                           
                          
  
  --avm_data_adr <= std_logic_vector(local_avm_data_adr);
  --local_avm_data_read_data <= unsigned(avm_data_read_data);  
  --avm_data_write_data <=  std_logic_vector(local_avm_data_write_data);  
  --avm_data_read <= data_en and not(data_rw);
  --avm_data_write <= data_en and data_rw;
                        
  WB0: writeback  port map (clk, reset, mem_to_wb, wb_to_dec);


  HAZ0: hazardunit port map (clk, reset,
                             drs1, drs2, drd,
                             if_to_exec.dstReg,
                             exec_to_mem.dstReg,
                             wb_to_dec.dstReg,
                             hazard);


  hazard_or_stall <= hazard or dcache_stall or not(go);  
  
end;

