module avm_interface (

    // ===== Simple parallel communication (from bs_interface) =====
    input  logic        clk,
    input  logic [31:0] data_addr,
    input  logic        we,              // 1 = write, 0 = read
    output logic [31:0] data4mem,         // data returned to bs_interface
    input  logic [31:0] data2mem,         // data from bs_interface (write)
    output logic [31:0] data4io,
    input  logic [31:0] data2io,

    // ===== Avalon interface =====

    // Instruction port
    output logic [31:0] avm_instr_read_adr,
    output logic        avm_instr_read,
    input  logic [31:0] avm_instr_read_data,
    input  logic        avm_instr_read_waitreq,

    // Control slave (unused for now)
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
    // Constants / address decoding
    // =====================================================
    // MSB = 0 -> memory
    // MSB = 1 -> IO
    localparam IO_BIT = 31;

    // =====================================================
    // Simple Avalon defaults
    // =====================================================
    assign avm_ctrl_slave_waitreq = 1'b0;
    assign avm_data_write_byten   = 4'b1111;

    // =====================================================
    // Instruction fetch (READ ONLY)
    // =====================================================
    assign avm_instr_read     = ~we;          // fetch when CPU is reading
    assign avm_instr_read_adr = data_addr;

    // =====================================================
    // Data port control
    // =====================================================
    assign avm_data_adr        = data_addr;
    assign avm_data_write_data = data2mem;

    assign avm_data_write = we;
    assign avm_data_read  = ~we;

    // =====================================================
    // Return path to bs_interface
    // =====================================================
    always_ff @(posedge clk) begin

        // -------- Instruction fetch --------
        if (!we && !avm_instr_read_waitreq) begin
            data4mem <= avm_instr_read_data;
        end

        // -------- Data read --------
        if (!we && !avm_data_waitreq) begin
            if (data_addr[IO_BIT])
                data4io  <= avm_data_read_data;
            else
                data4mem <= avm_data_read_data;
        end
    end

endmodule
