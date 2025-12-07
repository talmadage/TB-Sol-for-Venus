module instr_counter_7seg #(
    // Every 2^SCALE_BITS retired instructions, the displayed value increments by 1.
    // Example: SCALE_BITS = 23 → about 8.4M instructions per step.
    parameter int SCALE_BITS = 23
)(
    input  logic       clk,
    input  logic       reset_n,   // active-low reset

    // From TB control interface: used to detect the "start CPU" command (0xF0)
    input  logic       avm_ctrl_slave_write,
    input  logic [7:0] avm_ctrl_slave_data,

    // From TB instruction fetch interface
    input  logic       avm_instr_read,
    input  logic       avm_instr_read_waitreq,

    // Outputs to the two seven-segment displays on the add-on board
    output logic [6:0] seg1,      // display #1, gfedcba
    output logic       dp1,       // decimal point for display #1
    output logic [6:0] seg2,      // display #2, gfedcba
    output logic       dp2        // decimal point for display #2
);

    // 32-bit instruction counter (internal, not displayed directly)
    logic [31:0] instr_count;

    // Scaling accumulator and displayed counter
    logic [SCALE_BITS-1:0] scale_cnt;
    logic [7:0]            disp_cnt;   // 2 hex digits (wraps at 0xFF)

    // Currently displayed nibbles
    logic [3:0] digit_lo;
    logic [3:0] digit_hi;

    // Flag: CPU is running after start command
    logic running;

    // Main counting logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            running      <= 1'b0;
            instr_count  <= '0;
            scale_cnt    <= '0;
            disp_cnt     <= '0;
        end
        else begin
            // Detect start command from TB (write 0xF0 on control slave)
            if (avm_ctrl_slave_write && avm_ctrl_slave_data == 8'hF0) begin
                running      <= 1'b1;
                instr_count  <= '0;
                scale_cnt    <= '0;
                disp_cnt     <= '0;
            end

            if (running) begin
                // Count one instruction when fetch handshake succeeds
                if (avm_instr_read && !avm_instr_read_waitreq) begin
                    instr_count <= instr_count + 32'd1;

                    // Scaling: every 2^SCALE_BITS instructions, disp_cnt++
                    scale_cnt <= scale_cnt + {{(SCALE_BITS-1){1'b0}}, 1'b1};
                    if (&scale_cnt) begin           // all bits were '1' → overflow
                        scale_cnt <= '0;
                        disp_cnt  <= disp_cnt + 8'd1;
                    end
                end
            end
        end
    end

    // Split display counter into two hex digits
    assign digit_lo = disp_cnt[3:0];
    assign digit_hi = disp_cnt[7:4];

    // Decimal points off (0 = off for common-cathode wired active-high)
    assign dp1 = 1'b0;
    assign dp2 = 1'b0;

    // Drive the two seven-seg displays
    hex_to_7seg u_7seg_lo (
        .value (digit_lo),
        .seg   (seg1)
    );

    hex_to_7seg u_7seg_hi (
        .value (digit_hi),
        .seg   (seg2)
    );

endmodule
