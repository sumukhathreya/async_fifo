//
// Asynchronous FIFO Memory Module
//
module fifo_memory #(
  parameter DATA_WIDTH = 8,  // Width of the data
  parameter DEPTH = 16       // Depth of the FIFO memory
)(
  input wire write_enable, fifo_full, write_clock,
  input wire [$clog2(DEPTH)-1:0] write_address, read_address,
  input wire [DATA_WIDTH-1:0] write_data,
  output wire [DATA_WIDTH-1:0] read_data
);

  // Internal memory array
  reg [DATA_WIDTH-1:0] mem_array [DEPTH-1:0];
  
  // Read operation: feed-through read
  assign read_data = mem_array[read_address];

  // Write operation: only if FIFO is not full and write is enabled
  always @(posedge write_clock)
    if (write_enable && !fifo_full)
      mem_array[write_address] <= write_data;

endmodule
