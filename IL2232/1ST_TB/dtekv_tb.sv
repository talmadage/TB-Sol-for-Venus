`timescale 1ns/1ps

module dtekv_tb(
    input  logic clk,
    input  logic reset,

    // ===== Instruction port =====
    input  logic [31:0] avm_instr_read_adr, 
    output logic [31:0] avm_instr_read_data, 
    input  logic        avm_instr_read,
    output logic        avm_instr_read_waitreq,

    // ===== Control slave =====
    output logic [7:0]  avm_ctrl_slave_data,
    output logic        avm_ctrl_slave_write,
    input  logic        avm_ctrl_slave_waitreq,

    // ===== Data port =====
    input  logic [31:0] avm_data_adr,
    input  logic        avm_data_read,
    input  logic        avm_data_write,
    output logic [31:0] avm_data_read_data,
    input  logic [31:0] avm_data_write_data,
    input  logic [3:0]  avm_data_write_byten,
    output logic        avm_data_waitreq,

    // ===== Debug =====
    input  logic [31:0] debug_pc,
    input  logic [31:0] debug_instr,
    input  logic        debug_regwrite,
    input  logic [4:0]  debug_regaddr,
    input  logic [31:0] debug_regvalue
);


    // Parameters and Memories
    localparam INSTR_MEM_SIZE = 4096;
    localparam DATA_MEM_SIZE  = 4096;

    logic [31:0] instr_mem [0:INSTR_MEM_SIZE-1];
    logic [31:0] data_mem  [0:DATA_MEM_SIZE-1];

    logic [31:0] instr_rdata;
    logic [31:0] data_rdata;

    integer log_fh;

    // ---- Variables for binary file reading ----
    integer fin;
    int     nread;
    int     idx;
    logic [7:0] b0, b1, b2, b3;


    // 1) initial
    initial begin
        // fill with NOPs
        for (int i = 0; i < INSTR_MEM_SIZE; i++) instr_mem[i] = 32'h00000013;
        for (int i = 0; i < DATA_MEM_SIZE;  i++) data_mem[i]  = 32'h0;

        // open binary file
        fin = $fopen("E:/IL2232/riscv_tb/instr_mem.bin", "rb");
        if (fin == 0) begin
            $display("[TB][ERROR] cannot open binary file, keep NOPs");
        end
        else begin
            $display("[TB] opened binary file, start fread ...");

            idx = 0;
            while (!$feof(fin) && idx < INSTR_MEM_SIZE) begin
                nread = $fread(b0, fin);
                if (nread != 1) break;
                nread = $fread(b1, fin);
                if (nread != 1) break;
                nread = $fread(b2, fin);
                if (nread != 1) break;
                nread = $fread(b3, fin);
                if (nread != 1) break;

                //Little Endian
                instr_mem[idx] = {b3, b2, b1, b0};
                idx++;
            end

            $fclose(fin);
            $display("[TB] fread done, loaded %0d words", idx);
        end


        // Open log
        log_fh = $fopen("riscv_log.txt", "w");
        if (!log_fh)
            $display("[TB][ERROR] cannot open riscv_log.txt");
        else
            $fwrite(log_fh, "==== RISC-V execution log ====\n");
    end

    // 2) initial CPU
    logic [3:0] boot_cnt;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            boot_cnt            <= 4'd0;
            avm_ctrl_slave_data <= 8'h00;
            avm_ctrl_slave_write<= 1'b0;
        end else begin
            if (boot_cnt < 4'd8)
                boot_cnt <= boot_cnt + 4'd1;

            if (boot_cnt == 4'd7) begin
                avm_ctrl_slave_data  <= 8'hF0;
                avm_ctrl_slave_write <= 1'b1;
            end else begin
                avm_ctrl_slave_data  <= 8'h00;
                avm_ctrl_slave_write <= 1'b0;
            end
        end
    end

    // 3) instr
    assign avm_instr_read_waitreq = 1'b0;

    always @(posedge clk) begin
        if (avm_instr_read)
            instr_rdata <= instr_mem[avm_instr_read_adr >> 2];
    end

    assign avm_instr_read_data = instr_rdata;

    // 4) data
    assign avm_data_waitreq = 1'b0;

    always @(posedge clk) begin
        if (avm_data_read)
            data_rdata <= data_mem[avm_data_adr >> 2];
        if (avm_data_write) begin
            for (int i = 0; i < 4; i++) begin
                if (avm_data_write_byten[i])
                    data_mem[avm_data_adr >> 2][8*i +: 8] <= avm_data_write_data[8*i +: 8];
            end
        end
    end

    assign avm_data_read_data = data_rdata;

    // 5) debug log
    always @(posedge clk) begin
        if (!reset) begin
            if (debug_regwrite) begin
                if (log_fh)
                    $fwrite(log_fh, "PC=%08h INSTR=%08h REG[%0d]=%08h\n",
                            debug_pc, debug_instr, debug_regaddr, debug_regvalue);
                else
                    $display("PC=%08h INSTR=%08h REG[%0d]=%08h",
                             debug_pc, debug_instr, debug_regaddr, debug_regvalue);
            end
        end
    end

endmodule
