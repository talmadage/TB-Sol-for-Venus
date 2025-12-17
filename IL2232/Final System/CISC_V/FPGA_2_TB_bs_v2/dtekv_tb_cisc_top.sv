`timescale 1ns/1ps

module dtekv_tb_cisc_top (

    // Global clock and reset
    input  logic CLOCK_50,
    input  logic RESET_N,

    // Optional: Seven-segment display outputs
    output logic [6:0] SEG1,
    output logic       SEG1_DP,
    output logic [6:0] SEG2,
    output logic       SEG2_DP
);

    // ============================================================
    // SERIAL LINK SIGNALS (internal wires between CPU and TB)
    // ============================================================

    logic        com_enable;
    logic        m_active;
    logic [1:0]  addr;
    logic [1:0]  m_data;
    logic        s_active;
    logic [1:0]  s_data;

    // ============================================================
    // FPGA1 — CiscV CPU
    // ============================================================

    CiscV u_cpu (
        .clk        (CLOCK_50),
        .s_active   ({s_active}),
        .s_data     (s_data),
        .sreset     ({~RESET_N}),     // CPU expects active-high reset
        .com_enable ({com_enable}),
        .m_active   ({m_active}),
        .addr       (addr),
        .m_data     (m_data),
        .clk_out    ()                // unused internal clock
    );

    // ============================================================
    // FPGA2 — Testbench Processor + Serializer
    // ============================================================

    dtekv_fpga2_top u_fpga2 (
        .CLOCK_50 (CLOCK_50),
        .RESET_N  (RESET_N),

        // SERIAL WIRES (cross-connected)
        .com_enable (com_enable),
        .m_active   (m_active),
        .tx_data    (m_data),     // CiscV → TB
        .addr       (addr),
        .s_active   (s_active),   // TB → CiscV
        .rx_data    (s_data),

        // Displays
        .SEG1     (SEG1),
        .SEG1_DP  (SEG1_DP),
        .SEG2     (SEG2),
        .SEG2_DP  (SEG2_DP)
    );

endmodule
