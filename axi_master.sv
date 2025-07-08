module axi_master (
    input  logic        clk,
    input  logic        reset_n,

    output logic [31:0] awaddr,
    output logic [7:0]  awlen,
    output logic        awvalid,
    input  logic        awready,

    output logic [31:0] wdata,
    output logic [3:0]  wstrb,
    output logic        wvalid,
    input  logic        wready,

    input  logic        bvalid,
    output logic        bready,

    output logic [31:0] araddr,
    output logic [7:0]  arlen,
    output logic        arvalid,
    input  logic        arready,

    input  logic [31:0] rdata,
    input  logic        rvalid,
    output logic        rready
);

    typedef enum logic [1:0] {
        IDLE, WRITE, READ
    } state_t;

    state_t state;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state    <= IDLE;
            awvalid  <= 0;
            wvalid   <= 0;
            bready   <= 0;
            arvalid  <= 0;
            rready   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    awvalid <= 1;
                    awaddr  <= 32'h0000_0000;
                    awlen   <= 8'd0;
                    if (awready) state <= WRITE;
                end

                WRITE: begin
                    wvalid <= 1;
                    wdata  <= 32'h1234_5678;
                    wstrb  <= 4'b1111;
                    if (wready) begin
                        bready <= 1;
                        state  <= READ;
                    end
                end

                READ: begin
                    arvalid <= 1;
                    araddr  <= 32'h0000_0000;
                    arlen   <= 8'd0;
                    if (arready) begin
                        rready <= 1;
                        if (rvalid)
                            state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
