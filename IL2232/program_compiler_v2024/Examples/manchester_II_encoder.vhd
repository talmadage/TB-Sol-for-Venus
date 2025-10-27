-- VHDL extracted from PROGRAM file manchester_II_encoder.yuk
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
-- LIBRARY SYNT;
-- USE SYNT.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY encode_0 IS
   PORT(clk:IN std_logic;
        enable:IN std_logic_vector(0 downto 0);
        inp:IN std_logic_vector(0 downto 0);
        q:OUT std_logic_vector(0 downto 0));
END encode_0;

ARCHITECTURE program OF encode_0 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 4;
   -- Reduced to a total of 5 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Output registers
   SIGNAL q_register: std_logic_vector(0 downto 0);
   SIGNAL q_internal: std_logic_vector(0 downto 0);

   -- Internal registers
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol encode
      PROCESS (pres_state, pres_state_plus_1,
               enable,
               inp,
               q_internal)
      BEGIN
         q_register<=q_internal;
         next_state<=pres_state;
         IF ((pres_state=0) AND
                (inp(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=1) AND
                (inp(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("1");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("0");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
         ELSIF ((pres_state=1) AND
                (inp(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("1");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
         ELSIF ((pres_state=2)) THEN 
            next_state<=0;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("0");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("0");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
         ELSIF ((pres_state=0) AND
                (inp(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=3;
         ELSIF ((pres_state=3) AND
                (inp(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=0;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("0");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("1");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
         ELSIF ((pres_state=3) AND
                (inp(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("0");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
         ELSIF ((pres_state=4)) THEN 
            next_state<=0;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("1");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
            IF (equ(enable(0 downto 0),std_logic_vector'("0"))) THEN
               q_register(0 downto 0) <= std_logic_vector'("0");
            ELSE
               q_register(0 downto 0) <= std_logic_vector'("0");
            END IF;
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   REGISTERS:
      -- Output and State Registers
      PROCESS(clk)
      BEGIN
         IF (clk'event AND (clk='1')) THEN
            pres_state<=next_state;
            q_internal<=q_register;
         END IF;
      END PROCESS;
      q<=q_internal;
      process(pres_state)
      begin
         if (pres_state<4) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
-- LIBRARY SYNT;
-- USE SYNT.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY parallel2serial_1 IS
   PORT(clk:IN std_logic;
        Din:IN std_logic_vector(7 downto 0);
        DataReady:IN std_logic_vector(0 downto 0);
        a:INOUT std_logic_vector(7 downto 0);
        inp:OUT std_logic_vector(0 downto 0);
        Ready2Send:OUT std_logic_vector(0 downto 0));
END parallel2serial_1;

ARCHITECTURE program OF parallel2serial_1 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 8;
   -- Reduced to a total of 9 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Output registers
   SIGNAL Ready2Send_register: std_logic_vector(0 downto 0);
   SIGNAL Ready2Send_internal: std_logic_vector(0 downto 0);

   -- Internal registers
   SIGNAL a_register: std_logic_vector(7 downto 0);
   SIGNAL a_internal: std_logic_vector(7 downto 0);
   SIGNAL inp_register: std_logic_vector(0 downto 0);
   SIGNAL inp_internal: std_logic_vector(0 downto 0);
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol parallel2serial
      PROCESS (pres_state, pres_state_plus_1,
               Din,
               DataReady,
               a_internal,
               inp_internal,
               Ready2Send_internal)
      BEGIN
         a_register<=a_internal;
         inp_register<=inp_internal;
         Ready2Send_register<=Ready2Send_internal;
         next_state<=pres_state;
         IF ((pres_state=0) AND
                (DataReady(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            a_register(7 downto 0) <= Din(7 downto 0);
            Ready2Send_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=1)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(7 downto 7);
         ELSIF ((pres_state=2)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(6 downto 6);
         ELSIF ((pres_state=3)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(5 downto 5);
         ELSIF ((pres_state=4)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(4 downto 4);
         ELSIF ((pres_state=5)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(3 downto 3);
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(2 downto 2);
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
            inp_register(0 downto 0) <= a_internal(1 downto 1);
         ELSIF ((pres_state=8)) THEN 
            next_state<=0;
            inp_register(0 downto 0) <= a_internal(0 downto 0);
            Ready2Send_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=0) AND
                (DataReady(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            Ready2Send_register(0 downto 0) <= std_logic_vector'("1");
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   REGISTERS:
      -- Output and State Registers
      PROCESS(clk)
      BEGIN
         IF (clk'event AND (clk='1')) THEN
            pres_state<=next_state;
            Ready2Send_internal<=Ready2Send_register;
            a_internal<=a_register;
            inp_internal<=inp_register;
         END IF;
      END PROCESS;
      Ready2Send<=Ready2Send_internal;
      a<=a_internal;
      inp<=inp_internal;
      process(pres_state)
      begin
         if (pres_state<8) then
            pres_state_plus_1<=pres_state+1;
         else
            pres_state_plus_1<=pres_state;
         end if;
      end process;
END program;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
-- LIBRARY SYNT;
-- USE SYNT.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY manchester_II_encoder IS
   PORT(clk:IN std_logic;
        enable:IN std_logic_vector(0 downto 0);
        Din:IN std_logic_vector(7 downto 0);
        DataReady:IN std_logic_vector(0 downto 0);
        q:OUT std_logic_vector(0 downto 0);
        Ready2Send:OUT std_logic_vector(0 downto 0));
END manchester_II_encoder;

ARCHITECTURE program OF manchester_II_encoder IS


   COMPONENT encode_0
      PORT(clk:IN std_logic;
        enable:IN std_logic_vector(0 downto 0);
        inp:IN std_logic_vector(0 downto 0);
        q:OUT std_logic_vector(0 downto 0));
   END COMPONENT;
   COMPONENT parallel2serial_1
      PORT(clk:IN std_logic;
        Din:IN std_logic_vector(7 downto 0);
        DataReady:IN std_logic_vector(0 downto 0);
        a:INOUT std_logic_vector(7 downto 0);
        inp:OUT std_logic_vector(0 downto 0);
        Ready2Send:OUT std_logic_vector(0 downto 0));
   END COMPONENT;
   SIGNAL a: std_logic_vector(7 downto 0);
   SIGNAL inp: std_logic_vector(0 downto 0);
BEGIN
   U0:encode_0 
      PORT MAP(clk,
               enable,
               inp,
               q);
   U1:parallel2serial_1 
      PORT MAP(clk,
               Din,
               DataReady,
               a,
               inp,
               Ready2Send);
END program;
