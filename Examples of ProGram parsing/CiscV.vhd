-- VHDL extracted from PROGRAM file D:\Desktop\NoC_SafePower\Examples\RiscV\CiscV
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY CiscV_0 IS
   PORT(clk:IN std_logic;
        sreset:IN std_logic_vector(0 downto 0);
        datain:IN std_logic_vector(1 downto 0);
        rd_data:OUT std_logic_vector(4 downto 0);
        rs1_data:OUT std_logic_vector(4 downto 0);
        rs2_data:OUT std_logic_vector(4 downto 0);
        rs_sel:OUT std_logic_vector(1 downto 0);
        result_bus:OUT std_logic_vector(31 downto 0);
        op1_alt:OUT std_logic_vector(31 downto 0);
        op2_alt:OUT std_logic_vector(31 downto 0);
        imm5_data:OUT std_logic_vector(4 downto 0);
        wr_reg:OUT std_logic_vector(0 downto 0);
        go:OUT std_logic_vector(1 downto 0);
        alu_ctrl:OUT std_logic_vector(2 downto 0);
        pc:IN std_logic_vector(31 downto 0));
END CiscV_0;

ARCHITECTURE program OF CiscV_0 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 345;
   -- Reduced to a total of 346 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Extracted FIFO signals
   SUBTYPE fifo_type is std_logic_vector(1 downto 0);
   TYPE fifo_array is array (18 downto 1) of fifo_type;
   SIGNAL FIFO_datain:fifo_array;

   -- Output registers

   -- Internal registers
   SIGNAL rd_data_register: std_logic_vector(4 downto 0);
   SIGNAL rd_data_internal: std_logic_vector(4 downto 0);
   SIGNAL rs1_data_register: std_logic_vector(4 downto 0);
   SIGNAL rs1_data_internal: std_logic_vector(4 downto 0);
   SIGNAL rs2_data_register: std_logic_vector(4 downto 0);
   SIGNAL rs2_data_internal: std_logic_vector(4 downto 0);
   SIGNAL rs_sel_register: std_logic_vector(1 downto 0);
   SIGNAL rs_sel_internal: std_logic_vector(1 downto 0);
   SIGNAL result_bus_register: std_logic_vector(31 downto 0);
   SIGNAL result_bus_internal: std_logic_vector(31 downto 0);
   SIGNAL op1_alt_register: std_logic_vector(31 downto 0);
   SIGNAL op1_alt_internal: std_logic_vector(31 downto 0);
   SIGNAL op2_alt_register: std_logic_vector(31 downto 0);
   SIGNAL op2_alt_internal: std_logic_vector(31 downto 0);
   SIGNAL imm5_data_register: std_logic_vector(4 downto 0);
   SIGNAL imm5_data_internal: std_logic_vector(4 downto 0);
   SIGNAL wr_reg_register: std_logic_vector(0 downto 0);
   SIGNAL wr_reg_internal: std_logic_vector(0 downto 0);
   SIGNAL go_register: std_logic_vector(1 downto 0);
   SIGNAL go_internal: std_logic_vector(1 downto 0);
   SIGNAL alu_ctrl_register: std_logic_vector(2 downto 0);
   SIGNAL alu_ctrl_internal: std_logic_vector(2 downto 0);
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol CiscV
      PROCESS (pres_state, pres_state_plus_1,
               sreset,
               datain,
               rd_data_internal,
               rs1_data_internal,
               rs2_data_internal,
               rs_sel_internal,
               result_bus_internal,
               op1_alt_internal,
               op2_alt_internal,
               imm5_data_internal,
               wr_reg_internal,
               go_internal,
               alu_ctrl_internal,
               pc,
               FIFO_datain)
      BEGIN
         rd_data_register<=rd_data_internal;
         rs1_data_register<=rs1_data_internal;
         rs2_data_register<=rs2_data_internal;
         rs_sel_register<=rs_sel_internal;
         result_bus_register<=result_bus_internal;
         op1_alt_register<=op1_alt_internal;
         op2_alt_register<=op2_alt_internal;
         imm5_data_register<=imm5_data_internal;
         wr_reg_register<=wr_reg_internal;
         go_register<=go_internal;
         alu_ctrl_register<=alu_ctrl_internal;
         next_state<=pres_state;
         IF (sreset=std_logic_vector'("1")) THEN -- RESET STATE
            next_state<=1;
         ELSIF ((pres_state=1) AND
                (sreset(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=-1;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=1) AND
                (sreset(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=2) AND
                (sreset(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=0) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=3;
         ELSIF ((pres_state=3) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=4) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=5) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=8)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=9)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=10)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=11)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=12)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=13)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=14)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=15)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=16)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=17)) THEN 
            next_state<=0;
            result_bus_register(31 downto 0) <= FIFO_datain(9)(1 downto 0) & 
                  FIFO_datain(8)(1 downto 0) & 
                  FIFO_datain(7)(1 downto 0) & 
                  FIFO_datain(6)(1 downto 0) & 
                  FIFO_datain(5)(1 downto 0) & 
                  FIFO_datain(4)(1 downto 0) & 
                  FIFO_datain(3)(1 downto 0) & 
                  FIFO_datain(2)(1 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0) & 
                  std_logic_vector'("000000000000");
            rs_sel_register(1 downto 0) <= std_logic_vector'("00");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=4) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=18;
         ELSIF ((pres_state=18) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=19)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=20)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=21) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=22) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=23)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=24)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=25)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=26)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=27) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0) & 
                  datain(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=28) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=29) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            wr_reg_register(0 downto 0) <= std_logic_vector'("1");
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=30) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            wr_reg_register(0 downto 0) <= std_logic_vector'("0");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=28) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=31;
         ELSIF ((pres_state=31) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            wr_reg_register(0 downto 0) <= std_logic_vector'("1");
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=32) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            wr_reg_register(0 downto 0) <= std_logic_vector'("0");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=22) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=33;
         ELSIF ((pres_state=33)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=34)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=35)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=36)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=37) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0) & 
                  datain(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=38) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=39) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            wr_reg_register(0 downto 0) <= std_logic_vector'("1");
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=40) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            wr_reg_register(0 downto 0) <= std_logic_vector'("0");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=21) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=41;
         ELSIF ((pres_state=41) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=42)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=43)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=44)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=45)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=46) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=47) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=48) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=49) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=41) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=50;
         ELSIF ((pres_state=50)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=51)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=52)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=53)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=54) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=55) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=56) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=57) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=21) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=58;
         ELSIF ((pres_state=58) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=59)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=60)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=61)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=62)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=63) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=64) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=65) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=66) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=58) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=67;
         ELSIF ((pres_state=67)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=68)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=69)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=70)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=71) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=72) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=73) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=74) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=72) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=75;
         ELSIF ((pres_state=75) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=76) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=21) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=77;
         ELSIF ((pres_state=77) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=78)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=79)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=80)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=81)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=82) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=83) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=84) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=85) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=77) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=86;
         ELSIF ((pres_state=86)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=87)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=88)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=89)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=90) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=91) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=92) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=93) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=3) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=94;
         ELSIF ((pres_state=94) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=95) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=96)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=97)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=98) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=99) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=100)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=101)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=102)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=103)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=104)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=105)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=106)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=107)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=99) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=108;
         ELSIF ((pres_state=108)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=109)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=110)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=111)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=112)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=113)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=114)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=115)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=98) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=116;
         ELSIF ((pres_state=116) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=117)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=118)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=119)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=120)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=121)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=122)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=123)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=124)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=0) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=125;
         ELSIF ((pres_state=125) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=126) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=127) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=128)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=129)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=130)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=131)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=132)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=133)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=134)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=135)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=136)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=137)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=138)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=139)) THEN 
            next_state<=0;
            op1_alt_register(31 downto 0) <= pc(31 downto 0);
            op2_alt_register(31 downto 0) <= FIFO_datain(9)(1 downto 0) & 
                  FIFO_datain(8)(1 downto 0) & 
                  FIFO_datain(7)(1 downto 0) & 
                  FIFO_datain(6)(1 downto 0) & 
                  FIFO_datain(5)(1 downto 0) & 
                  FIFO_datain(4)(1 downto 0) & 
                  FIFO_datain(3)(1 downto 0) & 
                  FIFO_datain(2)(1 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0) & 
                  std_logic_vector'("000000000000");
            rs_sel_register(1 downto 0) <= std_logic_vector'("11");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=126) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=140;
         ELSIF ((pres_state=140) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=141)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=142)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=143) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=144) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=145)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=146)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=147)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=148)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=149)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=150)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=151)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=152)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=144) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=153;
         ELSIF ((pres_state=153)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=154)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=155)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=156)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=157) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=158) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=159) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=160) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=143) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=161;
         ELSIF ((pres_state=161) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=162)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=163)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=164)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=165)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=166)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=167)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=168)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=169)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=161) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=170;
         ELSIF ((pres_state=170)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=171)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=172)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=173)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=174)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=175)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=176)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=177)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=143) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=178;
         ELSIF ((pres_state=178) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=179)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=180)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=181)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=182)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=183)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=184)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=185)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=186)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=178) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=187;
         ELSIF ((pres_state=187)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=188)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=189)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=190)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=191) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=192) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=193) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=194) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=192) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=195;
         ELSIF ((pres_state=195) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=196) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=143) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=197;
         ELSIF ((pres_state=197) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=198)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=199)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=200)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=201)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=202)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=203)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=204)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=205)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=197) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=206;
         ELSIF ((pres_state=206)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=207)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=208)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=209)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=210)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=211)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=212)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=213)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=125) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=214;
         ELSIF ((pres_state=214) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=215) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=216)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=217)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=218) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=219) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=220)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=221)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=222)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=223)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=224)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=225)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=226)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=227)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=219) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=228;
         ELSIF ((pres_state=228)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=229)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=230)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=231)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=232)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=233)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=234)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=235)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=218) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=236;
         ELSIF ((pres_state=236) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=237)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=238)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=239)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=240)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=241)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=242)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=243)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=244)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=218) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=245;
         ELSIF ((pres_state=245) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=246)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=247)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=248)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=249)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=250)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=251)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=252)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=253)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=245) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=254;
         ELSIF ((pres_state=254)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=255)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=256)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=257)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=258)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=259)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=260)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=261)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=0) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=262;
         ELSIF ((pres_state=262) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=263) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=264) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=265)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=266)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=267)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=268)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=269)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=270)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=271)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=272)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=273)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=274)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=275)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=276)) THEN 
            next_state<=0;
            op1_alt_register(31 downto 0) <= pc(31 downto 0);
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=262) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=277;
         ELSIF ((pres_state=277) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=278) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=279)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=280)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=281) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=282) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=283)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=284)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=285)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=286)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=287)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=288)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=289)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=290)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=277) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=291;
         ELSIF ((pres_state=291) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=292)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=293)) THEN 
            next_state<=pres_state_plus_1;
            imm5_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=294) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=295) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=296)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=297)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0);
         ELSIF ((pres_state=298)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=299)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=300)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= FIFO_datain(1)(1 downto 0) & 
                  datain(1 downto 0) & 
                  datain(1 downto 1);
         ELSIF ((pres_state=301)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=302)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=303)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=295) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=304;
         ELSIF ((pres_state=304)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=305)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=306)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=307)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=308)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=309)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=310)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=311)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=294) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=312;
         ELSIF ((pres_state=312) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=313)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=314)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=315)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=316)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=317)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=318)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=319)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=320)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=312) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=321;
         ELSIF ((pres_state=321)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=322)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=323)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=324)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=325)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=326)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=327)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=328)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=294) AND
                (datain(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=329;
         ELSIF ((pres_state=329) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=330)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=331)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=332)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=333)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=334)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=335)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=336)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=337)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=329) AND
                (datain(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=338;
         ELSIF ((pres_state=338)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=339)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=340)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=341)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=342)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=343)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=344)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=345)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   FIFO_0:
      -- Extracted FIFO with 18 stages of 2 bits
      PROCESS(clk)
      BEGIN
         IF clk'event AND (clk='1') THEN
            FOR i IN 18 downto 2 LOOP
                  FIFO_datain(i)<=FIFO_datain(i-1);
            END LOOP;
            FIFO_datain(1)<=datain;
         END IF;
      END PROCESS;
   REGISTERS:
      -- Output and State Registers
      PROCESS(clk)
      BEGIN
         IF rising_edge(clk) THEN
            pres_state<=next_state;
            rd_data_internal<=rd_data_register;
            rs1_data_internal<=rs1_data_register;
            rs2_data_internal<=rs2_data_register;
            rs_sel_internal<=rs_sel_register;
            result_bus_internal<=result_bus_register;
            op1_alt_internal<=op1_alt_register;
            op2_alt_internal<=op2_alt_register;
            imm5_data_internal<=imm5_data_register;
            wr_reg_internal<=wr_reg_register;
            go_internal<=go_register;
            alu_ctrl_internal<=alu_ctrl_register;
         END IF;
      END PROCESS;
      rd_data<=rd_data_internal;
      rs1_data<=rs1_data_internal;
      rs2_data<=rs2_data_internal;
      rs_sel<=rs_sel_internal;
      result_bus<=result_bus_internal;
      op1_alt<=op1_alt_internal;
      op2_alt<=op2_alt_internal;
      imm5_data<=imm5_data_internal;
      wr_reg<=wr_reg_internal;
      go<=go_internal;
      alu_ctrl<=alu_ctrl_internal;
      process(pres_state)
      begin
         if (pres_state<345) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY DataFetch_1 IS
   PORT(clk:IN std_logic;
        next_instr_address:IN std_logic_vector(7 downto 0);
        next_data_address:IN std_logic_vector(7 downto 0);
        go:IN std_logic_vector(1 downto 0);
        address:OUT std_logic_vector(0 downto 0);
        first_bit:OUT std_logic_vector(0 downto 0);
        data_instr:OUT std_logic_vector(0 downto 0));
