-- VHDL extracted from PROGRAM file CiscV
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
--USE IEEE.NUMERIC_STD.all; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ALL;
USE WORK.PROGRAM_PACKAGE.ALL;
ENTITY CiscV_0 IS
   PORT(clk:IN std_logic;
        s_active:IN std_logic_vector(0 downto 0);
        s_data:IN std_logic_vector(1 downto 0);
        sreset:IN std_logic_vector(0 downto 0);
        internal_addr:OUT std_logic_vector(1 downto 0);
        internal_m_data:OUT std_logic_vector(1 downto 0);
        rd_data:OUT std_logic_vector(4 downto 0);
        rs1_data:OUT std_logic_vector(4 downto 0);
        rs2_data:OUT std_logic_vector(4 downto 0);
        rs_sel:OUT std_logic_vector(1 downto 0);
        reversed_result_bus:IN std_logic_vector(31 downto 0);
        op1_alt:OUT std_logic_vector(31 downto 0);
        op2_alt:OUT std_logic_vector(31 downto 0);
        imm5_data:OUT std_logic_vector(4 downto 0);
        imm7_data:OUT std_logic_vector(6 downto 0);
        imm12_data:OUT std_logic_vector(11 downto 0);
        imm20_data:OUT std_logic_vector(19 downto 0);
        shift_imm:OUT std_logic_vector(4 downto 0);
        load_byte_data:IN std_logic_vector(23 downto 0);
        load_half_data:IN std_logic_vector(15 downto 0);
        result_select:OUT std_logic_vector(2 downto 0);
        lui_result:OUT std_logic_vector(31 downto 0);
        alu_funct:OUT std_logic_vector(0 downto 0);
        pc_sel:OUT std_logic_vector(2 downto 0);
        branch_funct:OUT std_logic_vector(2 downto 0);
        branch_bus:OUT std_logic_vector(31 downto 0);
        J_immediate:IN std_logic_vector(31 downto 0);
        S_immediate:IN std_logic_vector(31 downto 0);
        L_immediate:IN std_logic_vector(31 downto 0);
        shift_immediate:IN std_logic_vector(31 downto 0);
        load_byte_enable:OUT std_logic_vector(0 downto 0);
        load_half_enable:OUT std_logic_vector(0 downto 0);
        load_result:OUT std_logic_vector(31 downto 0);
        store_data:IN std_logic_vector(31 downto 0);
        store_enable:OUT std_logic_vector(0 downto 0);
        execution_enable:OUT std_logic_vector(0 downto 0);
        result_ready_decode:OUT std_logic_vector(0 downto 0);
        need_writeback:OUT std_logic_vector(0 downto 0);
        load_writeback_enable:OUT std_logic_vector(0 downto 0);
        alu_ctrl:OUT std_logic_vector(2 downto 0);
        pc:IN std_logic_vector(31 downto 0);
        reversed_pc:IN std_logic_vector(31 downto 0);
        send_clk:OUT std_logic_vector(0 downto 0);
        execution_type:OUT std_logic_vector(0 downto 0);
        parity_data:IN std_logic_vector(1 downto 0);
        parity_addr:IN std_logic_vector(1 downto 0);
        receiving:OUT std_logic_vector(0 downto 0);
        transmitting:OUT std_logic_vector(0 downto 0);
        reset_parity:OUT std_logic_vector(0 downto 0);
        com_enable:OUT std_logic_vector(0 downto 0);
        m_active:OUT std_logic_vector(0 downto 0));
END CiscV_0;

ARCHITECTURE program OF CiscV_0 IS

   SUBTYPE state_type IS INTEGER RANGE 0 TO 613;
   -- Reduced to a total of 614 states
   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;
   ATTRIBUTE state_vector:string;
   ATTRIBUTE state_vector OF program:ARCHITECTURE IS "pres_state";

   -- Extracted FIFO signals
   SUBTYPE fifo_type is std_logic_vector(1 downto 0);
   TYPE fifo_array is array (30 downto 1) of fifo_type;
   SIGNAL FIFO_s_data:fifo_array;

   -- Output registers
   SIGNAL com_enable_register: std_logic_vector(0 downto 0);
   SIGNAL com_enable_internal: std_logic_vector(0 downto 0);
   SIGNAL m_active_register: std_logic_vector(0 downto 0);
   SIGNAL m_active_internal: std_logic_vector(0 downto 0);

   -- Internal registers
   SIGNAL internal_addr_register: std_logic_vector(1 downto 0);
   SIGNAL internal_addr_internal: std_logic_vector(1 downto 0);
   SIGNAL internal_m_data_register: std_logic_vector(1 downto 0);
   SIGNAL internal_m_data_internal: std_logic_vector(1 downto 0);
   SIGNAL rd_data_register: std_logic_vector(4 downto 0);
   SIGNAL rd_data_internal: std_logic_vector(4 downto 0);
   SIGNAL rs1_data_register: std_logic_vector(4 downto 0);
   SIGNAL rs1_data_internal: std_logic_vector(4 downto 0);
   SIGNAL rs2_data_register: std_logic_vector(4 downto 0);
   SIGNAL rs2_data_internal: std_logic_vector(4 downto 0);
   SIGNAL rs_sel_register: std_logic_vector(1 downto 0);
   SIGNAL rs_sel_internal: std_logic_vector(1 downto 0);
   SIGNAL op1_alt_register: std_logic_vector(31 downto 0);
   SIGNAL op1_alt_internal: std_logic_vector(31 downto 0);
   SIGNAL op2_alt_register: std_logic_vector(31 downto 0);
   SIGNAL op2_alt_internal: std_logic_vector(31 downto 0);
   SIGNAL imm5_data_register: std_logic_vector(4 downto 0);
   SIGNAL imm5_data_internal: std_logic_vector(4 downto 0);
   SIGNAL imm7_data_register: std_logic_vector(6 downto 0);
   SIGNAL imm7_data_internal: std_logic_vector(6 downto 0);
   SIGNAL imm12_data_register: std_logic_vector(11 downto 0);
   SIGNAL imm12_data_internal: std_logic_vector(11 downto 0);
   SIGNAL imm20_data_register: std_logic_vector(19 downto 0);
   SIGNAL imm20_data_internal: std_logic_vector(19 downto 0);
   SIGNAL shift_imm_register: std_logic_vector(4 downto 0);
   SIGNAL shift_imm_internal: std_logic_vector(4 downto 0);
   SIGNAL result_select_register: std_logic_vector(2 downto 0);
   SIGNAL result_select_internal: std_logic_vector(2 downto 0);
   SIGNAL lui_result_register: std_logic_vector(31 downto 0);
   SIGNAL lui_result_internal: std_logic_vector(31 downto 0);
   SIGNAL alu_funct_register: std_logic_vector(0 downto 0);
   SIGNAL alu_funct_internal: std_logic_vector(0 downto 0);
   SIGNAL pc_sel_register: std_logic_vector(2 downto 0);
   SIGNAL pc_sel_internal: std_logic_vector(2 downto 0);
   SIGNAL branch_funct_register: std_logic_vector(2 downto 0);
   SIGNAL branch_funct_internal: std_logic_vector(2 downto 0);
   SIGNAL branch_bus_register: std_logic_vector(31 downto 0);
   SIGNAL branch_bus_internal: std_logic_vector(31 downto 0);
   SIGNAL load_byte_enable_register: std_logic_vector(0 downto 0);
   SIGNAL load_byte_enable_internal: std_logic_vector(0 downto 0);
   SIGNAL load_half_enable_register: std_logic_vector(0 downto 0);
   SIGNAL load_half_enable_internal: std_logic_vector(0 downto 0);
   SIGNAL load_result_register: std_logic_vector(31 downto 0);
   SIGNAL load_result_internal: std_logic_vector(31 downto 0);
   SIGNAL store_enable_register: std_logic_vector(0 downto 0);
   SIGNAL store_enable_internal: std_logic_vector(0 downto 0);
   SIGNAL execution_enable_register: std_logic_vector(0 downto 0);
   SIGNAL execution_enable_internal: std_logic_vector(0 downto 0);
   SIGNAL result_ready_decode_register: std_logic_vector(0 downto 0);
   SIGNAL result_ready_decode_internal: std_logic_vector(0 downto 0);
   SIGNAL need_writeback_register: std_logic_vector(0 downto 0);
   SIGNAL need_writeback_internal: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable_register: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable_internal: std_logic_vector(0 downto 0);
   SIGNAL alu_ctrl_register: std_logic_vector(2 downto 0);
   SIGNAL alu_ctrl_internal: std_logic_vector(2 downto 0);
   SIGNAL send_clk_register: std_logic_vector(0 downto 0);
   SIGNAL send_clk_internal: std_logic_vector(0 downto 0);
   SIGNAL execution_type_register: std_logic_vector(0 downto 0);
   SIGNAL execution_type_internal: std_logic_vector(0 downto 0);
   SIGNAL receiving_register: std_logic_vector(0 downto 0);
   SIGNAL receiving_internal: std_logic_vector(0 downto 0);
   SIGNAL transmitting_register: std_logic_vector(0 downto 0);
   SIGNAL transmitting_internal: std_logic_vector(0 downto 0);
   SIGNAL reset_parity_register: std_logic_vector(0 downto 0);
   SIGNAL reset_parity_internal: std_logic_vector(0 downto 0);
