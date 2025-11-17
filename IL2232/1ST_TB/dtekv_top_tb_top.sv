`timescale 1ns/1ps

module dtekv_top_tb_top;

    // ---------------- clock & reset ----------------
    logic clk;
    logic reset;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #40;
        reset = 1'b0;
    end

    always #5 clk = ~clk;

    // ---------------- wires between DUT and TB ----------------
    logic [31:0] avm_instr_read_adr;
    logic [31:0] avm_instr_read_data;
    logic        avm_instr_read;
    logic        avm_instr_read_waitreq;

    logic [7:0]  avm_ctrl_slave_data;
    logic        avm_ctrl_slave_write;
    logic        avm_ctrl_slave_waitreq;

    logic [31:0] avm_data_adr;
    logic        avm_data_read;
    logic        avm_data_write;
    logic [31:0] avm_data_read_data;
    logic [31:0] avm_data_write_data;
    logic [3:0]  avm_data_write_byten;
    logic        avm_data_waitreq;

    logic [31:0] debug_pc;
    logic [31:0] debug_instr;
    logic        debug_regwrite;
    logic [4:0]  debug_regaddr;
    logic [31:0] debug_regvalue;

    logic tb_simulation_done;

    initial begin
        wait (tb_simulation_done == 1'b1); 
        #100;

        $display("Testbench simulation complete. Stopping simulation.");
        $stop; // 停止仿真
    end

    // ---------------- DUT ----------------
    dtekv_top u_dtekv_top (
        .clk                    (clk),
        .reset                  (reset),

        .avm_instr_read_adr     (avm_instr_read_adr),
        .avm_instr_read_data    (avm_instr_read_data),
        .avm_instr_read         (avm_instr_read),
        .avm_instr_read_waitreq (avm_instr_read_waitreq),

        .avm_ctrl_slave_data    (avm_ctrl_slave_data),
        .avm_ctrl_slave_write   (avm_ctrl_slave_write),
        .avm_ctrl_slave_waitreq (avm_ctrl_slave_waitreq),

        .avm_data_adr           (avm_data_adr),
        .avm_data_read          (avm_data_read),
        .avm_data_write         (avm_data_write),
        .avm_data_read_data     (avm_data_read_data),
        .avm_data_write_data    (avm_data_write_data),
        .avm_data_write_byten   (avm_data_write_byten),
        .avm_data_waitreq       (avm_data_waitreq),

        .debug_pc               (debug_pc),
        .debug_instr            (debug_instr),
        .debug_regwrite         (debug_regwrite),
        .debug_regaddr          (debug_regaddr),
        .debug_regvalue         (debug_regvalue)
    );

    // ---------------- TB ----------------
    dtekv_tb u_tb (
        .clk                    (clk),
        .reset                  (reset),

        .avm_instr_read_adr     (avm_instr_read_adr),
        .avm_instr_read_data    (avm_instr_read_data),
        .avm_instr_read         (avm_instr_read),
        .avm_instr_read_waitreq (avm_instr_read_waitreq),

        .avm_ctrl_slave_data    (avm_ctrl_slave_data),
        .avm_ctrl_slave_write   (avm_ctrl_slave_write),
        .avm_ctrl_slave_waitreq (avm_ctrl_slave_waitreq),

        .avm_data_adr           (avm_data_adr),
        .avm_data_read          (avm_data_read),
        .avm_data_write         (avm_data_write),
        .avm_data_read_data     (avm_data_read_data),
        .avm_data_write_data    (avm_data_write_data),
        .avm_data_write_byten   (avm_data_write_byten),
        .avm_data_waitreq       (avm_data_waitreq),

        .debug_pc               (debug_pc),
        .debug_instr            (debug_instr),
        .debug_regwrite         (debug_regwrite),
        .debug_regaddr          (debug_regaddr),
        .debug_regvalue         (debug_regvalue),
        .simulation_done        (tb_simulation_done)
    );

endmodule
