library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;
use work.debug.all;

entity if_decode is  
  port (   clk       : in std_logic;
           reset     : in std_logic;
           go        : in std_logic;
           PC        : out MemoryAddress;
           
           Instr     : in Word;
           Instr_valid: in std_logic;
           
           IDecoded  : out ExecPacket;
           Wb_to_dec : in WritebackPacket;

           hrs1       : out RegNr;
           hrs2       : out RegNr;
           hrd        : out RegNr;
           hazard     : in std_logic;
           stall      : in std_logic
           );           
end entity;  

architecture RTL of if_decode is
  signal ProgramCounter : MemoryAddress := (others=>'0');

  signal iStall : std_logic := '0';
  signal idle : std_logic := '1';  

  signal Decoded, curDecoded : ExecPacket;
  signal Rs1_busy, Rs2_busy : std_logic;
  
  -- Alias helpers
  alias Opc    : Opcode is Instr(6 downto 0);
  alias Rd     : RegNr  is Instr(11 downto 7);
  alias Rs1    : RegNr  is Instr(19 downto 15);
  alias Rs2    : RegNr  is Instr(24 downto 20);
  alias Funct3 : unsigned(2 downto 0) is Instr(14 downto 12);
  alias Funct7 : unsigned(6 downto 0) is Instr(31 downto 25);
  signal IMM_Itype : unsigned(31 downto 0);
  signal IMM_Stype : unsigned(31 downto 0);
  signal IMM_Btype : unsigned(31 downto 0);
  signal IMM_Jtype : unsigned(31 downto 0);
  signal IMM_Utype : unsigned(31 downto 0);

  type RegisterFileState_T is array (0 to NumReg-1) of std_logic;
  signal RegisterFileState : RegisterFileState_T := ('0', --r0
                                                     '0', --r1
                                                     '0', --r2
                                                     '0', --r3
                                                     '0', --r4
                                                     '0', --r5
                                                     '0', --r6
                                                     '0', --r7
                                                     '0', --r8
                                                     '0', --r9
                                                     '0', --r10
                                                     '0', --r11
                                                     '0', --r12
                                                     '0', --r13
                                                     '0', --r14
                                                     '0', --r15
                                                     '0', --r16
                                                     '0', --r17
                                                     '0', --r18
                                                     '0', --r19
                                                     '0', --r20
                                                     '0', --r21
                                                     '0', --r22
                                                     '0', --r23
                                                     '0', --r24
                                                     '0', --r25
                                                     '0', --r26
                                                     '0', --r27
                                                     '0', --r28
                                                     '0', --r29
                                                     '0', --r30
                                                     '0');--r31
                                                       
                                                       
  
  type RegisterFile_T is array ( 0 to NumReg-1) of Word;
  signal RegisterFile :  RegisterFile_T := ("00000000000000000000000000000000", --r0
                                            "00000000000000000000000000000000", --r1
                                            "00000000000000000000111111111111", --r2
                                            "00000000000000000000000000000000", --r3
                                            "00000000000000000000000000000000", --r4
                                            "00000000000000000000000000000000", --r5
                                            "00000000000000000000000000000000", --r6
                                            "00000000000000000000000000000000", --r7
                                            "00000000000000000000111111111111", --r8
                                            "00000000000000000000000000000000", --r9
                                            "00000000000000000000000000000000", --r10
                                            "00000000000000000000000000000000", --r11
                                            "00000000000000000000000000000000", --r12
                                            "00000000000000000000000000000000", --r13
                                            "00000000000000000000000000000000", --r14
                                            "00000000000000000000000000000000", --r15
                                            "00000000000000000000000000000000", --r16
                                            "00000000000000000000000000000000", --r17
                                            "00000000000000000000000000000000", --r18
                                            "00000000000000000000000000000000", --r19
                                            "00000000000000000000000000000000", --r20
                                            "00000000000000000000000000000000", --r21
                                            "00000000000000000000000000000000", --r22
                                            "00000000000000000000000000000000", --r23
                                            "00000000000000000000000000000000", --r24
                                            "00000000000000000000000000000000", --r25
                                            "00000000000000000000000000000000", --r26
                                            "00000000000000000000000000000000", --r27
                                            "00000000000000000000000000000000", --r28
                                            "00000000000000000000000000000000", --r29
                                            "00000000000000000000000000000000", --r30
                                            "00000000000000000000000000000000");--r31


  signal source_reg_1, source_reg_2 : Word;
  signal goBranch : OneBit;
  