BEGIN
   FSM:
      -- Finite State Machine extracted from start symbol CiscV
      PROCESS (pres_state, pres_state_plus_1,
               s_active,
               s_data,
               sreset,
               internal_addr_internal,
               internal_m_data_internal,
               rd_data_internal,
               rs1_data_internal,
               rs2_data_internal,
               rs_sel_internal,
               reversed_result_bus,
               op1_alt_internal,
               op2_alt_internal,
               imm5_data_internal,
               imm7_data_internal,
               imm12_data_internal,
               imm20_data_internal,
               shift_imm_internal,
               load_byte_data,
               load_half_data,
               result_select_internal,
               lui_result_internal,
               alu_funct_internal,
               pc_sel_internal,
               branch_funct_internal,
               branch_bus_internal,
               J_immediate,
               S_immediate,
               L_immediate,
               shift_immediate,
               load_byte_enable_internal,
               load_half_enable_internal,
               load_result_internal,
               store_data,
               store_enable_internal,
               execution_enable_internal,
               result_ready_decode_internal,
               need_writeback_internal,
               load_writeback_enable_internal,
               alu_ctrl_internal,
               pc,
               reversed_pc,
               send_clk_internal,
               execution_type_internal,
               parity_data,
               parity_addr,
               receiving_internal,
               transmitting_internal,
               reset_parity_internal,
               com_enable_internal,
               m_active_internal,
               FIFO_s_data)
      BEGIN
         internal_addr_register<=internal_addr_internal;
         internal_m_data_register<=internal_m_data_internal;
         rd_data_register<=rd_data_internal;
         rs1_data_register<=rs1_data_internal;
         rs2_data_register<=rs2_data_internal;
         rs_sel_register<=rs_sel_internal;
         op1_alt_register<=op1_alt_internal;
         op2_alt_register<=op2_alt_internal;
         imm5_data_register<=imm5_data_internal;
         imm7_data_register<=imm7_data_internal;
         imm12_data_register<=imm12_data_internal;
         imm20_data_register<=imm20_data_internal;
         shift_imm_register<=shift_imm_internal;
         result_select_register<=result_select_internal;
         lui_result_register<=lui_result_internal;
         alu_funct_register<=alu_funct_internal;
         pc_sel_register<=pc_sel_internal;
         branch_funct_register<=branch_funct_internal;
         branch_bus_register<=branch_bus_internal;
         load_byte_enable_register<=load_byte_enable_internal;
         load_half_enable_register<=load_half_enable_internal;
         load_result_register<=load_result_internal;
         store_enable_register<=store_enable_internal;
         execution_enable_register<=execution_enable_internal;
         result_ready_decode_register<=result_ready_decode_internal;
         need_writeback_register<=need_writeback_internal;
         load_writeback_enable_register<=load_writeback_enable_internal;
         alu_ctrl_register<=alu_ctrl_internal;
         send_clk_register<=send_clk_internal;
         execution_type_register<=execution_type_internal;
         receiving_register<=receiving_internal;
         transmitting_register<=transmitting_internal;
         reset_parity_register<=reset_parity_internal;
         com_enable_register<=com_enable_internal;
         m_active_register<=m_active_internal;
         next_state<=pres_state;
         IF (sreset=std_logic_vector'("1")) THEN -- RESET STATE
            next_state<=1;
         ELSIF ((pres_state=1) AND
                (sreset(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=0;
         ELSIF ((pres_state=1) AND
                (sreset(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=2) AND
                (sreset(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            internal_addr_register(1 downto 0) <= std_logic_vector'("00");
            internal_m_data_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=0)) THEN 
            next_state<=3;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            send_clk_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=3)) THEN 
            next_state<=pres_state_plus_1;
            receiving_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_pc(31 downto 30);
         ELSIF ((pres_state=4)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(29 downto 28);
         ELSIF ((pres_state=5)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(27 downto 26);
         ELSIF ((pres_state=6)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(25 downto 24);
         ELSIF ((pres_state=7)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(23 downto 22);
         ELSIF ((pres_state=8)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(21 downto 20);
         ELSIF ((pres_state=9)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(19 downto 18);
         ELSIF ((pres_state=10)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(17 downto 16);
         ELSIF ((pres_state=11)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(15 downto 14);
         ELSIF ((pres_state=12)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(13 downto 12);
         ELSIF ((pres_state=13)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(11 downto 10);
         ELSIF ((pres_state=14)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(9 downto 8);
         ELSIF ((pres_state=15)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(7 downto 6);
         ELSIF ((pres_state=16)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(5 downto 4);
         ELSIF ((pres_state=17)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(3 downto 2);
         ELSIF ((pres_state=18)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_pc(1 downto 0);
            receiving_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=19)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
         ELSIF ((pres_state=20)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=21) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=22)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=23) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=24) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=25) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=26) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=27)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=28)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("000");
            rs_sel_register(1 downto 0) <= std_logic_vector'("00");
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
            lui_result_register(31 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(6)(1 downto 0) & 
                  FIFO_s_data(7)(1 downto 0) & 
                  FIFO_s_data(8)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 1) & 
                  std_logic_vector'("000000000000");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=39)) THEN 
            next_state<=0;
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=25) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=40;
         ELSIF ((pres_state=40) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=41)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=42)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            rs_sel_register(1 downto 0) <= std_logic_vector'("11");
            result_select_register(2 downto 0) <= std_logic_vector'("010");
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
            op1_alt_register(31 downto 0) <= pc(31 downto 0);
            op2_alt_register(31 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(6)(1 downto 0) & 
                  FIFO_s_data(7)(1 downto 0) & 
                  FIFO_s_data(8)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 1) & 
                  std_logic_vector'("000000000000");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=53)) THEN 
            next_state<=0;
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=25) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=54;
         ELSIF ((pres_state=54) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=55)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=56)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
            result_select_register(2 downto 0) <= std_logic_vector'("011");
         ELSIF ((pres_state=57) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=58) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=59)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=60)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
         ELSIF ((pres_state=61)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=62)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=63)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=64)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=65)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=66)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=67)) THEN 
            next_state<=0;
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("011");
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=24) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=68;
         ELSIF ((pres_state=68) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=69) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=70)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=71)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("011");
            rs_sel_register(1 downto 0) <= std_logic_vector'("11");
         ELSIF ((pres_state=72)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=73)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=74)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=75)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=76)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=77)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=78)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=79)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=80)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=81)) THEN 
            next_state<=pres_state_plus_1;
            imm20_data_register(19 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(6)(1 downto 0) & 
                  FIFO_s_data(7)(1 downto 0) & 
                  FIFO_s_data(8)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=82)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= J_immediate(31 downto 0);
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=83)) THEN 
            next_state<=0;
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("010");
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=24) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=84;
         ELSIF ((pres_state=84) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=85) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=86)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=87)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            rs_sel_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=88) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=89) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=90)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=91)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=92)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=93)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=94) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=95) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=96) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=97) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=98)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=97) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=99;
            alu_funct_register(0 downto 0) <= std_logic_vector'("1");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=99)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=89) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=100;
         ELSIF ((pres_state=100)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=101)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=102)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=103)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=104) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=105) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=106) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=107) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=108)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=88) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=109;
         ELSIF ((pres_state=109) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=110)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=111)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=112)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=113)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=114) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=115) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=116) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=117) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=118)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=109) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=119;
         ELSIF ((pres_state=119)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=120)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("101");
         ELSIF ((pres_state=121)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=122)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=123) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=124) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=125) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=126) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=127)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=126) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=128;
            alu_funct_register(0 downto 0) <= std_logic_vector'("1");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=128)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=88) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=129;
         ELSIF ((pres_state=129) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=130)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=131)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("010");
         ELSIF ((pres_state=132)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=133)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=134) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=135) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=136) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=137) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=138)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=129) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=139;
         ELSIF ((pres_state=139)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=140)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("110");
         ELSIF ((pres_state=141)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=142)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=143) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=144) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=145) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=146) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=147)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=88) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=148;
         ELSIF ((pres_state=148) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=149)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=150)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("011");
         ELSIF ((pres_state=151)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=152)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=153) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=154) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=155) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=156) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=157)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=148) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=158;
         ELSIF ((pres_state=158)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=159)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("111");
         ELSIF ((pres_state=160)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=161)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=162) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=163) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=164) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=165) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=166)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=84) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=167;
         ELSIF ((pres_state=167) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=168)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=169)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=170) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=171) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=172)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=173)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=174)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=175)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=176)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=177)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=178)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=179)) THEN 
            next_state<=pres_state_plus_1;
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=180)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=181)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=171) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=182;
         ELSIF ((pres_state=182)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=183)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("100");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=184)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=185)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=186)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=187)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=188)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=189)) THEN 
            next_state<=pres_state_plus_1;
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=190)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=191)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=170) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=192;
         ELSIF ((pres_state=192) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=193)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=194)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("010");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=195)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=196)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=197)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=198)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=199)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=200)) THEN 
            next_state<=pres_state_plus_1;
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=201)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=202)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=192) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=203;
         ELSIF ((pres_state=203)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=204)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("110");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=205)) THEN 
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
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=211)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=212)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=170) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=213;
         ELSIF ((pres_state=213) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=214)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=215)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("011");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
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
            op2_alt_register(31 downto 0) <= std_logic_vector'("00000000000000000000") & 
                  s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=222)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=213) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=223;
         ELSIF ((pres_state=223)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=224)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("111");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
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
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=231)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=232)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=170) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=233;
         ELSIF ((pres_state=233) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=234)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=235)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=236)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=237)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=238) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            shift_imm_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=239) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=240) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=241) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= shift_immediate(31 downto 0);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=242)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=233) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=243;
         ELSIF ((pres_state=243)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=244)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("101");
         ELSIF ((pres_state=245)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=246)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=247) AND
                (s_data(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            shift_imm_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=248) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=249) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=250) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= shift_immediate(31 downto 0);
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=251)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=250) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=252;
            op2_alt_register(31 downto 0) <= shift_immediate(31 downto 0);
            alu_funct_register(0 downto 0) <= std_logic_vector'("1");
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            need_writeback_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=252)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            need_writeback_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=84) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=253;
         ELSIF ((pres_state=253) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=254)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=255)) THEN 
            next_state<=pres_state_plus_1;
            imm5_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=256) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=257) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
            internal_m_data_register(1 downto 0) <= store_data(31 downto 30);
         ELSIF ((pres_state=258)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
            internal_m_data_register(1 downto 0) <= store_data(29 downto 28);
         ELSIF ((pres_state=259)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
            internal_m_data_register(1 downto 0) <= store_data(27 downto 26);
         ELSIF ((pres_state=260)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
            internal_m_data_register(1 downto 0) <= store_data(25 downto 24);
         ELSIF ((pres_state=261)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
            internal_m_data_register(1 downto 0) <= store_data(23 downto 22);
         ELSIF ((pres_state=262)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
            internal_m_data_register(1 downto 0) <= store_data(21 downto 20);
         ELSIF ((pres_state=263)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
            internal_m_data_register(1 downto 0) <= store_data(19 downto 18);
         ELSIF ((pres_state=264)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
            internal_m_data_register(1 downto 0) <= store_data(17 downto 16);
         ELSIF ((pres_state=265)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
            internal_m_data_register(1 downto 0) <= store_data(15 downto 14);
         ELSIF ((pres_state=266)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= S_immediate(31 downto 0);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
            internal_m_data_register(1 downto 0) <= store_data(13 downto 12);
         ELSIF ((pres_state=267)) THEN 
            next_state<=pres_state_plus_1;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
            internal_m_data_register(1 downto 0) <= store_data(11 downto 10);
         ELSIF ((pres_state=268)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
            store_enable_register(0 downto 0) <= std_logic_vector'("1");
            internal_m_data_register(1 downto 0) <= store_data(9 downto 8);
         ELSIF ((pres_state=269)) THEN 
            next_state<=pres_state_plus_1;
            transmitting_register(0 downto 0) <= std_logic_vector'("1");
            store_enable_register(0 downto 0) <= std_logic_vector'("0");
            internal_m_data_register(1 downto 0) <= store_data(7 downto 6);
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=270)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(5 downto 4);
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=271)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(3 downto 2);
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=272)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(1 downto 0);
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            transmitting_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=273)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
            internal_m_data_register(1 downto 0) <= parity_data(1 downto 0);
         ELSIF ((pres_state=274)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=275) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=276)) THEN 
            next_state<=0;
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=275) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=256) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=277;
         ELSIF ((pres_state=277) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=278)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=279)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=280)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=281)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
            internal_m_data_register(1 downto 0) <= store_data(31 downto 30);
         ELSIF ((pres_state=282)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
            internal_m_data_register(1 downto 0) <= store_data(29 downto 28);
         ELSIF ((pres_state=283)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
            internal_m_data_register(1 downto 0) <= store_data(27 downto 26);
         ELSIF ((pres_state=284)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
            internal_m_data_register(1 downto 0) <= store_data(25 downto 24);
         ELSIF ((pres_state=285)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
            internal_m_data_register(1 downto 0) <= store_data(23 downto 22);
         ELSIF ((pres_state=286)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= S_immediate(31 downto 0);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
            internal_m_data_register(1 downto 0) <= store_data(21 downto 20);
         ELSIF ((pres_state=287)) THEN 
            next_state<=pres_state_plus_1;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
            internal_m_data_register(1 downto 0) <= store_data(19 downto 18);
         ELSIF ((pres_state=288)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
            store_enable_register(0 downto 0) <= std_logic_vector'("1");
            internal_m_data_register(1 downto 0) <= store_data(17 downto 16);
         ELSIF ((pres_state=289)) THEN 
            next_state<=pres_state_plus_1;
            transmitting_register(0 downto 0) <= std_logic_vector'("1");
            store_enable_register(0 downto 0) <= std_logic_vector'("0");
            internal_m_data_register(1 downto 0) <= store_data(15 downto 14);
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=290)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(13 downto 12);
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=291)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(11 downto 10);
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=292)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(9 downto 8);
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=293)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(7 downto 6);
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=294)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(5 downto 4);
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=295)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(3 downto 2);
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=296)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(1 downto 0);
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            transmitting_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=297)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
            internal_m_data_register(1 downto 0) <= parity_data(1 downto 0);
         ELSIF ((pres_state=298)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=299) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=300)) THEN 
            next_state<=0;
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=299) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=256) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=301;
         ELSIF ((pres_state=301) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=302)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=303)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=304)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=305)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=306)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=307)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=308)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=309)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
         ELSIF ((pres_state=310)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= S_immediate(31 downto 0);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=311)) THEN 
            next_state<=pres_state_plus_1;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=312)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("00");
            store_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=313)) THEN 
            next_state<=pres_state_plus_1;
            transmitting_register(0 downto 0) <= std_logic_vector'("1");
            store_enable_register(0 downto 0) <= std_logic_vector'("0");
            internal_m_data_register(1 downto 0) <= store_data(31 downto 30);
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
         ELSIF ((pres_state=314)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(29 downto 28);
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
         ELSIF ((pres_state=315)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(27 downto 26);
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
         ELSIF ((pres_state=316)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(25 downto 24);
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
         ELSIF ((pres_state=317)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(23 downto 22);
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
         ELSIF ((pres_state=318)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(21 downto 20);
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
         ELSIF ((pres_state=319)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(19 downto 18);
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
         ELSIF ((pres_state=320)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(17 downto 16);
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
         ELSIF ((pres_state=321)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(15 downto 14);
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=322)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(13 downto 12);
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=323)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(11 downto 10);
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=324)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(9 downto 8);
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=325)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(7 downto 6);
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=326)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(5 downto 4);
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=327)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(3 downto 2);
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=328)) THEN 
            next_state<=pres_state_plus_1;
            internal_m_data_register(1 downto 0) <= store_data(1 downto 0);
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            transmitting_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=329)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
            internal_m_data_register(1 downto 0) <= parity_data(1 downto 0);
         ELSIF ((pres_state=330)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=331) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=332)) THEN 
            next_state<=0;
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=331) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=253) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=333;
         ELSIF ((pres_state=333)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=334)) THEN 
            next_state<=pres_state_plus_1;
            imm5_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            rs_sel_register(1 downto 0) <= std_logic_vector'("00");
         ELSIF ((pres_state=335) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=336) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=337)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=338)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("111");
            branch_funct_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=339)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=340)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=341)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=342)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=343)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=344)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=345)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=336) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=346;
         ELSIF ((pres_state=346)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=347)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("111");
            branch_funct_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=348)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=349)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=350)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=351)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=352)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=353)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=354)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=335) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=355;
         ELSIF ((pres_state=355) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=356)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=357)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("111");
            branch_funct_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=358)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=359)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=360)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=361)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=362)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=363)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=364)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=355) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=365;
         ELSIF ((pres_state=365)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=366)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("111");
            branch_funct_register(2 downto 0) <= std_logic_vector'("101");
         ELSIF ((pres_state=367)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=368)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=369)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=370)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=371)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=372)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=373)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=335) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=374;
         ELSIF ((pres_state=374) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=375)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=376)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("111");
            branch_funct_register(2 downto 0) <= std_logic_vector'("110");
         ELSIF ((pres_state=377)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=378)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=379)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=380)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=381)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=382)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            branch_bus_register(31 downto 0) <= std_logic_vector'("00000000000000000000") & 
                  imm7_data_internal(6 downto 0) & 
                  imm5_data_internal(4 downto 0);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=383)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=335) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("11"))) THEN 
            next_state<=384;
         ELSIF ((pres_state=384) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=385)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=386)) THEN 
            next_state<=pres_state_plus_1;
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            result_select_register(2 downto 0) <= std_logic_vector'("111");
            branch_funct_register(2 downto 0) <= std_logic_vector'("111");
         ELSIF ((pres_state=387)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=388)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=389)) THEN 
            next_state<=pres_state_plus_1;
            rs2_data_register(4 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0);
         ELSIF ((pres_state=390)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=391)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=392)) THEN 
            next_state<=pres_state_plus_1;
            imm7_data_register(6 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 1);
            branch_bus_register(31 downto 0) <= std_logic_vector'("00000000000000000000") & 
                  imm7_data_internal(6 downto 0) & 
                  imm5_data_internal(4 downto 0);
            execution_type_register(0 downto 0) <= std_logic_vector'("0");
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=393)) THEN 
            next_state<=0;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("100");
         ELSIF ((pres_state=84) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=394;
         ELSIF ((pres_state=394) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=395)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=396)) THEN 
            next_state<=pres_state_plus_1;
            rd_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
         ELSIF ((pres_state=397) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("00"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=398) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=399)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=400)) THEN 
            next_state<=pres_state_plus_1;
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=401)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=402)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=403)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=404)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=405)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=406)) THEN 
            next_state<=pres_state_plus_1;
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=407)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            load_byte_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=408)) THEN 
            next_state<=pres_state_plus_1;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            load_byte_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=409)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=410)) THEN 
            next_state<=pres_state_plus_1;
            receiving_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
         ELSIF ((pres_state=411)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
         ELSIF ((pres_state=412)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
         ELSIF ((pres_state=413)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
         ELSIF ((pres_state=414)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
         ELSIF ((pres_state=415)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
         ELSIF ((pres_state=416)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
         ELSIF ((pres_state=417)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
         ELSIF ((pres_state=418)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=419)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=420)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=421)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=422)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=423)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=424)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=425)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            receiving_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=426)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
         ELSIF ((pres_state=427)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=428) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
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
            load_result_register(31 downto 0) <= load_byte_data(23 downto 0) & 
                  s_data(1 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0);
            result_select_register(2 downto 0) <= std_logic_vector'("100");
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("1");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=434)) THEN 
            next_state<=0;
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=428) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=398) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=435;
         ELSIF ((pres_state=435)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=436)) THEN 
            next_state<=pres_state_plus_1;
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
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
         ELSIF ((pres_state=442)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= std_logic_vector'("00000000000000000000") & 
                  s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            load_byte_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=443)) THEN 
            next_state<=pres_state_plus_1;
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            load_byte_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=444)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=445)) THEN 
            next_state<=pres_state_plus_1;
            receiving_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
         ELSIF ((pres_state=446)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
         ELSIF ((pres_state=447)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
         ELSIF ((pres_state=448)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
         ELSIF ((pres_state=449)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
         ELSIF ((pres_state=450)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
         ELSIF ((pres_state=451)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
         ELSIF ((pres_state=452)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
         ELSIF ((pres_state=453)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=454)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=455)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=456)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=457)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=458)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=459)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=460)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            receiving_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=461)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
         ELSIF ((pres_state=462)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=463) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
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
            load_result_register(31 downto 0) <= load_byte_data(23 downto 0) & 
                  s_data(1 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0);
            result_select_register(2 downto 0) <= std_logic_vector'("100");
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("1");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=469)) THEN 
            next_state<=0;
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=463) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=397) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("10"))) THEN 
            next_state<=470;
         ELSIF ((pres_state=470) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=471)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=472)) THEN 
            next_state<=pres_state_plus_1;
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=473)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=474)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=475)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=476)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=477)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=478)) THEN 
            next_state<=pres_state_plus_1;
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=479)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
            load_half_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=480)) THEN 
            next_state<=pres_state_plus_1;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            load_half_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=481)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=482)) THEN 
            next_state<=pres_state_plus_1;
            receiving_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
         ELSIF ((pres_state=483)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
         ELSIF ((pres_state=484)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
         ELSIF ((pres_state=485)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
         ELSIF ((pres_state=486)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
         ELSIF ((pres_state=487)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
         ELSIF ((pres_state=488)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
         ELSIF ((pres_state=489)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
         ELSIF ((pres_state=490)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=491)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=492)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=493)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=494)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=495)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=496)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=497)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            receiving_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=498)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
         ELSIF ((pres_state=499)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=500) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
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
         ELSIF ((pres_state=506)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=507)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=508)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=509)) THEN 
            next_state<=pres_state_plus_1;
            load_result_register(31 downto 0) <= load_half_data(15 downto 0) & 
                  s_data(1 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(6)(1 downto 0) & 
                  FIFO_s_data(7)(1 downto 0);
            result_select_register(2 downto 0) <= std_logic_vector'("100");
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("1");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=510)) THEN 
            next_state<=0;
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=500) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=470) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("1"))) THEN 
            next_state<=511;
         ELSIF ((pres_state=511)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=512)) THEN 
            next_state<=pres_state_plus_1;
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=513)) THEN 
            next_state<=pres_state_plus_1;
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
            op2_alt_register(31 downto 0) <= std_logic_vector'("00000000000000000000") & 
                  s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
            load_half_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=519)) THEN 
            next_state<=pres_state_plus_1;
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            load_half_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=520)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=521)) THEN 
            next_state<=pres_state_plus_1;
            receiving_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
         ELSIF ((pres_state=522)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
         ELSIF ((pres_state=523)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
         ELSIF ((pres_state=524)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
         ELSIF ((pres_state=525)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
         ELSIF ((pres_state=526)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
         ELSIF ((pres_state=527)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
         ELSIF ((pres_state=528)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
         ELSIF ((pres_state=529)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=530)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=531)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=532)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=533)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=534)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=535)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=536)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            receiving_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=537)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
         ELSIF ((pres_state=538)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=539) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=540)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=541)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=542)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=543)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=544)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=545)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=546)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=547)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=548)) THEN 
            next_state<=pres_state_plus_1;
            load_result_register(31 downto 0) <= load_half_data(15 downto 0) & 
                  s_data(1 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(6)(1 downto 0) & 
                  FIFO_s_data(7)(1 downto 0);
            result_select_register(2 downto 0) <= std_logic_vector'("100");
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("1");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=549)) THEN 
            next_state<=0;
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=539) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=397) AND
                (s_data(1 DOWNTO 0)=std_logic_vector'("01"))) THEN 
            next_state<=550;
         ELSIF ((pres_state=550) AND
                (s_data(1 DOWNTO 1)=std_logic_vector'("0"))) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=551)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=552)) THEN 
            next_state<=pres_state_plus_1;
            rs_sel_register(1 downto 0) <= std_logic_vector'("10");
            rs1_data_register(4 downto 0) <= FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 1);
            alu_ctrl_register(2 downto 0) <= std_logic_vector'("000");
            alu_funct_register(0 downto 0) <= std_logic_vector'("0");
            result_select_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=553)) THEN 
            next_state<=pres_state_plus_1;
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
            imm12_data_register(11 downto 0) <= s_data(0 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 1);
            execution_type_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=559)) THEN 
            next_state<=pres_state_plus_1;
            op2_alt_register(31 downto 0) <= L_immediate(31 downto 0);
            execution_enable_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=560)) THEN 
            next_state<=pres_state_plus_1;
            execution_enable_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=561)) THEN 
            next_state<=pres_state_plus_1;
            reset_parity_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("1");
            m_active_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= std_logic_vector'("10");
         ELSIF ((pres_state=562)) THEN 
            next_state<=pres_state_plus_1;
            receiving_register(0 downto 0) <= std_logic_vector'("1");
            internal_addr_register(1 downto 0) <= reversed_result_bus(31 downto 30);
         ELSIF ((pres_state=563)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(29 downto 28);
         ELSIF ((pres_state=564)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(27 downto 26);
         ELSIF ((pres_state=565)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(25 downto 24);
         ELSIF ((pres_state=566)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(23 downto 22);
         ELSIF ((pres_state=567)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(21 downto 20);
         ELSIF ((pres_state=568)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(19 downto 18);
         ELSIF ((pres_state=569)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(17 downto 16);
         ELSIF ((pres_state=570)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(15 downto 14);
         ELSIF ((pres_state=571)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(13 downto 12);
         ELSIF ((pres_state=572)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(11 downto 10);
         ELSIF ((pres_state=573)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(9 downto 8);
         ELSIF ((pres_state=574)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(7 downto 6);
         ELSIF ((pres_state=575)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(5 downto 4);
         ELSIF ((pres_state=576)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(3 downto 2);
         ELSIF ((pres_state=577)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= reversed_result_bus(1 downto 0);
            receiving_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=578)) THEN 
            next_state<=pres_state_plus_1;
            internal_addr_register(1 downto 0) <= parity_addr(1 downto 0);
         ELSIF ((pres_state=579)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=580) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("1"))) THEN 
            next_state<=pres_state_plus_1;
            m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
         ELSIF ((pres_state=581)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=582)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=583)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=584)) THEN 
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
            load_result_register(31 downto 0) <= s_data(1 downto 0) & 
                  FIFO_s_data(1)(1 downto 0) & 
                  FIFO_s_data(2)(1 downto 0) & 
                  FIFO_s_data(3)(1 downto 0) & 
                  FIFO_s_data(4)(1 downto 0) & 
                  FIFO_s_data(5)(1 downto 0) & 
                  FIFO_s_data(6)(1 downto 0) & 
                  FIFO_s_data(7)(1 downto 0) & 
                  FIFO_s_data(8)(1 downto 0) & 
                  FIFO_s_data(9)(1 downto 0) & 
                  FIFO_s_data(10)(1 downto 0) & 
                  FIFO_s_data(11)(1 downto 0) & 
                  FIFO_s_data(12)(1 downto 0) & 
                  FIFO_s_data(13)(1 downto 0) & 
                  FIFO_s_data(14)(1 downto 0) & 
                  FIFO_s_data(15)(1 downto 0);
            result_select_register(2 downto 0) <= std_logic_vector'("100");
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("1");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("1");
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=598)) THEN 
            next_state<=0;
            load_writeback_enable_register(0 downto 0) <= std_logic_vector'("0");
            result_ready_decode_register(0 downto 0) <= std_logic_vector'("0");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=580) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSIF ((pres_state=23)) THEN 
            next_state<=599;
         ELSIF ((pres_state=599)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=600)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=601)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=602)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=603)) THEN 
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
         ELSIF ((pres_state=609)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=610)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=611)) THEN 
            next_state<=pres_state_plus_1;
         ELSIF ((pres_state=612)) THEN 
            next_state<=pres_state_plus_1;
            pc_sel_register(2 downto 0) <= std_logic_vector'("000");
         ELSIF ((pres_state=613)) THEN 
            next_state<=0;
            pc_sel_register(2 downto 0) <= std_logic_vector'("001");
         ELSIF ((pres_state=21) AND
                (s_active(0 DOWNTO 0)=std_logic_vector'("0"))) THEN 
            next_state<=0;
              next_state <= 0;  
             m_active_register(0 downto 0) <= std_logic_vector'("0");
            reset_parity_register(0 downto 0) <= std_logic_vector'("1");
            com_enable_register(0 downto 0) <= std_logic_vector'("0");
         ELSE -- DEFAULT ERROR STATE
            next_state<=0;
         END IF;
      END PROCESS;
   FIFO_0:
      -- Extracted FIFO with 30 stages of 2 bits
      PROCESS(clk)
      BEGIN
         IF clk'event AND (clk='1') THEN
            FOR i IN 30 downto 2 LOOP
                  FIFO_s_data(i)<=FIFO_s_data(i-1);
            END LOOP;
            FIFO_s_data(1)<=s_data;
         END IF;
      END PROCESS;
   REGISTERS:
      -- Output and State Registers
      PROCESS(clk)
      BEGIN
         IF rising_edge(clk) THEN
            pres_state<=next_state;
            com_enable_internal<=com_enable_register;
            m_active_internal<=m_active_register;
            internal_addr_internal<=internal_addr_register;
            internal_m_data_internal<=internal_m_data_register;
            rd_data_internal<=rd_data_register;
            rs1_data_internal<=rs1_data_register;
            rs2_data_internal<=rs2_data_register;
            rs_sel_internal<=rs_sel_register;
            op1_alt_internal<=op1_alt_register;
            op2_alt_internal<=op2_alt_register;
            imm5_data_internal<=imm5_data_register;
            imm7_data_internal<=imm7_data_register;
            imm12_data_internal<=imm12_data_register;
            imm20_data_internal<=imm20_data_register;
            shift_imm_internal<=shift_imm_register;
            result_select_internal<=result_select_register;
            lui_result_internal<=lui_result_register;
            alu_funct_internal<=alu_funct_register;
            pc_sel_internal<=pc_sel_register;
            branch_funct_internal<=branch_funct_register;
            branch_bus_internal<=branch_bus_register;
            load_byte_enable_internal<=load_byte_enable_register;
            load_half_enable_internal<=load_half_enable_register;
            load_result_internal<=load_result_register;
            store_enable_internal<=store_enable_register;
            execution_enable_internal<=execution_enable_register;
            result_ready_decode_internal<=result_ready_decode_register;
            need_writeback_internal<=need_writeback_register;
            load_writeback_enable_internal<=load_writeback_enable_register;
            alu_ctrl_internal<=alu_ctrl_register;
            send_clk_internal<=send_clk_register;
            execution_type_internal<=execution_type_register;
            receiving_internal<=receiving_register;
            transmitting_internal<=transmitting_register;
            reset_parity_internal<=reset_parity_register;
         END IF;
      END PROCESS;
      com_enable<=com_enable_internal;
      m_active<=m_active_internal;
      internal_addr<=internal_addr_internal;
      internal_m_data<=internal_m_data_internal;
      rd_data<=rd_data_internal;
      rs1_data<=rs1_data_internal;
      rs2_data<=rs2_data_internal;
      rs_sel<=rs_sel_internal;
      op1_alt<=op1_alt_internal;
      op2_alt<=op2_alt_internal;
      imm5_data<=imm5_data_internal;
      imm7_data<=imm7_data_internal;
      imm12_data<=imm12_data_internal;
      imm20_data<=imm20_data_internal;
      shift_imm<=shift_imm_internal;
      result_select<=result_select_internal;
      lui_result<=lui_result_internal;
      alu_funct<=alu_funct_internal;
      pc_sel<=pc_sel_internal;
      branch_funct<=branch_funct_internal;
      branch_bus<=branch_bus_internal;
      load_byte_enable<=load_byte_enable_internal;
      load_half_enable<=load_half_enable_internal;
      load_result<=load_result_internal;
      store_enable<=store_enable_internal;
      execution_enable<=execution_enable_internal;
      result_ready_decode<=result_ready_decode_internal;
      need_writeback<=need_writeback_internal;
      load_writeback_enable<=load_writeback_enable_internal;
      alu_ctrl<=alu_ctrl_internal;
      send_clk<=send_clk_internal;
      execution_type<=execution_type_internal;
      receiving<=receiving_internal;
      transmitting<=transmitting_internal;
      reset_parity<=reset_parity_internal;
      process(pres_state)
      begin
         if (pres_state<613) then
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
        s_active:IN std_logic_vector(0 downto 0);
        s_data:IN std_logic_vector(1 downto 0);
        sreset:IN std_logic_vector(0 downto 0);
        com_enable:OUT std_logic_vector(0 downto 0);
        m_active:OUT std_logic_vector(0 downto 0);
        addr:OUT std_logic_vector(1 downto 0);
        m_data:OUT std_logic_vector(1 downto 0);
        clk_out:OUT std_logic_vector(0 downto 0));
END CiscV;

ARCHITECTURE program OF CiscV IS


   COMPONENT CiscV_0
      PORT(clk:IN std_logic;
        s_active:IN std_logic_vector(0 downto 0);
        s_data:IN std_logic_vector(1 downto 0);
        sreset:IN std_logic_vector(0 downto 0);
        internal_addr:OUT std_logic_vector(1 downto 0);
        internal_m_data:OUT std_logic_vector(1 downto 0);
        rd_data:OUT std_logic_vector(4 downto 0);
        rs1_data:OUT std_logic_vector(4 downto 0);
        rs2_data:OUT std_logic_vector(4 downto 0);
        rs_sel:OUT std_logic_vector(1 downto 0);
        reversed_result_bus:IN std_logic_vector(31 downto 0);
        op1_alt:OUT std_logic_vector(31 downto 0);
        op2_alt:OUT std_logic_vector(31 downto 0);
        imm5_data:OUT std_logic_vector(4 downto 0);
        imm7_data:OUT std_logic_vector(6 downto 0);
        imm12_data:OUT std_logic_vector(11 downto 0);
        imm20_data:OUT std_logic_vector(19 downto 0);
        shift_imm:OUT std_logic_vector(4 downto 0);
        load_byte_data:IN std_logic_vector(23 downto 0);
        load_half_data:IN std_logic_vector(15 downto 0);
        result_select:OUT std_logic_vector(2 downto 0);
        lui_result:OUT std_logic_vector(31 downto 0);
        alu_funct:OUT std_logic_vector(0 downto 0);
        pc_sel:OUT std_logic_vector(2 downto 0);
        branch_funct:OUT std_logic_vector(2 downto 0);
        branch_bus:OUT std_logic_vector(31 downto 0);
        J_immediate:IN std_logic_vector(31 downto 0);
        S_immediate:IN std_logic_vector(31 downto 0);
        L_immediate:IN std_logic_vector(31 downto 0);
        shift_immediate:IN std_logic_vector(31 downto 0);
        load_byte_enable:OUT std_logic_vector(0 downto 0);
        load_half_enable:OUT std_logic_vector(0 downto 0);
        load_result:OUT std_logic_vector(31 downto 0);
        store_data:IN std_logic_vector(31 downto 0);
        store_enable:OUT std_logic_vector(0 downto 0);
        execution_enable:OUT std_logic_vector(0 downto 0);
        result_ready_decode:OUT std_logic_vector(0 downto 0);
        need_writeback:OUT std_logic_vector(0 downto 0);
        load_writeback_enable:OUT std_logic_vector(0 downto 0);
        alu_ctrl:OUT std_logic_vector(2 downto 0);
        pc:IN std_logic_vector(31 downto 0);
        reversed_pc:IN std_logic_vector(31 downto 0);
        send_clk:OUT std_logic_vector(0 downto 0);
        execution_type:OUT std_logic_vector(0 downto 0);
        parity_data:IN std_logic_vector(1 downto 0);
        parity_addr:IN std_logic_vector(1 downto 0);
        receiving:OUT std_logic_vector(0 downto 0);
        transmitting:OUT std_logic_vector(0 downto 0);
        reset_parity:OUT std_logic_vector(0 downto 0);
        com_enable:OUT std_logic_vector(0 downto 0);
        m_active:OUT std_logic_vector(0 downto 0));
   END COMPONENT;
   SIGNAL internal_addr: std_logic_vector(1 downto 0);
   SIGNAL internal_m_data: std_logic_vector(1 downto 0);
   SIGNAL rd_data: std_logic_vector(4 downto 0);
   SIGNAL rs1_data: std_logic_vector(4 downto 0);
   SIGNAL rs2_data: std_logic_vector(4 downto 0);
   SIGNAL rs_sel: std_logic_vector(1 downto 0);
   SIGNAL result_bus: std_logic_vector(31 downto 0);
   SIGNAL reversed_result_bus: std_logic_vector(31 downto 0);
   SIGNAL op1_bus: std_logic_vector(31 downto 0);
   SIGNAL op1_alt: std_logic_vector(31 downto 0);
   SIGNAL op2_bus: std_logic_vector(31 downto 0);
   SIGNAL op2_alt: std_logic_vector(31 downto 0);
   SIGNAL imm5_data: std_logic_vector(4 downto 0);
   SIGNAL imm7_data: std_logic_vector(6 downto 0);
   SIGNAL imm12_data: std_logic_vector(11 downto 0);
   SIGNAL imm20_data: std_logic_vector(19 downto 0);
   SIGNAL shift_imm: std_logic_vector(4 downto 0);
   SIGNAL load_byte_data: std_logic_vector(23 downto 0);
   SIGNAL load_half_data: std_logic_vector(15 downto 0);
   SIGNAL result_select: std_logic_vector(2 downto 0);
   SIGNAL alu_result: std_logic_vector(31 downto 0);
   SIGNAL lui_result: std_logic_vector(31 downto 0);
   SIGNAL alu_funct: std_logic_vector(0 downto 0);
   SIGNAL pc_sel: std_logic_vector(2 downto 0);
   SIGNAL last_pc_sel: std_logic_vector(2 downto 0);
   SIGNAL branch_immediate: std_logic_vector(31 downto 0);
   SIGNAL branch_funct: std_logic_vector(2 downto 0);
   SIGNAL branch_bus: std_logic_vector(31 downto 0);
   SIGNAL branch_type: std_logic_vector(0 downto 0);
   SIGNAL J_immediate: std_logic_vector(31 downto 0);
   SIGNAL S_immediate: std_logic_vector(31 downto 0);
   SIGNAL L_immediate: std_logic_vector(31 downto 0);
   SIGNAL shift_immediate: std_logic_vector(31 downto 0);
   SIGNAL internal_load_byte_data: std_logic_vector(23 downto 0);
   SIGNAL internal_load_half_data: std_logic_vector(15 downto 0);
   SIGNAL load_byte_enable: std_logic_vector(0 downto 0);
   SIGNAL load_half_enable: std_logic_vector(0 downto 0);
   SIGNAL load_result: std_logic_vector(31 downto 0);
   SIGNAL store_data: std_logic_vector(31 downto 0);
   SIGNAL store_enable: std_logic_vector(0 downto 0);
   SIGNAL execution_enable: std_logic_vector(0 downto 0);
   SIGNAL execution_enable_buffer: std_logic_vector(0 downto 0);
   SIGNAL execution_enable_reset: std_logic_vector(0 downto 0);
   SIGNAL result_ready_decode: std_logic_vector(0 downto 0);
   SIGNAL result_ready_execution: std_logic_vector(0 downto 0);
   SIGNAL result_ready_buffer: std_logic_vector(0 downto 0);
   SIGNAL result_ready_reset: std_logic_vector(0 downto 0);
   SIGNAL need_writeback: std_logic_vector(0 downto 0);
   SIGNAL need_writeback_buffer: std_logic_vector(0 downto 0);
   SIGNAL need_writeback_reset: std_logic_vector(0 downto 0);
   SIGNAL writeback_enable: std_logic_vector(0 downto 0);
   SIGNAL writeback_enable_buffer: std_logic_vector(0 downto 0);
   SIGNAL writeback_enable_reset: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable_buffer: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable_buffer2: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable_reset: std_logic_vector(0 downto 0);
   SIGNAL load_writeback_enable_reset2: std_logic_vector(0 downto 0);
   SIGNAL alu_ctrl: std_logic_vector(2 downto 0);
   SIGNAL pc: std_logic_vector(31 downto 0);
   SIGNAL reversed_pc: std_logic_vector(31 downto 0);
   SIGNAL send_clk: std_logic_vector(0 downto 0);
   SIGNAL execution_type: std_logic_vector(0 downto 0);
   SIGNAL branch_bool: std_logic_vector(0 downto 0);
   SIGNAL parity_data: std_logic_vector(1 downto 0);
   SIGNAL parity_addr: std_logic_vector(1 downto 0);
   SIGNAL receiving: std_logic_vector(0 downto 0);
   SIGNAL transmitting: std_logic_vector(0 downto 0);
   SIGNAL reset_parity: std_logic_vector(0 downto 0);
   -- Included VHDL signals
   type memory_array_type is array (natural range <>) of std_logic_vector(31 downto 0);
   signal regs:memory_array_type(31 downto 0);

BEGIN
   -- Included Top Architecture Code
   --Setting immediate values
   branch_immediate <=  ("1111111111111111111" & imm7_data(6) & imm5_data(0) & imm7_data(5 downto 0) & imm5_data(4 downto 1) & "0") when imm7_data(6)='1' else
                              ("0000000000000000000" & imm7_data(6) & imm5_data(0) & imm7_data(5 downto 0) & imm5_data(4 downto 1) & "0");
   J_immediate <= ("11111111111" & imm20_data(19) & imm20_data(7 downto 0) & imm20_data(8) & imm20_data(18 downto 9) & "0") when imm20_data(19)='1' else
                  ("00000000000" & imm20_data(19) & imm20_data(7 downto 0) & imm20_data(8) & imm20_data(18 downto 9) & "0");
   S_immediate <= ("11111111111111111111" & imm7_data(6 downto 0) & imm5_data(4 downto 0)) when imm7_data(6)='1' else
                  ("00000000000000000000" & imm7_data(6 downto 0) & imm5_data(4 downto 0));
   
   L_immediate <= ("11111111111111111111" & imm12_data(11 downto 0)) when imm12_data(11)='1' else
                  ("00000000000000000000" & imm12_data(11 downto 0));
   shift_immediate <= ("111111111111111111111111111" & shift_imm(4 downto 0)) when shift_imm(4)='1' else
                      ("000000000000000000000000000" & shift_imm(4 downto 0));
   addr <= internal_addr;
   m_data <= internal_m_data;
   send_clock: process(clk, send_clk)
   begin
      if send_clk = "1" then
         clk_out(0) <= clk;
      end if;
   end process;
   control_signal_handler: process(clk)
   begin
      if(falling_edge(clk)) then
         --exectuion control
         if execution_enable = "1" then
            execution_enable_buffer <= "1";
         end if;
         
         if execution_enable_reset = "1" then
            execution_enable_buffer <= "0";
         end if;
         --result control
         if( result_ready_decode = "1" or result_ready_execution = "1" ) then
            result_ready_buffer <= "1";
         end if;
         if( result_ready_reset = "1" ) then
            result_ready_buffer <= "0";
         end if;
         --writeback control
         if need_writeback = "1" then
            need_writeback_buffer <= "1";
         end if;
         
         if need_writeback_reset = "1" then
            need_writeback_buffer <= "0";
         end if;
         --writeback_enable control
          if writeback_enable = "1" then
            writeback_enable_buffer <= "1";
         end if;
         if writeback_enable_reset = "1" then
            writeback_enable_buffer <= "0";
         end if;
         --load writeback control
         if load_writeback_enable_buffer = "1" then
            load_writeback_enable_buffer2 <= "1";
            load_writeback_enable_reset <= "1";
         end if;
         if load_writeback_enable_reset = "1" then
            load_writeback_enable_buffer <= "0";
            load_writeback_enable_reset <= "0";
         end if;
         if load_writeback_enable_reset2 = "1" then
            load_writeback_enable_buffer2 <= "0";
         end if;
         if load_writeback_enable = "1" then
            load_writeback_enable_buffer <= "1";
         end if;
      end if;
      end process;
   Pc_update: process(clk)
   begin
      if rising_edge(clk) then
         if (sreset = "1") then
         pc <= "00000000000000000000000000000000";
      else
         if(last_pc_sel = pc_sel) then
            pc <= pc;
         else
            case pc_sel is
               when "000" =>
                  pc <= pc;
               when "001" =>                
                     pc <= pc+4;
               when "010" =>
                     pc <= std_logic_vector(pc+op2_bus);
               when "011" =>
                     pc <= std_logic_vector(pc+op2_bus);
               when "100" =>
                  if(branch_bool="1") then
                     if branch_type = "0" then
                        pc <= std_logic_vector(pc+branch_immediate);
                     else
                        pc <= std_logic_vector(pc+branch_bus);
                     end if;
                  else
                     pc <= pc + 4;
                  end if;
               when others =>
                  pc <= pc+4;
            end case;
         end if;
      end if;
      last_pc_sel <= pc_sel;
      end if;
   end process;
   Execution_Preperations: process(clk,rs1_data,rs2_data,op1_alt,op2_alt)
   begin
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
         if(store_enable = "1") then
            for i in 0 to 31 loop
               store_data(i) <= regs(conv_integer(rs2_data))(31-i);
            end loop;
         end if;
         if(load_byte_enable = "1") then
            load_byte_data <= regs(conv_integer(rs2_data))(31 downto 8);
         else
            load_byte_data <= load_byte_data;
         end if;
         if(load_half_enable = "1") then
            load_half_data <= regs(conv_integer(rs2_data))(31 downto 16);
         else
            load_half_data <= load_half_data;
         end if;
   end process;
   Final_Execution: process(clk)
   begin
      if rising_edge(clk) then
         if( execution_enable_reset = "1" or result_ready_execution = "1") then
            execution_enable_reset <= "0";
            result_ready_execution <= "0";
         end if;
         if(need_writeback_reset = "1") then
            need_writeback_reset <= "0";
            writeback_enable <= "0";
         end if;
         if(execution_enable_buffer = "1") then
            --branch exectuion
            if(execution_type="0") then
               case(branch_funct) is
                     when "000" =>
                        --HAVE TO FIX TIMINGS SO THAT it matches with the pc (pc will update before new fetch)
                        if(op1_bus = op2_bus) then
                           branch_type <= "0";
                           branch_bool <= "1";
                        else
                           branch_bool <= "0";
                        end if;
                     when "001" =>
                        if(op1_bus /= op2_bus) then
                           branch_type <= "0";
                           branch_bool <= "1";
                        else
                           branch_bool <= "0";
                        end if;
                     when "100" =>
                        if(op1_bus < op2_bus) then
                           branch_type <= "0";
                           branch_bool <= "1";
                        else
                           branch_bool <= "0";
                        end if;
                     when "101" =>
                        if(op1_bus >= op2_bus) then
                           branch_type <= "0";
                           branch_bool <= "1";
                        else
                           branch_bool <= "0"; 
                        end if;
                     when "110" =>
                        if(op1_bus < op2_bus) then
                           branch_type <= "1";
                           branch_bool <= "1";
                        else
                           branch_bool <= "0";
                        end if;
                     when "111" => --unsigned?
                        if(op1_bus >= op2_bus) then
                           branch_type <= "1";
                           branch_bool <= "1";
                        else
                           branch_bool <= "0";
                        end if;
                     when others =>
                        branch_bool <= "0";
                  end case;
               else 
                  case alu_ctrl is 
            --Hantera minus?
            when "000" => --add/sub
               if(alu_funct(0) = '0') then
                  alu_result<=std_logic_vector(op1_bus + op2_bus);
               else
                  alu_result<=std_logic_vector(op1_bus - op2_bus);
               end if;
            when "001" => --SLL
               alu_result <= to_stdlogicvector(to_bitvector(op1_bus) sll ieee.NUMERIC_STD.TO_INTEGER(ieee.NUMERIC_STD.signed(op2_bus))); 
            when "010" => --SLT
               if(op1_bus < op2_bus) then
                  alu_result <= (others => '0');
                  alu_result(0) <= '1';
               else
                  alu_result <= (others => '0');
               end if;
            when "011" => --STLU
               if(op1_bus < op2_bus) then
                  alu_result <= (others => '0');
                  alu_result(0) <= '1';
               else
                  alu_result <= (others => '0');
               end if;
            when "100" =>
               alu_result <= op1_bus xor op2_bus;
            when "101" =>
               -- SRL
               if (alu_funct(0) = '0') then
                  alu_result <= to_stdlogicvector(to_bitvector(op1_bus) srl ieee.NUMERIC_STD.TO_INTEGER(ieee.NUMERIC_STD.signed(op2_bus))); 
               -- SRA
               else      
                  alu_result <= to_stdlogicvector(to_bitvector(op1_bus) sra ieee.NUMERIC_STD.TO_INTEGER(ieee.NUMERIC_STD.signed(op2_bus))); 
               end if;
               
            when "110" =>
               alu_result <= op1_bus or op2_bus;
            when "111" =>
               alu_result <= op1_bus and op2_bus;
            when others =>
               alu_result <= "00000000000000000000000000000000"; 
         end case;
            end if;
            result_ready_execution <= "1";
            execution_enable_reset <= "1";
         end if;
         
         --Result select
         if(result_ready_reset = "1") then
            result_ready_reset <= "0";
         end if;
         if(result_ready_buffer = "1") then
            case result_select is
            when "000" =>
               result_bus <= lui_result;
            when "001" =>
               result_bus <= alu_result;
            when "010" =>
               result_bus <= std_logic_vector(op1_bus + op2_bus);
            when "011" =>
               result_bus <= pc + "00000000000000000000000000000100";
            when "100" =>
               result_bus <= load_result;
            when "111" =>
               result_bus <= result_bus;
            when others =>
               result_bus <= "00000000000000000000000000000000";
            end case;
            result_ready_reset <= "1";
            if(need_writeback_buffer = "1") then
               writeback_enable <= "1"; --Have to fix the writeback to the register
               need_writeback_reset <= "1";
            end if;
         end if;
      end if;
   end process;
   write_to_register: process(clk)
   begin
      if(rising_edge(clk)) then
         if(writeback_enable_reset="1") then
            writeback_enable_reset <= "0";
            load_writeback_enable_reset2 <= "0";
         end if;
         if(writeback_enable_buffer="1" or load_writeback_enable_buffer2="1") then
            regs(conv_integer(rd_data))<=result_bus;
            writeback_enable_reset <= "1";
            load_writeback_enable_reset2 <= "1";
         end if;
         if(sreset(0)='1') then
            for i in 0 to 31 loop
               regs(i)<="00000000000000000000000000000000";
            end loop;
         end if;
      end if;
   end process;
   
   reverse_pc: process(pc)
   begin
      for i in 0 to 31 loop
         reversed_pc(i) <= pc(31-i);
      end loop;
   end process;
   reverse_result_bus: process(result_bus)
   begin
      for i in 0 to 31 loop
         reversed_result_bus(i) <= result_bus(31-i);
      end loop;
   end process;
   parity_check: process(clk)
   begin
      if rising_edge(clk) then
         if(receiving = "1") then
            parity_addr <= parity_addr xor internal_addr;
         elsif transmitting = "1" then
            parity_data <= parity_data xor internal_m_data;
            parity_addr <= parity_addr xor internal_addr;
         end if;
         if(reset_parity = "1") then
            parity_data <= "00";
            parity_addr <= "00";
         end if;
         if(sreset = "1") then
            parity_data <= "00";
            parity_addr <= "00";
         end if;
      end if;
   end process;

   U0:CiscV_0 
      PORT MAP(clk,
               s_active,
               s_data,
               sreset,
               internal_addr,
               internal_m_data,
               rd_data,
               rs1_data,
               rs2_data,
               rs_sel,
               reversed_result_bus,
               op1_alt,
               op2_alt,
               imm5_data,
               imm7_data,
               imm12_data,
               imm20_data,
               shift_imm,
               load_byte_data,
               load_half_data,
               result_select,
               lui_result,
               alu_funct,
               pc_sel,
               branch_funct,
               branch_bus,
               J_immediate,
               S_immediate,
               L_immediate,
               shift_immediate,
               load_byte_enable,
               load_half_enable,
               load_result,
               store_data,
               store_enable,
               execution_enable,
               result_ready_decode,
               need_writeback,
               load_writeback_enable,
               alu_ctrl,
               pc,
               reversed_pc,
               send_clk,
               execution_type,
               parity_data,
               parity_addr,
               receiving,
               transmitting,
               reset_parity,
               com_enable,
               m_active);
END program;
