`timescale 1ns/1ps

module dtekv_top_tb_top (
    // Board clock and reset
    input  logic       CLOCK_50,   // 50 MHz clock from DE0-Nano-SoC
    input  logic       RESET_N,    // active-low reset from button/switch

    // Seven-seg #1 (A..G, DP) on add-on board
    output logic [6:0] SEG1,       // gfedcba
    output logic       SEG1_DP,

    // Seven-seg #2 (A..G, DP) on add-on board
    output logic [6:0] SEG2,       // gfedcba
    output logic       SEG2_DP
);


    //  Clock and reset wiring

    logic clk;
    logic reset_n;
    logic reset;   // active-high version for VHDL core

    assign clk     = CLOCK_50;
    assign reset_n = ~RESET_N;
    assign reset   = RESET_N;   // most VHDL designs use active-high reset


    //  CPU <-> TB Avalon-style signals

    // Instruction port
    logic [31:0] avm_instr_read_adr;
    logic [31:0] avm_instr_read_data;
    logic        avm_instr_read;
    logic        avm_instr_read_waitreq;

    // Control slave
    logic [7:0]  avm_ctrl_slave_data;
    logic        avm_ctrl_slave_write;
    logic        avm_ctrl_slave_waitreq;

    // Data port
    logic [31:0] avm_data_adr;
    logic        avm_data_read;
    logic        avm_data_write;
    logic [31:0] avm_data_read_data;
    logic [31:0] avm_data_write_data;
    logic [3:0]  avm_data_write_byten;
    logic        avm_data_waitreq;



    //  DUT: RISC-V core (VHDL) - dtekv_top_nocache
    dtekv_top u_cpu (
        .clk                    (clk),
        .reset                  (reset),

        // Debug info from CPU (not used in this FPGA build)
        .debug_pc               (), 
        .debug_instr            (),   
        .debug_regwrite         (),   
        .debug_regaddr          (),     
        .debug_regvalue         (),       

        // Instruction port
        .avm_instr_read_adr     (avm_instr_read_adr),
        .avm_instr_read_data    (avm_instr_read_data),
        .avm_instr_read         (avm_instr_read),
        .avm_instr_read_waitreq (avm_instr_read_waitreq),

        // Control slave
        .avm_ctrl_slave_data    (avm_ctrl_slave_data),
        .avm_ctrl_slave_write   (avm_ctrl_slave_write),
        .avm_ctrl_slave_waitreq (avm_ctrl_slave_waitreq),

        // Data port
        .avm_data_adr           (avm_data_adr),
        .avm_data_read          (avm_data_read),
        .avm_data_write         (avm_data_write),
        .avm_data_read_data     (avm_data_read_data),
        .avm_data_write_data    (avm_data_write_data),
        .avm_data_write_byten   (avm_data_write_byten),
        .avm_data_waitreq       (avm_data_waitreq)
    );

    //  Testbench logic on FPGA (memory + start pulse)

    dtekv_tb u_tb (
        .clk                    (clk),
        .reset_n                (reset_n),

        // Instruction port
        .avm_instr_read_adr     (avm_instr_read_adr),
        .avm_instr_read         (avm_instr_read),
        .avm_instr_read_data    (avm_instr_read_data),
        .avm_instr_read_waitreq (avm_instr_read_waitreq),

        // Control slave
        .avm_ctrl_slave_data    (avm_ctrl_slave_data),
        .avm_ctrl_slave_write   (avm_ctrl_slave_write),
        .avm_ctrl_slave_waitreq (avm_ctrl_slave_waitreq),

        // Data port
        .avm_data_adr           (avm_data_adr),
        .avm_data_read          (avm_data_read),
        .avm_data_write         (avm_data_write),
        .avm_data_write_data    (avm_data_write_data),
        .avm_data_write_byten   (avm_data_write_byten),
        .avm_data_read_data     (avm_data_read_data),
        .avm_data_waitreq       (avm_data_waitreq)
    );


    //  Instruction counter driving two seven-seg displays
    //  - Uses avm_ctrl_slave_* to detect start (0xF0)
    //  - Uses avm_instr_* handshake to count executed instructions
    //  - Implementation is in instr_counter_7seg.sv (already provided)


    instr_counter_7seg #(
        .SCALE_BITS(23)  // adjust scaling if needed
    ) u_instr_counter_7seg (
        .clk                    (clk),
        .reset_n                (reset_n),
        .avm_ctrl_slave_write   (avm_ctrl_slave_write),
        .avm_ctrl_slave_data    (avm_ctrl_slave_data),
        .avm_instr_read         (avm_instr_read),
        .avm_instr_read_waitreq (avm_instr_read_waitreq),
        .seg1                   (SEG2),
        .dp1                    (SEG2_DP),
        .seg2                   (SEG1),
        .dp2                    (SEG1_DP)
    );

endmodule