`timescale 1ns/1ps

module ram_sp_sync_read
#(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)
(
    input  wire                   clk,
    input  wire [WIDTH-1:0]       data_in,
    input  wire [ADDR_WIDTH-1:0]  address,
    input  wire                   write_en,
    output wire [WIDTH-1:0]       data_out
);

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Address buffer (for synchronous read)
    reg [ADDR_WIDTH-1:0] addr_buff;

    // Synchronous write + address buffering
    always @(posedge clk) begin
        if (write_en)
            mem[address] <= data_in;

        addr_buff <= address;   // register address
    end

    // Synchronous read (via registered address)
    assign data_out = mem[addr_buff];

endmodule