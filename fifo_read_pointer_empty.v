//
// Read Pointer and Empty Flag Controller for Asynchronous FIFO
//
module fifo_read_pointer_empty #(
  parameter DEPTH = 16
)(
  input wire read_enable, read_clock, read_reset_n,
  input wire [$clog2(DEPTH):0] sync_write_pointer,
  output reg fifo_empty,
  output wire [$clog2(DEPTH)-1:0] read_address,
  output reg [$clog2(DEPTH):0] read_pointer
);

  reg [$clog2(DEPTH):0] binary_read_pointer;
  wire [$clog2(DEPTH):0] next_binary_read_pointer, next_gray_read_pointer;

  // GRAYSTYLE2 pointer update logic
  always @(posedge read_clock or negedge read_reset_n)
    if (!read_reset_n)
      {binary_read_pointer, read_pointer} <= 0;
    else
      {binary_read_pointer, read_pointer} <= {next_binary_read_pointer, next_gray_read_pointer};

  // Memory read address pointer (binary)
  assign read_address = binary_read_pointer[$clog2(DEPTH)-1:0];
  assign next_binary_read_pointer = binary_read_pointer + (read_enable & ~fifo_empty);
  assign next_gray_read_pointer = (next_binary_read_pointer >> 1) ^ next_binary_read_pointer;

  // FIFO empty flag logic
  assign fifo_empty_condition = (next_gray_read_pointer == sync_write_pointer);

  always @(posedge read_clock or negedge read_reset_n)
    if (!read_reset_n)
      fifo_empty <= 1'b1;
    else
      fifo_empty <= fifo_empty_condition;

endmodule
