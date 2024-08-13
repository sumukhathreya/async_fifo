//
// Top-Level Module for Asynchronous FIFO
//
module fifo_top #(
  parameter DATA_WIDTH = 8,  // Width of the data
  parameter DEPTH = 16       // Depth of the FIFO
)(
  input wire write_enable, write_clock, write_reset_n,
  input wire read_enable, read_clock, read_reset_n,
  input wire [DATA_WIDTH-1:0] write_data,
  output wire [DATA_WIDTH-1:0] read_data,
  output wire fifo_full,
  output wire fifo_empty
);

  wire [$clog2(DEPTH)-1:0] write_address, read_address;
  wire [$clog2(DEPTH):0] write_pointer, read_pointer, sync_read_pointer, sync_write_pointer;

  // Instantiate the sub-modules
  fifo_sync_read_to_write sync_r2w_inst (
    .write_clock(write_clock),
    .write_reset_n(write_reset_n),
    .read_pointer(read_pointer),
    .sync_read_pointer(sync_read_pointer)
  );

  fifo_sync_write_to_read sync_w2r_inst (
    .rclk(read_clock),
    .rrst_n(read_reset_n),
    .wptr(write_pointer),
    .rq2_wptr(sync_write_pointer)
  );

  fifo_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
  ) fifo_mem_inst (
    .write_enable(write_enable),
    .fifo_full(fifo_full),
    .wclk(write_clock),
    .write_address(write_address),
    .read_address(read_address),
    .write_data(write_data),
    .read_data(read_data)
  );

  fifo_read_pointer_empty #(
    .DEPTH(DEPTH)
  ) rptr_empty_inst (
    .read_enable(read_enable),
    .read_clock(read_clock),
    .read_reset_n(read_reset_n),
    .sync_write_pointer(sync_write_pointer),
    .fifo_empty(fifo_empty),
    .read_address(read_address),
    .read_pointer(read_pointer)
  );

  fifo_write_pointer_full #(
    .DEPTH(DEPTH)
  ) wptr_full_inst (
    .write_enable(write_enable),
    .write_clock(write_clock),
    .write_reset_n(write_reset_n),
    .sync_read_pointer(sync_read_pointer),
    .fifo_full(fifo_full),
    .write_address(write_address),
    .write_pointer(write_pointer)
  );

endmodule
