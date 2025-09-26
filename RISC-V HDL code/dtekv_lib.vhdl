library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all; 
use IEEE.math_real.all;

package dtekv_lib is

  -- Default 8-bit unsigned value
  constant AddressWidth : integer := 32;
  
  subtype OneBit is unsigned(0 downto 0);
  subtype Byte is unsigned(7 downto 0);
  subtype Word is unsigned(31 downto 0);
  subtype MemoryAddress is unsigned(AddressWidth-1 downto 0);
  subtype ALUOp is unsigned(3 downto 0);

  subtype Opcode  is unsigned(6 downto 0);

  constant RegBits : integer := 5;
  constant NumReg  : integer := 2**Regbits;
  subtype RegNr   is unsigned(RegBits-1 downto 0);


  -- Direct-Mapped I-Cache information 
  constant ICacheIndexBits      : integer := 5;
  constant ICacheBlockBits      : integer := 3;
  constant ICacheIndexNum       : integer := 2**ICacheIndexBits;
  constant ICacheBlockSize      : integer := 2**ICacheBlockBits;
  constant ICacheTagSize        : integer := AddressWidth-ICacheIndexBits-ICacheBlockBits-2;

  type data_t is array(0 to ICacheBlockSize-1) of Word;

  type ICacheBlock is record
    valid : OneBit;
    tag   : unsigned(ICacheTagSize-1 downto 0);
    data  : data_t;
  end record ICacheBlock;


  -- Direct-Mapped D-Cache information 
  constant DCacheIndexBits      : integer := 5;
  constant DCacheBlockBits      : integer := 3;
  constant DCacheIndexNum       : integer := 2**DCacheIndexBits;
  constant DCacheBlockSize      : integer := 2**DCacheBlockBits;
  constant DCacheTagSize        : integer := AddressWidth-ICacheIndexBits-ICacheBlockBits-2;
  constant DCacheIOAddress      : integer := 16#04000000#;
    
  type data_t1 is array(0 to DCacheBlockSize-1) of Word;

  type DCacheBlock is record
    valid : OneBit;
    dirty : OneBit;
    tag   : unsigned(DCacheTagSize-1 downto 0);
    data  : data_t1;
  end record DCacheBlock;
  -------------------------------------

  type ExecPacket is record
    cin_sra  : OneBit;  -- '1' means Sub or Sra
    mem_en   : OneBit;
    mem_rw   : OneBit;
    mem_len  : unsigned(1 downto 0);
    mem_se   : OneBit;
    opcode   : ALUOp;
    operand1 : Word; -- To ALU
    operand2 : Word; -- To ALU
    operand3 : Word; -- For writing data to memory
    dstReg   : RegNr;
  end record ExecPacket;

  type WritebackPacket is record
    result : Word;
    dstReg : RegNr;    
  end record WritebackPacket;

  type MemoryPacket is record
    mem_en   : OneBit;
    mem_rw   : OneBit;
    mem_len  : unsigned(1 downto 0);
    sign_ext : OneBit;
    adr      : Word;
    dstReg   : RegNr;
    data     : Word;    
  end record MemoryPacket;

  -- ALU Opcodes
  constant opADD_SUB  : ALUOp := "0000";
  constant opSLL      : ALUOp := "0001";
  constant opSLT      : ALUOp := "0010";
  constant opSLTU     : ALUOp := "0011";
  constant opXOR      : ALUOp := "0100";
  constant opSRL_SRA  : ALUOp := "0101";
  constant opOR       : ALUOp := "0110";
  constant opAND      : ALUOp := "0111";

  -- Mul/Div
  constant opMUL      : ALUOp := "1000";
  constant opMULH     : ALUOp := "1001";
  constant opMULHSU   : ALUOp := "1010";
  constant opMULHU    : ALUOp := "1011";
  constant opDIV      : ALUOp := "1100";
  constant opDIVU     : ALUOp := "1101";
  constant opREM      : ALUOp := "1110";
  constant opREMU     : ALUOp := "1111";

                          

  -- Component declarations
  component if_decode 
  port (   clk       : in std_logic;
           reset     : in std_logic;
           go        : in std_logic;           
           
           PC         : out MemoryAddress;
           Instr      : in Word;
           Instr_valid: in std_logic;
           
           IDecoded  : out ExecPacket;
           Wb_to_dec : in WritebackPacket;

           hrs1       : out RegNr;
           hrs2       : out RegNr;
           hrd        : out RegNr;
           
           hazard    : in std_logic;
           stall     : in std_logic);  
  end component;


  component iCache
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
           waitrequest      : in std_logic;
           readdatavalid    : in std_logic;
           mm_burstcount    : out std_logic_vector(ICacheBlockBits downto 0)
           );
  end component;


component dCache
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
           waitrequest      : in std_logic;
           readdatavalid    : in std_logic;
           mm_burstcount    : out std_logic_vector(DCacheBlockBits downto 0)
           );
end component;
  

  component exec_stage
    port (   clk     : in std_logic;
             reset   : in std_logic;           
             Decoded : in ExecPacket;
             Mem     : out MemoryPacket;
             stall   : in std_logic);
  end component;


  component writeback 
    port (   clk      : in std_logic;
             reset    : in std_logic;
             --fromExec : in WritebackPacket;
             fromMem  : in WritebackPacket;
             toDecode : out WritebackPacket);           
  end component;


component mem_stage
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
end component;


component hazardunit   
  port ( clk   : in std_logic;
         reset : in std_logic;
         rs1   : in RegNr;
         rs2   : in RegNr;
         rd    : in RegNr;
         rexec : in RegNr;
         rmem  : in RegNr;
         rwb   : in RegNr;
         stall : out std_logic);
end component;  


component nodCache
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
end component;


component noiCache
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
end component;

  
end package dtekv_lib;