END DataFetch_1;

ARCHITECTURE program OF DataFetch_1 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 32;
   -- Reduced to a total of 33 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Output registers
   SIGNAL address_register: std_logic_vector(0 downto 0);
   SIGNAL address_internal: std_logic_vector(0 downto 0);
   SIGNAL first_bit_register: std_logic_vector(0 downto 0);
   SIGNAL first_bit_internal: std_logic_vector(0 downto 0);
   SIGNAL data_instr_register: std_logic_vector(0 downto 0);
   SIGNAL data_instr_internal: std_logic_vector(0 downto 0);

   -- Internal registers
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol DataFetch
      PROCESS (pres_state, pres_state_plus_1,
               next_instr_address,
               next_data_address,
               go,
               address_internal,
               first_bit_internal,
               data_instr_internal)
      BEGIN
         address_register<=address_internal;
         first_bit_register<=first_bit_internal;
         data_instr_register<=data_instr_internal;
         next_state<=pres_state;
         IF ((pres_state=0) AND
                (go(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=1)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("1");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=2)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=3)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=4)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=5)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=8)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=9)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(7 downto 7);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=10)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(6 downto 6);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=11)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(5 downto 5);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=12)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(4 downto 4);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=13)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(3 downto 3);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=14)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(2 downto 2);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=15)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_data_address(1 downto 1);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=16)) THEN 
            next_state<=0;
            address_register(0 downto 0) <= next_data_address(0 downto 0);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=0) AND
                (go(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=17;
         ELSIF ((pres_state=17)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("1");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=18)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=19)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=20)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=21)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=22)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=23)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=24)) THEN 
            next_state<=pres_state_plus_1;
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=25)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(7 downto 7);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=26)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(6 downto 6);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=27)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(5 downto 5);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=28)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(4 downto 4);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=29)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(3 downto 3);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=30)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(2 downto 2);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=31)) THEN 
            next_state<=pres_state_plus_1;
            address_register(0 downto 0) <= next_instr_address(1 downto 1);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=32)) THEN 
            next_state<=0;
            address_register(0 downto 0) <= next_instr_address(0 downto 0);
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=0) AND
                (go(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            address_register(0 downto 0) <= std_logic_vector'("0");
            first_bit_register(0 downto 0) <= std_logic_vector'("0");
            data_instr_register(0 downto 0) <= std_logic_vector'("0");
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   REGISTERS:
      -- Output and State Registers
      PROCESS(clk)
      BEGIN
         IF rising_edge(clk) THEN
            pres_state<=next_state;
            address_internal<=address_register;
            first_bit_internal<=first_bit_register;
            data_instr_internal<=data_instr_register;
         END IF;
      END PROCESS;
      address<=address_internal;
      first_bit<=first_bit_internal;
      data_instr<=data_instr_internal;
      process(pres_state)
      begin
         if (pres_state<32) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY CiscV IS
   PORT(clk:IN std_logic;
        sreset:IN std_logic_vector(0 downto 0);
        datain:IN std_logic_vector(1 downto 0);
        address:OUT std_logic_vector(0 downto 0);
        read:OUT std_logic_vector(0 downto 0);
        write:OUT std_logic_vector(0 downto 0);
        dataout:OUT std_logic_vector(0 downto 0);
        first_bit:OUT std_logic_vector(0 downto 0);
        data_instr:OUT std_logic_vector(0 downto 0));
END CiscV;

ARCHITECTURE program OF CiscV IS


   COMPONENT CiscV_0
      PORT(clk:IN std_logic;
        sreset:IN std_logic_vector(0 downto 0);
        datain:IN std_logic_vector(1 downto 0);
        rd_data:OUT std_logic_vector(4 downto 0);
        rs1_data:OUT std_logic_vector(4 downto 0);
        rs2_data:OUT std_logic_vector(4 downto 0);
        rs_sel:OUT std_logic_vector(1 downto 0);
        result_bus:OUT std_logic_vector(31 downto 0);
        op1_alt:OUT std_logic_vector(31 downto 0);
        op2_alt:OUT std_logic_vector(31 downto 0);
        imm5_data:OUT std_logic_vector(4 downto 0);
        wr_reg:OUT std_logic_vector(0 downto 0);
        go:OUT std_logic_vector(1 downto 0);
        alu_ctrl:OUT std_logic_vector(2 downto 0);
        pc:IN std_logic_vector(31 downto 0));
   END COMPONENT;
   COMPONENT DataFetch_1
      PORT(clk:IN std_logic;
        next_instr_address:IN std_logic_vector(7 downto 0);
        next_data_address:IN std_logic_vector(7 downto 0);
        go:IN std_logic_vector(1 downto 0);
        address:OUT std_logic_vector(0 downto 0);
        first_bit:OUT std_logic_vector(0 downto 0);
        data_instr:OUT std_logic_vector(0 downto 0));
   END COMPONENT;
   SIGNAL rd_data: std_logic_vector(4 downto 0);
   SIGNAL rs1_data: std_logic_vector(4 downto 0);
   SIGNAL rs2_data: std_logic_vector(4 downto 0);
   SIGNAL rs_sel: std_logic_vector(1 downto 0);
   SIGNAL result_bus: std_logic_vector(31 downto 0);
   SIGNAL op1_bus: std_logic_vector(31 downto 0);
   SIGNAL op1_alt: std_logic_vector(31 downto 0);
   SIGNAL op2_bus: std_logic_vector(31 downto 0);
   SIGNAL op2_alt: std_logic_vector(31 downto 0);
   SIGNAL imm5_data: std_logic_vector(4 downto 0);
   SIGNAL wr_reg: std_logic_vector(0 downto 0);
   SIGNAL next_instr_address: std_logic_vector(7 downto 0);
   SIGNAL next_data_address: std_logic_vector(7 downto 0);
   SIGNAL go: std_logic_vector(1 downto 0);
   SIGNAL result: std_logic_vector(31 downto 0);
   SIGNAL alu_ctrl: std_logic_vector(2 downto 0);
   SIGNAL pc: std_logic_vector(31 downto 0);
   -- Included VHDL signals
   type memory_array_type is array (natural range <>) of std_logic_vector(31 downto 0);
   signal regs:memory_array_type(31 downto 0);

BEGIN
   -- Included Top Architecture Code
   process(clk)
   begin
      if rising_edge(clk) then
	     case alu_ctrl is 
		    when "000" =>
			   result_bus<=op1_bus + op2_bus;
			when "001" =>
			   result_bus<=SLL(op1_bus); -- op2_bus
			when others =>
	           result_bus <= "00000000000000000000000000000000";
		end case;
	  end if;
   end process;
   process(CLK)
   begin             
	  if rising_edge(clk) then	
		if (rs_sel(0)='0') then
		    op1_bus<=regs(conv_integer(rs1_data));
	    else
		   op1_bus<=op1_alt;
		end if;
        if (rs_sel(1)='0') then
		    op2_bus<=regs(conv_integer(rs2_data));
		else
		    op2_bus<=op2_alt;
		end if;
		if (wr_reg="1") then
		   regs(conv_integer(rd_data))<=result_bus;
		end if;
	  end if;
   end process;

   U0:CiscV_0 
      PORT MAP(clk,
               sreset,
               datain,
               rd_data,
               rs1_data,
               rs2_data,
               rs_sel,
               result_bus,
               op1_alt,
               op2_alt,
               imm5_data,
               wr_reg,
               go,
               alu_ctrl,
               pc);
   U1:DataFetch_1 
      PORT MAP(clk,
               next_instr_address,
               next_data_address,
               go,
               address,
               first_bit,
               data_instr);
END program;
