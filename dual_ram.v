// Code your design here
module ram_dp_sync
#(
    parameter WIDTH = 8,
    parameter DEPTH = 64,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)
(
    input  wire                   clk,

    // Write port
    input  wire                   we,
    input  wire [ADDR_WIDTH-1:0]  addr_wr,
    input  wire [WIDTH-1:0]       data_in,

    // Read port
    input  wire                   re,
    input  wire [ADDR_WIDTH-1:0]  addr_rd,
    output reg  [WIDTH-1:0]       data_out
);

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        // Write operation
        if (we)
            mem[addr_wr] <= data_in;

        // Read operation (synchronous)
        if (re)
            data_out <= mem[addr_rd];
    end

endmodule