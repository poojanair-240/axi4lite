module axi_testbench;

    logic clk;
    logic reset_n;

    // AXI Interface Wires
    logic [31:0] awaddr, wdata, araddr;
    logic [7:0]  awlen, arlen;
    logic        awvalid, awready;
    logic [3:0]  wstrb;
    logic        wvalid, wready;
    logic        bvalid, bready;
    logic [31:0] rdata;
    logic        rvalid, rready;
    logic        arvalid, arready;

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset
    initial begin
        reset_n = 0;
        #20 reset_n = 1;
    end

    // DUT Instantiations
    axi_master master (
        .clk(clk), .reset_n(reset_n),
        .awaddr(awaddr), .awlen(awlen), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready),
        .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arlen(arlen), .arvalid(arvalid), .arready(arready),
        .rdata(rdata), .rvalid(rvalid), .rready(rready)
    );

    axi_slave slave (
        .clk(clk), .reset_n(reset_n),
        .awaddr(awaddr), .awlen(awlen), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready),
        .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arlen(arlen), .arvalid(arvalid), .arready(arready),
        .rdata(rdata), .rvalid(rvalid), .rready(rready)
    );

    // === Test Logic ===
    initial begin
        $dumpfile("axi_waveform.vcd");
        $dumpvars(0, axi_testbench);

        bready  = 0;
        rready  = 0;

        wait (reset_n);

        #10 bready = 1;
        #10 rready = 1;

        #500 $finish;
    end

endmodule
