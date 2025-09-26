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
        datain:IN std_logic_vector(0 downto 0);
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

   SUBTYPE state_type IS INTEGER RANGE 0 TO 716;
   -- Reduced to a total of 717 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Extracted FIFO signals
   SUBTYPE fifo_type is std_logic_vector(0 downto 0);
   TYPE fifo_array is array (19 downto 1) of fifo_type;
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
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=3;
         ELSIF ((pres_state=3) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=4) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=5) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=6) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=7) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=8) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
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
            rd_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=14)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=15)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=16)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=17)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=18)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=19)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=20)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=21)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=22)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=23)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=24)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=25)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=26)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=27)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=28)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=29)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=30)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=31)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=32)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=33)) THEN 
            next_state<=0;
            result_bus_register(31 downto 0) <= FIFO_datain(19)(0 downto 0) & 
                  FIFO_datain(18)(0 downto 0) & 
                  FIFO_datain(17)(0 downto 0) & 
                  FIFO_datain(16)(0 downto 0) & 
                  FIFO_datain(15)(0 downto 0) & 
                  FIFO_datain(14)(0 downto 0) & 
                  FIFO_datain(13)(0 downto 0) & 
                  FIFO_datain(12)(0 downto 0) & 
                  FIFO_datain(11)(0 downto 0) & 
                  FIFO_datain(10)(0 downto 0) & 
                  FIFO_datain(9)(0 downto 0) & 
                  FIFO_datain(8)(0 downto 0) & 
                  FIFO_datain(7)(0 downto 0) & 
                  FIFO_datain(6)(0 downto 0) & 
                  FIFO_datain(5)(0 downto 0) & 
                  FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0) & 
                  std_logic_vector'("000000000000");
            rs_sel_register(1 downto 0) <= std_logic_vector'("00");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=6) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=34;
         ELSIF ((pres_state=34) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=35) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=36)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=37)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=38)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=39)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=40)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=41) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=42) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=43) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=44)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=45)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=46)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=47)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=48)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=49)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=50)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=51)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=52)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=53)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=54) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=55) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=56) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=57) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=58) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=59) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            wr_reg_register(0 downto 0) <= std_logic_vector'("1");
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=60) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            wr_reg_register(0 downto 0) <= std_logic_vector'("0");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=55) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=61;
         ELSIF ((pres_state=61) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=62) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=63) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=64) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            wr_reg_register(0 downto 0) <= std_logic_vector'("1");
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=65) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            wr_reg_register(0 downto 0) <= std_logic_vector'("0");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=43) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=66;
         ELSIF ((pres_state=66)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=67)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=68)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=69)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=70)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=71)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=72)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=73)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=74)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=75)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=76) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=77) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=78) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=79) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=80) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=81) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            wr_reg_register(0 downto 0) <= std_logic_vector'("1");
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=82) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            wr_reg_register(0 downto 0) <= std_logic_vector'("0");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=42) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=83;
         ELSIF ((pres_state=83) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=84)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=85)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=86)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=87)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=88)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=89)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=90)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=91)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=92)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=93)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=94) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=95) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=96) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=97) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=98) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=99) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=100) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=83) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=101;
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
         ELSIF ((pres_state=107)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=108)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=109)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=110)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=111) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=112) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=113) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=114) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=115) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=116) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=117) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=41) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=118;
         ELSIF ((pres_state=118) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=119) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=120)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=121)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=122)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=123)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=124)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=125)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=126)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=127)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=128)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=129)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=130) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=131) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=132) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=133) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=134) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=135) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=136) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=119) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=137;
         ELSIF ((pres_state=137)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=138)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=139)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=140)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=141)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=142)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=143)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=144)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=145)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=146)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=147) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=148) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=149) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=150) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=151) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=152) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=153) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=148) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=154;
         ELSIF ((pres_state=154) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=155) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=156) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=157) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=158) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=118) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=159;
         ELSIF ((pres_state=159) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=160)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=161)) THEN 
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
         ELSIF ((pres_state=169)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=170) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=171) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=172) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=173) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=174) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=175) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=176) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=159) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=177;
         ELSIF ((pres_state=177)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=178)) THEN 
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
         ELSIF ((pres_state=186)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=187) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=188) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=189) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=190) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=191) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=192) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=193) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=4) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=194;
         ELSIF ((pres_state=194) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=195) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=196) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=197) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
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
         ELSIF ((pres_state=203) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=204) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=205) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
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
         ELSIF ((pres_state=213)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=214)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=215)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=216)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=217)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=218)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=219)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=220)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=221)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=222)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=205) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=223;
         ELSIF ((pres_state=223)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=224)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=225)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=226)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=227)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=228)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=229)) THEN 
            next_state<=pres_state_plus_1;
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
         ELSIF ((pres_state=235)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=236)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=237)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=238)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=239)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=204) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=240;
         ELSIF ((pres_state=240) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=241)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=242)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=243)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=244)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=245)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=246)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=247)) THEN 
            next_state<=pres_state_plus_1;
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
         ELSIF ((pres_state=253)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=254)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=255)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=256)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=257)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=3) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=258;
         ELSIF ((pres_state=258) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=259) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=260) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=261) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=262) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=263)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=264)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=265)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=266)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=267)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
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
         ELSIF ((pres_state=276)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=277)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=278)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=279)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=280)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=281)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=282)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=283)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=284)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=285)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=286)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=287)) THEN 
            next_state<=0;
            op1_alt_register(31 downto 0) <= pc(31 downto 0);
            op2_alt_register(31 downto 0) <= FIFO_datain(19)(0 downto 0) & 
                  FIFO_datain(18)(0 downto 0) & 
                  FIFO_datain(17)(0 downto 0) & 
                  FIFO_datain(16)(0 downto 0) & 
                  FIFO_datain(15)(0 downto 0) & 
                  FIFO_datain(14)(0 downto 0) & 
                  FIFO_datain(13)(0 downto 0) & 
                  FIFO_datain(12)(0 downto 0) & 
                  FIFO_datain(11)(0 downto 0) & 
                  FIFO_datain(10)(0 downto 0) & 
                  FIFO_datain(9)(0 downto 0) & 
                  FIFO_datain(8)(0 downto 0) & 
                  FIFO_datain(7)(0 downto 0) & 
                  FIFO_datain(6)(0 downto 0) & 
                  FIFO_datain(5)(0 downto 0) & 
                  FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0) & 
                  std_logic_vector'("000000000000");
            rs_sel_register(1 downto 0) <= std_logic_vector'("11");
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=260) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=288;
         ELSIF ((pres_state=288) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=289) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=290)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=291)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=292)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=293)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=294)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=295) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=296) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=297) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=298)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=299)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=300)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=301)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=302)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=303)) THEN 
            next_state<=pres_state_plus_1;
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
         ELSIF ((pres_state=311)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=312)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=313)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=314)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=297) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=315;
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
         ELSIF ((pres_state=320)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=321)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=322)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=323)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=324)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=325) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=326) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=327) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=328) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=329) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=330) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=331) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=296) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=332;
         ELSIF ((pres_state=332) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=333)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=334)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=335)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=336)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=337)) THEN 
            next_state<=pres_state_plus_1;
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
         ELSIF ((pres_state=345)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=346)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=347)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=348)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=349)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=332) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=350;
         ELSIF ((pres_state=350)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=351)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=352)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=353)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=354)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=355)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=356)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=357)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=358)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=359)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=360)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=361)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=362)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=363)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=364)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=365)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=366)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=295) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=367;
         ELSIF ((pres_state=367) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=368) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=369)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=370)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=371)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=372)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=373)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=374)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=375)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=376)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=377)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=378)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=379)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=380)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=381)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=382)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=383)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=384)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=385)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=368) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=386;
         ELSIF ((pres_state=386)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=387)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=388)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=389)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=390)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=391)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=392)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=393)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=394)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=395)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=396) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=397) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=398) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=399) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=400) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=401) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=402) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=397) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=403;
         ELSIF ((pres_state=403) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=404) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=405) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=406) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=407) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=367) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=408;
         ELSIF ((pres_state=408) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=409)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=410)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=411)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=412)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=413)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=414)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=415)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=416)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=417)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=418)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=419)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=420)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=421)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=422)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=423)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=424)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=425)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=408) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=426;
         ELSIF ((pres_state=426)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=427)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=428)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=429)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=430)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=431)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=432)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=433)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=434)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=435)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=436)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=437)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=438)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=439)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=440)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=441)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=442)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=258) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=443;
         ELSIF ((pres_state=443) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=444) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=445) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=446) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=447)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=448)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=449)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=450)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=451)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=452) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=453) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=454) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=455)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=456)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=457)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=458)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=459)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=460)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=461)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=462)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=463)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=464)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=465)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=466)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=467)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=468)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=469)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=470)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=471)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=454) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=472;
         ELSIF ((pres_state=472)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=473)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=474)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=475)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=476)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=477)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=478)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=479)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=480)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=481)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=482)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=483)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=484)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=485)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=486)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=487)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=488)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=453) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=489;
         ELSIF ((pres_state=489) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=490)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=491)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=492)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=493)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=494)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=495)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=496)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=497)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=498)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=499)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=500)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=501)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=502)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=503)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=504)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=505)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=506)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=452) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=507;
         ELSIF ((pres_state=507) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=508) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=509)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=510)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=511)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=512)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=513)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=514)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=515)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=516)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=517)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=518)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=519)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=520)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=521)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=522)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=523)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=524)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=525)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=508) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=526;
         ELSIF ((pres_state=526)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=527)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=528)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=529)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=530)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=531)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=532)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=533)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=534)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=535)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=536)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=537)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=538)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=539)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=540)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=541)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=542)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=0) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=543;
         ELSIF ((pres_state=543) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=544) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=545) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=546) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=547) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=548) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=549)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=550)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=551)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=552)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=553)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=554)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=555)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=556)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=557)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=558)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=559)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=560)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=561)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=562)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=563)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=564)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=565)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=566)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=567)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=568)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=569)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=570)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=571)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=572)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=573)) THEN 
            next_state<=0;
            op1_alt_register(31 downto 0) <= pc(31 downto 0);
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=545) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=574;
         ELSIF ((pres_state=574) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=575) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=576) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=577)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=578)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=579)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=580)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=581)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=582) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=583) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=584) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=585)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=586)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=587)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=588)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=589)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=590)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=591)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=592)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=593)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=594)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=595)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=596)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=597)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=598)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=599)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=600)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=601)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=574) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=602;
         ELSIF ((pres_state=602) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=603) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=604)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=605)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=606)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=607)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=608)) THEN 
            next_state<=pres_state_plus_1;
            imm5_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=609) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=610) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=611) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=612)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=613)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=614)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=615)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=616)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=617)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=618)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=619)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=620)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=621)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= FIFO_datain(4)(0 downto 0) & 
                  FIFO_datain(3)(0 downto 0) & 
                  FIFO_datain(2)(0 downto 0) & 
                  FIFO_datain(1)(0 downto 0) & 
                  datain(0 downto 0);
         ELSIF ((pres_state=622)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=623)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=624)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=625)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=626)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=627)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=628)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=611) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=629;
         ELSIF ((pres_state=629)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=630)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=631)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=632)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=633)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=634)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=635)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=636)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=637)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=638)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=639)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=640)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=641)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=642)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=643)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=644)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=645)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=609) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=646;
         ELSIF ((pres_state=646) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=647) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=648)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=649)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=650)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=651)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=652)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=653)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=654)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=655)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=656)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=657)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=658)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=659)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=660)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=661)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=662)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=663)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=664)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=647) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=665;
         ELSIF ((pres_state=665)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=666)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=667)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=668)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=669)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=670)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=671)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=672)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=673)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=674)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=675)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=676)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=677)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=678)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=679)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=680)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=681)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=646) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=682;
         ELSIF ((pres_state=682) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=683)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=684)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=685)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=686)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=687)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=688)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=689)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=690)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=691)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=692)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=693)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=694)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=695)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=696)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=697)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=698)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=699)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=682) AND
                (datain(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=700;
         ELSIF ((pres_state=700)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=701)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=702)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=703)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=704)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=705)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=706)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=707)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=708)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=709)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=710)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=711)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=712)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=713)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=714)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=715)) THEN 
            next_state<=pres_state_plus_1;
            go_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=716)) THEN 
            next_state<=0;
            go_register(1 downto 0) <= std_logic_vector'("00");
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   FIFO_0:
      -- Extracted FIFO with 19 stages of 1 bits
      PROCESS(clk)
      BEGIN
         IF clk'event AND (clk='1') THEN
            FOR i IN 19 downto 2 LOOP
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
         if (pres_state<716) then
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
        datain:IN std_logic_vector(0 downto 0);
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
        datain:IN std_logic_vector(0 downto 0);
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
