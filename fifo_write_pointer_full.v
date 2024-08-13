//
// FIFO Write Pointer and Full Flag Module
//
// This module manages the write pointer and determines if the FIFO is full.
//

module fifo_write_pointer_full
(
  input                   write_enable,   // Write enable signal
  input                   write_clock,      // Write clock
  input                   write_reset_n,  // Active-low write reset
  input   [$clog2(DEPTH):0] sync_read_pointer,// Synchronized read pointer from the read domain
  output  reg             fifo_full,      // FIFO full flag
  output  [$clog2(DEPTH)-1:0] write_address, // Write address pointer (binary)
  output  reg [$clog2(DEPTH):0] write_pointer // Write pointer (Gray code)
);

  parameter DEPTH = 16;  // Depth of the FIFO (number of entries)

  reg [$clog2(DEPTH):0] write_bin;   // Binary write pointer
  wire [$clog2(DEPTH):0] write_gray_next, write_bin_next;

  // GRAYSTYLE2 pointer
  always @(posedge write_clock or negedge write_reset_n)
    if (!write_reset_n)
      {write_bin, write_pointer} <= '0;
    else
      {write_bin, write_pointer} <= {write_bin_next, write_gray_next};

  // Memory write address pointer (binary)
  assign write_address = write_bin[$clog2(DEPTH)-1:0];

  // Calculate next binary and Gray code pointers
  assign write_bin_next = write_bin + (write_enable & ~fifo_full);
  assign write_gray_next = (write_bin_next >> 1) ^ write_bin_next;

  // Determine FIFO full condition
  assign fifo_full_val = (write_gray_next == {~sync_read_pointer[$clog2(DEPTH):$clog2(DEPTH)-1], sync_read_pointer[$clog2(DEPTH)-2:0]});

  always @(posedge write_clock or negedge write_reset_n)
    if (!write_reset_n)
      fifo_full <= 1'b0;
    else
      fifo_full <= fifo_full_val;

endmodule
