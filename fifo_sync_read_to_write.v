//
// Synchronization Module from Read Pointer to Write Clock Domain
//
module fifo_sync_read_to_write #(
  parameter DEPTH = 16
)(
  input wire write_clock, write_reset_n,
  input wire [$clog2(DEPTH):0] read_pointer,
  output reg [$clog2(DEPTH):0] sync_read_pointer
);

  reg [$clog2(DEPTH):0] sync_stage_1;

  always @(posedge write_clock or negedge write_reset_n)
    if (!write_reset_n) 
      {synced_read_pointer, sync_stage_1} <= 0;
    else
      {synced_read_pointer, sync_stage_1} <= {sync_stage_1, read_pointer};

endmodule
