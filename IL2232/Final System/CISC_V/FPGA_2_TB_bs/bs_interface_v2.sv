module bs_interface_v2 (

    // ============================
    // Serial communication (FPGA2)
    // ============================
    input  logic        clk,
    input  logic        com_enable,
    input  logic        m_active,
    input  logic [1:0]  tx_data,
    input  logic [1:0]  addr,
    output logic        s_active,
    output logic [1:0]  rx_data,

    // ============================
    // Parallel Avalon interface (TB)
    // ============================

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

    // ===========================================
    // Internal registers
    // ===========================================
    typedef enum logic [2:0] {
        ST_IDLE,
        ST_RECV_ADDR,
        ST_RECV_DATA,
        ST_WRITE,
        ST_READ,
        ST_SEND_DATA
    } fsm_t;

    fsm_t state = ST_IDLE;

    logic [31:0] shift_reg;
    logic [5:0]  bit_cnt;
    logic [31:0] read_buffer;
    logic        is_read;     // 1=read, 0=write

    // Outputs defaults
    initial begin
        avm_instr_read       = 0;
        avm_instr_read_adr   = 0;
        avm_data_read        = 0;
        avm_data_write       = 0;
        avm_data_write_data  = 0;
        avm_data_write_byten = 4'b1111;
        avm_ctrl_slave_waitreq = 0;
        s_active = 0;
    end


    // ===========================================
    // MAIN FSM
    // ===========================================
    always_ff @(posedge clk) begin

        // ---------------------------------------
        // ST_IDLE : Wait for communication start
        // ---------------------------------------
        if (state == ST_IDLE) begin
            s_active   <= 0;
            bit_cnt    <= 0;
            shift_reg  <= 0;
            is_read    <= 0;

            if (com_enable && m_active) begin
                if (addr == 2'b10)              // read request
                    is_read <= 1;
                else                             // write request
                    is_read <= 0;

                state <= ST_RECV_ADDR;
            end
        end

        // ---------------------------------------
        // ST_RECV_ADDR : receive 32-bit address
        // ---------------------------------------
        else if (state == ST_RECV_ADDR) begin
            shift_reg <= {shift_reg[29:0], tx_data}; // shift 2 bits
            bit_cnt   <= bit_cnt + 2;

            if (bit_cnt == 30) begin
                if (is_read)
                    state <= ST_READ;
                else
                    state <= ST_RECV_DATA;

                bit_cnt <= 0;
            end
        end

        // ---------------------------------------
        // ST_RECV_DATA : receive 32-bit write data
        // ---------------------------------------
        else if (state == ST_RECV_DATA) begin
            shift_reg <= {shift_reg[29:0], tx_data};
            bit_cnt   <= bit_cnt + 2;

            if (bit_cnt == 30) begin
                state <= ST_WRITE;
            end
        end

        // ---------------------------------------
        // ST_WRITE : Perform Avalon write
        // ---------------------------------------
        else if (state == ST_WRITE) begin
            avm_data_adr        <= shift_reg;  // address
            avm_data_write_data <= shift_reg;  // data
            avm_data_write      <= 1;

            state <= ST_IDLE;
        end

        // ---------------------------------------
        // ST_READ : request Avalon read
        // ---------------------------------------
        else if (state == ST_READ) begin
            avm_data_adr  <= shift_reg;
            avm_data_read <= 1;

            read_buffer <= avm_data_read_data; // latch data
            state       <= ST_SEND_DATA;
            bit_cnt     <= 0;
        end

        // ---------------------------------------
        // ST_SEND_DATA : send 32 bits back serially
        // ---------------------------------------
        else if (state == ST_SEND_DATA) begin
            s_active <= 1;

            rx_data <= read_buffer[31:30];
            read_buffer <= {read_buffer[29:0], 2'b00};
            bit_cnt <= bit_cnt + 2;

            if (bit_cnt == 32) begin
                state   <= ST_IDLE;
                s_active <= 0;
            end
        end

    end

endmodule
