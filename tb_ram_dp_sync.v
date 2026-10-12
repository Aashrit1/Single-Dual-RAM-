`timescale 1ns/1ps

module tb_ram_dp_sync;

    parameter WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = $clog2(DEPTH);

    reg clk;
    reg we, re;
    reg [ADDR_WIDTH-1:0] addr_wr, addr_rd;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;

    // Instantiate DUT
    ram_dp_sync #(WIDTH, DEPTH) dut (
        .clk(clk),
        .we(we),
        .addr_wr(addr_wr),
        .data_in(data_in),
        .re(re),
        .addr_rd(addr_rd),
        .data_out(data_out)
    );

    // Clock (10ns period)
    always #5 clk = ~clk;
    initial begin
        $dumpfile("ram_wave.vcd");      // VCD file name
        $dumpvars(0, tb_ram_dp_sync);   // Dump all signals
    end
    initial begin
        clk = 0;
        we = 0;
        re = 0;
        addr_wr = 0;
        addr_rd = 0;
        data_in = 0;

        // Wait a little
        #10;

        // Write A5 to address 2
        @(posedge clk);
        we = 1;
        addr_wr = 4'd2;
        data_in = 8'hA5;

        re = 1;              // Read simultaneously
        addr_rd = 4'd0;

        @(posedge clk);
        we = 0;

        // Read address 2
        @(posedge clk);
        addr_rd = 4'd2;

        @(posedge clk);

        // Write 3C to address 5 while reading 2
        @(posedge clk);
        we = 1;
        addr_wr = 4'd5;
        data_in = 8'h3C;
        addr_rd = 4'd2;

        @(posedge clk);
        we = 0;

        // Read address 5
        @(posedge clk);
        addr_rd = 4'd5;

        @(posedge clk);

        #20;
        $finish;
    end

endmodule