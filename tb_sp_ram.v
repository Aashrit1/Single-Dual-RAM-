`timescale 1ns/1ps

module tb_ram_sp_sync_read;

    localparam WIDTH = 8;
    localparam DEPTH = 16;

    reg clk = 0;
    reg [WIDTH-1:0] data_in;
    reg [3:0] address;
    reg write_en;
    wire [WIDTH-1:0] data_out;

    integer i;
    integer success = 0;
    integer errors = 0;

    // Golden reference memory
    reg [WIDTH-1:0] golden_mem [0:DEPTH-1];

    // Instantiate DUT
    ram_sp_sync_read DUT (
        .clk(clk),
        .data_in(data_in),
        .address(address),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;
    initial begin
        $dumpfile("ram_sp_wave.vcd");       // waveform file
        $dumpvars(0, tb_ram_sp_sync_read);  // dump all signals
    end

    // Write Task
    task write(input [3:0] addr, input [7:0] data);
    begin
        @(posedge clk);
        write_en = 1;
        address  = addr;
        data_in  = data;
        golden_mem[addr] = data;
    end
    endtask

    // Read Task
    task read(input [3:0] addr);
    begin
        @(posedge clk);
        write_en = 0;
        address  = addr;

        @(posedge clk); // Wait for registered output

        if (data_out === golden_mem[addr]) begin
            $display("PASS: Addr=%0d Data=%0h", addr, data_out);
            success = success + 1;
        end
        else begin
            $display("FAIL: Addr=%0d Expected=%0h Got=%0h",
                     addr, golden_mem[addr], data_out);
            errors = errors + 1;
        end
    end
    endtask


    initial begin

        write_en = 0;
        address  = 0;
        data_in  = 0;

        // 1️⃣ Basic Write & Read
        write(3, 8'hAA);
        read(3);

        write(0, 8'h11);
        read(0);

        write(15, 8'hFF);
        read(15);
        write(5, 8'h22);
        write(5, 8'h33);
        read(5);

        for (i = 0; i < 20; i = i + 1)
            write($random % DEPTH, $random);

        for (i = 0; i < DEPTH; i = i + 1)
            read(i);

        $display("================================");
        $display("TOTAL SUCCESS = %0d", success);
        $display("TOTAL ERRORS  = %0d", errors);
        $display("================================");

        #20 $finish;
    end

endmodule