begin


  ---------------------------- Compute all Immediate types -------------------------------
  IMM_Itype <= "11111111111111111111" & Instr(31 downto 20) when Instr(31) = '1' else
               "00000000000000000000" & Instr(31 downto 20);  

  IMM_Stype <= "11111111111111111111" & Instr(31 downto 25) & Instr(11 downto 7) when Instr(31) = '1' else "00000000000000000000" & Instr(31 downto 25) & Instr(11 downto 7);

  IMM_Btype <= ("1111111111111111111" & Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & "0") when Instr(31) = '1' else ("0000000000000000000" & Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & "0");

  IMM_Jtype <= ("11111111111" & Instr(31) & Instr(19 downto 12) & Instr(20) & Instr(30 downto 21) & "0") when Instr(31)='1' else
               ("00000000000" & Instr(31) & Instr(19 downto 12) & Instr(20) & Instr(30 downto 21) & "0");

  IMM_Utype <= Instr(31 downto 12) & "000000000000";  
  ---------------------------- /Compute all Immediate types ------------------------------
  

  
  
  ---------------------------- Compute whether we branch here -------------------------------
  goBranch <= "1" when (source_reg_1 = source_reg_2 and funct3 = "000")                 else
              "1" when (source_reg_1/= source_reg_2 and funct3 = "001")                 else
              "1" when (signed(source_reg_1) < signed(source_reg_2) and funct3 = "100") else
              "1" when (signed(source_reg_1)>= signed(source_reg_2) and funct3 = "101") else
              "1" when (source_reg_1 < source_reg_2 and funct3 = "110")                 else
              "1" when (source_reg_1>= source_reg_2 and funct3 = "111")                 else
              "0";
  ----------------------------/Compute whether we branch here -------------------------------


  ------------------------------- Bind signals to output -----------------------------------
  PC <= ProgramCounter;
  
  hrs1 <= rs1;
  hrs2 <= rs2;
  hrd <= rd;
    
  iStall <= hazard or stall;
  
  IDecoded <= decoded;
  curDecoded <= decoded;
  -------------------------------/Bind signals to output -----------------------------------

  

  ------------------------------- Combinatorial read from register file  -----------------------------------
  source_reg_1 <= RegisterFile(to_integer(Rs1));
  source_reg_2 <= RegisterFile(to_integer(Rs2));
  -------------------------------/Combinatorial read from register file  -----------------------------------
  
  process(clk,reset,programcounter, WB_to_dec,curDecoded,Instr, go, iStall,stall,Instr_valid)
    variable tmp : MemoryAddress;
    variable reg_we : Bit;
    variable reg_dst : RegNr;
    variable reg_val : Word;

    variable res_we : Bit;
  begin

    -- Reset signal
    if (reset = '1') then
      ProgramCounter <= (others=>'0');  -- Clear Program counter
      idle <= '1';                      -- Set idle register to default '1'
                                        -- (that is, CPU is waiting to be started)
      decoded.mem_en <= "0";            -- Create a default "nop" out packet
      decoded.mem_rw <= "0";            -- Do not access memory
      decoded.cin_sra  <= "0";          -- Neither cin nor sra
      decoded.opcode <= opADD_SUB;      -- Add instruction (add r0,r0,r0)
      decoded.operand1 <= (others=>'0');-- op1 = r0
      decoded.operand2 <= (others=>'0');-- op2 = r0
      decoded.dstReg <= (others=>'0');  -- dst = r0
      RegisterFile <= (others=>(others=>'0')); -- Initiate all registers to 0
    elsif (clk'event and clk='1') then

      if (go = '1') then
        idle <= '0';
      end if;
      
        reg_we := '0';
        res_we := '0';
        
        -- Writeback to the register file
        if (Wb_to_dec.dstReg /= 0) then
          reg_dst := Wb_to_dec.dstReg;
          reg_val := Wb_to_dec.result;
          reg_we := '1';
        end if;

        if (stall = '1') then
          decoded <= curDecoded;
        else
          decoded.mem_en <= "0";
          decoded.mem_rw <= "0";
          decoded.cin_sra  <= "0";
          decoded.opcode <= opADD_SUB;
          decoded.operand1 <= (others=>'0');
          decoded.operand2 <= (others=>'0');
          decoded.dstReg <= (others=>'0');
        end if;



        if (idle = '0' and iStall = '0' and stall = '0' and instr_valid = '1') then
          -- Flip-Flop logic follows
          ProgramCounter <= ProgramCounter + 4;
          --printf("PC: " & integer'image(to_integer(ProgramCounter)));
        
          -- What type of format?
          case Opc is
            when "0010011" => --printf("-> I-type");
                              decoded.opcode   <= "0" & Funct3;
                              decoded.cin_sra <= "0";
                              decoded.operand1 <= source_reg_1;
                              decoded.operand2 <= IMM_Itype;
                              if (Funct3 = "101") then
                                decoded.cin_sra  <= Funct7(5 downto 5);
                                decoded.operand2 <= (others=>'0');
                                decoded.operand2(4 downto 0) <= rs2;
                              end if;
                              decoded.dstReg   <= Rd;
                              res_we := '1';
                            
            when "0000011" => --printf("-> S-type\n"); --Memory load
                              --printf("{ Load Offset = " & integer'image(to_integer(IMM_Stype(30 downto 0))) & "\n");
                              decoded.opcode <= opADD_SUB;
                              decoded.cin_sra <= "0";
                              decoded.mem_se(0) <= '0';
                              if (Funct3 = "000" or Funct3 = "001") then
                              decoded.mem_se(0) <= '1';
                              end if;
                              decoded.operand1 <= source_reg_1;
                              decoded.operand2 <= IMM_Itype;
                              decoded.dstReg   <= Rd;
                              decoded.mem_en <= "1"; -- Memory op
                              decoded.mem_rw <= "0"; -- Load
                              decoded.mem_len <= Funct3(1 downto 0);
                              res_we := '1';

            when "0100011" => --printf("-> S-type\n"); -- Memory instructions
                              decoded.opcode <= opADD_SUB;
                              decoded.cin_sra <= "0";
                              decoded.operand1 <= source_reg_1;
                              decoded.operand2 <= IMM_Stype;
                              decoded.operand3 <= source_reg_2;
                              decoded.mem_en <= "1"; -- Memory op
                              decoded.mem_rw <= "1"; -- Write
                              decoded.mem_len <= Funct3(1 downto 0);
                              decoded.mem_se(0) <= Funct3(2);
                            
            when "1100011" => --printf("-> B-type\n"); -- Branch instructions
                              if (goBranch = "1") then
                                tmp := ProgramCounter + IMM_Btype;
                                ProgramCounter <= ProgramCounter + IMM_Btype;
                                --printf("Took the Branch to: " & integer'image(to_integer(tmp)) & "\n");
                              else
                                --printf("Did not take branch\n");
                              end if;
                            
            when "0110011" => --printf("-> R-type\n"); -- Register-to-Register instructions
                              decoded.opcode <= Funct7(0) & Funct3;
                              decoded.cin_sra <= Funct7(5 downto 5);
                              decoded.operand1 <= source_reg_1;
                              decoded.operand2 <= source_reg_2;
                              decoded.dstReg   <= Rd;
                              res_we := '1';
                              
            when "1101111" => --printf("-> J-type\n");
                              ProgramCounter <= ProgramCounter + IMM_Jtype;
                              tmp := ProgramCounter + IMM_Jtype;
                              if (Rd = 0) then
                                --printf("[I/D]: Jumped to: " & integer'image(to_integer(tmp)) & "\n");
                              else
                                decoded.opcode <= opADD_SUB;
                                decoded.cin_sra <= "0";
                                decoded.operand1 <= ProgramCounter + 4;
                                decoded.operand2 <= (others=>'0');
                                decoded.dstReg   <= Rd;                           
                              end if;

            when "1100111" => -- JALR type
                              ProgramCounter    <= source_reg_1 + IMM_Itype;
                              ProgramCounter(0) <= '0';
                              decoded.opcode    <= opADD_SUB;
                              decoded.cin_sra   <= "0";
                              decoded.operand1  <= ProgramCounter + 4;
                              decoded.operand2  <= (others=>'0');
                              decoded.dstReg    <= Rd;
                            
            when "0110111" => --printf("-> U-type\n");
                              decoded.opcode <= opADD_SUB;
                              decoded.cin_sra <= "0";
                              decoded.operand1 <= IMM_Utype;
                              decoded.operand2 <= (others=>'0');
                              decoded.dstReg   <= Rd;

            when "0010111" => decoded.opcode <= opADD_SUB;
                              decoded.cin_sra <= "0";
                              decoded.operand1 <= IMM_Utype;
                              decoded.operand2 <= ProgramCounter;
                              decoded.dstReg   <= Rd;

            when "1110011" => printf("EBREAK\n"); abort(0);
                              
            when others    => printf("Unknown instruciton " & integer'image(to_integer(Opc)) & "\n"); abort(0);
          end case;

        end if;
        
          -- Write to registerfile
        if (reg_we = '1') then
          RegisterFile(to_integer(reg_dst)) <= reg_val;
        end if;        

        
    end if;
    
  end process;
  
end;

