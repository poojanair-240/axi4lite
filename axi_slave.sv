module axi_slave (
    input  logic        clk,
    input  logic        reset_n,

    input  logic [31:0] awaddr,
    input  logic [7:0]  awlen,
    input  logic        awvalid,
    output logic        awready,

    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    input  logic        wvalid,
    output logic        wready,

    output logic        bvalid,
    input  logic        bready,

    input  logic [31:0] araddr,
    input  logic [7:0]  arlen,
    input  logic        arvalid,
    output logic        arready,

    output logic [31:0] rdata,
    output logic        rvalid,
    input  logic        rready
);

    logic [31:0] memory [0:255];

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            arready <= 0;
            rvalid  <= 0;
            rdata   <= 0;
        end else begin
            // Write Address Channel
            if (awvalid && !awready)
                awready <= 1;

            // Write Data Channel
            if (wvalid && awready && !wready) begin
                memory[awaddr[9:2]] <= wdata;  // word aligned
                wready  <= 1;
                bvalid  <= 1;
            end

            // Write Response Channel
            if (bvalid && bready) begin
                bvalid  <= 0;
                awready <= 0;
                wready  <= 0;
            end

            // Read Address Channel
            if (arvalid && !arready) begin
                arready <= 1;
                rdata   <= memory[araddr[9:2]]; // word aligned
                rvalid  <= 1;
            end

            // Read Data Channel
            if (rvalid && rready) begin
                rvalid  <= 0;
                arready <= 0;
            end
        end
    end
endmodule
