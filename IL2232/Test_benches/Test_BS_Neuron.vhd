-- VHDL extracted from PROGRAM file D:\Desktop\NoC_SafePower\Examples\ProGram_Compiler\Test_BS_Neuron
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY test_Neuron_0 IS
   PORT(clk:IN std_logic;
        Input:OUT std_logic_vector(0 downto 0);
        res:IN std_logic_vector(0 downto 0));
END test_Neuron_0;

ARCHITECTURE program OF test_Neuron_0 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 16;
   -- Reduced to a total of 17 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Internal registers
   SIGNAL Input_register: std_logic_vector(0 downto 0);
   SIGNAL Input_internal: std_logic_vector(0 downto 0);
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol test_Neuron
      PROCESS (pres_state, pres_state_plus_1,
               Input_internal,
               res)
      BEGIN
         Input_register<=Input_internal;
         next_state<=pres_state;
         IF ((pres_state=0) AND
                (res(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=1)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=2)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=3)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=4)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=5)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=8)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=9)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=10)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=11)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=12)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=13)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=14)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=15)) THEN 
            next_state<=pres_state_plus_1;
            Input_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=16) AND
                (res(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=16;
         ELSIF ((pres_state=16) AND
                (res(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=0;
         ELSIF ((pres_state=0) AND
                (res(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=0;
            Input_register(0 downto 0) <= std_logic_vector'("0");
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
            Input_internal<=Input_register;
         END IF;
      END PROCESS;
      Input<=Input_internal;
      process(pres_state)
      begin
         if (pres_state<16) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY test_result_1 IS
   PORT(clk:IN std_logic;
        Output:OUT std_logic_vector(15 downto 0);
        q:IN std_logic_vector(0 downto 0);
        res:IN std_logic_vector(0 downto 0));
END test_result_1;

ARCHITECTURE program OF test_result_1 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 54;
   -- Reduced to a total of 55 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Extracted FIFO signals
   SUBTYPE fifo_type is std_logic_vector(0 downto 0);
   TYPE fifo_array is array (15 downto 1) of fifo_type;
   SIGNAL FIFO_q:fifo_array;

   -- Internal registers
   SIGNAL Output_register: std_logic_vector(15 downto 0);
   SIGNAL Output_internal: std_logic_vector(15 downto 0);
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol test_result
      PROCESS (pres_state, pres_state_plus_1,
               Output_internal,
               q,
               res,
               FIFO_q)
      BEGIN
         Output_register<=Output_internal;
         next_state<=pres_state;
         IF ((pres_state=0) AND
                (res(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=1)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=2)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=3)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=4)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=5)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
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
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=34)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=35)) THEN 
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
         ELSIF ((pres_state=41)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=42)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=43)) THEN 
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
            Output_register(15 downto 0) <= q(0 downto 0) & 
                  FIFO_q(1)(0 downto 0) & 
                  FIFO_q(2)(0 downto 0) & 
                  FIFO_q(3)(0 downto 0) & 
                  FIFO_q(4)(0 downto 0) & 
                  FIFO_q(5)(0 downto 0) & 
                  FIFO_q(6)(0 downto 0) & 
                  FIFO_q(7)(0 downto 0) & 
                  FIFO_q(8)(0 downto 0) & 
                  FIFO_q(9)(0 downto 0) & 
                  FIFO_q(10)(0 downto 0) & 
                  FIFO_q(11)(0 downto 0) & 
                  FIFO_q(12)(0 downto 0) & 
                  FIFO_q(13)(0 downto 0) & 
                  FIFO_q(14)(0 downto 0) & 
                  FIFO_q(15)(0 downto 0);
         ELSIF ((pres_state=54) AND
                (res(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=54;
         ELSIF ((pres_state=54) AND
                (res(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=0;
         ELSIF ((pres_state=0) AND
                (res(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=0;
            Output_register(15 downto 0) <= std_logic_vector'("0000000000000000");
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   FIFO_0:
      -- Extracted FIFO with 15 stages of 1 bits
      PROCESS(clk)
      BEGIN
         IF clk'event AND (clk='1') THEN
            FOR i IN 15 downto 2 LOOP
                  FIFO_q(i)<=FIFO_q(i-1);
            END LOOP;
            FIFO_q(1)<=q;
         END IF;
      END PROCESS;
   REGISTERS:
      -- Output and State Registers
      PROCESS(clk)
      BEGIN
         IF rising_edge(clk) THEN
            pres_state<=next_state;
            Output_internal<=Output_register;
         END IF;
      END PROCESS;
      Output<=Output_internal;
      process(pres_state)
      begin
         if (pres_state<54) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY test_reset_2 IS
   PORT(clk:IN std_logic;
        res:OUT std_logic_vector(0 downto 0));
END test_reset_2;

ARCHITECTURE program OF test_reset_2 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 68;
   -- Reduced to a total of 69 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Internal registers
   SIGNAL res_register: std_logic_vector(0 downto 0);
   SIGNAL res_internal: std_logic_vector(0 downto 0);
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol test_reset
      PROCESS (pres_state, pres_state_plus_1,
               clk,
               res_internal)
      BEGIN
         res_register<=res_internal;
         next_state<=pres_state;
         IF ((pres_state=0)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=1)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=2)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=3)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=4)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=5)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=8)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=9)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=10)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=11)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=12)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=13)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=14)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=15)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=16)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=17)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=18)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=19)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=20)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=21)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=22)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=23)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=24)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=25)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=26)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=27)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=28)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=29)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=30)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=31)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=32)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=33)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=34)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=35)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=36)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=37)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=38)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=39)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=40)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=41)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=42)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=43)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=44)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=45)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=46)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=47)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=48)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=49)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=50)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=51)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=52)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=53)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=54)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=55)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=56)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=57)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=58)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=59)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=60)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=61)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=62)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=63)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=64)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=65)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=66)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=67)) THEN 
            next_state<=pres_state_plus_1;
            res_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=68)) THEN 
            next_state<=0;
            res_register(0 downto 0) <= std_logic_vector'("0");
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
            res_internal<=res_register;
         END IF;
      END PROCESS;
      res<=res_internal;
      process(pres_state)
      begin
         if (pres_state<68) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

