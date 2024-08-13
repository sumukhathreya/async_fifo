//
// Synchronization Module from Write Pointer to Read Clock Domain
//
module fifo_sync_write_to_read #(
  parameter DEPTH = 16
)(
  input wire read_clock, read_reset_n,
  input wire [$clog2(DEPTH):0] write_pointer,
  output reg [$clog2(DEPTH):0] synced_write_pointer
);

  reg [$
//
// Write Pointer to Read Clock Synchronizer
//
// This module synchronizes the write pointer to the read clock domain.
//

module sync_write_to_read#(
    parameter DEPTH = 16;  // Depth of the FIFO (number of entries)
)(
  input                   read_clock,       // Read clock
  input                   read_reset_n,   // Active-low read reset
  input   [$clog2(DEPTH):0] write_pointer,    // Write pointer (from write domain)
  output  reg [$clog2(DEPTH):0] sync_read_pointer  // Synchronized write pointer (in read domain)
);

  
  reg [$clog2(DEPTH):0] sync_write_ptr_stage1;  // Intermediate synchronization stage

  always @(posedge read_clock or negedge read_reset_n)
    if (!read_reset_n)
      {sync_read_pointer, sync_write_ptr_stage1} <= 0;
    else
      {sync_read_pointer, sync_write_ptr_stage1} <= {sync_write_ptr_stage1, write_pointer};

endmodule
