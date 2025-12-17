module avm_interface (

    // ===== Simple parallel communication =====
    input  logic        clk,
    input  logic [31:0] data_addr,
    input  logic        we,
    output logic [31:0] data4mem,
    input  logic [31:0] data2mem,
    output logic [31:0] data4io,
    input  logic [31:0] data2io,

    // ===== Avalon interface =====

    // Instruction port
    output logic [31:0] avm_instr_read_adr,
    output logic        avm_instr_read,
    input  logic [31:0] avm_instr_read_data,
    input  logic        avm_instr_read_waitreq,

    // Control slave
    input  logic [7:0]  avm_ctrl_slave_data,
    input  logic        avm_ctrl_slave_write,
    output logic        avm_ctrl_slave_waitreq,

    // Data port
    output logic [31:0] avm_data_adr,
    output logic        avm_data_read,
    output logic        avm_data_write,
    output logic [31:0] avm_data_write_data,
    output logic [3:0]  avm_data_write_byten,
    input  logic [31:0] avm_data_read_data,
    input  logic        avm_data_waitreq
);

    // =====================================================
    // Defaults (combinational, zero-waitstate slave)
    // =====================================================

    assign avm_ctrl_slave_waitreq = 1'b0;
    assign avm_data_write_byten   = 4'b1111;

    // =====================================================
    // Instruction fetch path
    // =====================================================

    assign avm_instr_read     = 1'b1;          // CPU always fetches
    assign avm_instr_read_adr = data_addr;     // reuse address

    // =====================================================
    // Data path (read / write)
    // =====================================================

    assign avm_data_adr        = data_addr;
    assign avm_data_write_data = data2mem;

    assign avm_data_write = we;
    assign avm_data_read  = ~we;

    // =====================================================
    // Return data to bs_interface
    // =====================================================

    always_ff @(posedge clk) begin
        if (!we) begin
            if (data_addr[31] == 1'b1)
                data4io  <= avm_data_read_data;
            else
                data4mem <= avm_data_read_data;
        end
    end

endmodule