-- Included Use clauses
use work.BS_Neuron_package.all;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY Test_BS_Neuron IS
END Test_BS_Neuron;

ARCHITECTURE program OF Test_BS_Neuron IS


   COMPONENT test_Neuron_0
      PORT(clk:IN std_logic;
        Input:OUT std_logic_vector(0 downto 0);
        res:IN std_logic_vector(0 downto 0));
   END COMPONENT;
   COMPONENT test_result_1
      PORT(clk:IN std_logic;
        Output:OUT std_logic_vector(15 downto 0);
        q:IN std_logic_vector(0 downto 0);
        res:IN std_logic_vector(0 downto 0));
   END COMPONENT;
   COMPONENT test_reset_2
      PORT(clk:IN std_logic;
        res:OUT std_logic_vector(0 downto 0));
   END COMPONENT;
   SIGNAL Input: std_logic_vector(0 downto 0);
   SIGNAL Output: std_logic_vector(15 downto 0);
   SIGNAL q: std_logic_vector(0 downto 0);
   SIGNAL clk: std_logic_vector(0 downto 0);
   SIGNAL ares: std_logic_vector(0 downto 0);
   SIGNAL res: std_logic_vector(0 downto 0);
   -- Included VHDL signals
   component BS_Neuron
   generic(N:integer:=8);
   port(clk,ares,reset:In std_logic;
        Input:IN std_logic_vector(N-1 downto 0);
        weight:IN Neuron_weight_vector(N-1 downto 0);
        q:out std_logic);
   end component;
   constant weight:Neuron_Weight_vector:=(("00000001"),
                                          ("00000010"),
                                          ("00000100"),
                                          ("00001000"),
                                          ("00010000"),
                                          ("00100000"),
                                          ("01000000"),
                                          ("00000100"));
   function sum(A:Neuron_weight_vector) return integer is
      variable tmp,tmp_sum:integer:=0;
   begin
      for i in A'range loop
	 tmp_sum:=ieee.std_logic_arith.conv_integer(signed(A(i)));
         tmp:=tmp+tmp_sum;
      end loop;
      return tmp;
   end sum;
   signal Input_vector:std_logic_vector(7 downto 0);
   signal muladd,mul1,mul2,add1,exp,minmax:integer;

BEGIN
   -- Included Top Architecture Code
DUT: BS_Neuron port map(clk(0),ares(0),res(0),Input_vector,weight, q(0));
   process
   begin
      clk<="0";
      wait for 5 ns;
      clk<="1";
      wait for 5 ns;
   end process;
   ares(0)<='1', '0' after 16 ns;
   Input_vector<=(others=>Input(0));
   Muladd<=sum(weight);
   minmax<=0 when muladd<0 else muladd;
   mul1<=-muladd*7222;
   mul2<=muladd*mul1;
   add1<=32011+mul2;
   exp<=muladd*add1;

   U0:test_Neuron_0 
      PORT MAP(clk(0),
               Input,
               res);
   U1:test_result_1 
      PORT MAP(clk(0),
               Output,
               q,
               res);
   U2:test_reset_2 
      PORT MAP(clk(0),
               res);
END program;
