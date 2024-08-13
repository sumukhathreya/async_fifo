//
// Testbench for Asynchronous FIFO
//
module fifo_testbench;

  parameter DATA_WIDTH = 8;
  parameter DEPTH = 16;

  wire [DATA_WIDTH-1:0] read_data;
  wire fifo_full;
  wire fifo_empty;
  reg [DATA_WIDTH-1:0] write_data;
  reg write_enable, write_clock, write_reset_n;
  reg read_enable, read_clock, read_reset_n;

  // Verification queue to check data consistency
  reg [DATA_WIDTH-1:0] verification_queue[$];
  reg [DATA_WIDTH-1:0] expected_data;

  // Instantiate the FIFO
  fifo_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
  ) fifo_dut (
    .write_enable(write_enable),
    .write_clock(write_clock),
    .write_reset_n(write_reset_n),
    .read_enable(read_enable),
    .read_clock(read_clock),
    .read_reset_n(read_reset_n),
    .write_data(write_data),
    .read_data(read_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty)
  );

  // Clock generation
  initial begin
    write_clock = 0;
    read_clock = 0;
    fork
      forever #10 write_clock = ~write_clock;
      forever #35 read_clock = ~read_clock;
    join
  end

  // Write process
  initial begin
    write_enable = 0;
    write_data = 0;
    write_reset_n = 0;
    repeat(5) @(posedge write_clock);
    write_reset_n = 1;

    for (int iter = 0; iter < 2; iter++) begin
      for (int i = 0; i < 32; i++) begin
        @(posedge write_clock if (!fifo_full));
        write_enable = (i % 2 == 0) ? 1 : 0;
        if (write_enable) begin
          write_data = $urandom;
          verification_queue.push_front(write_data);
        end
      end
      #1us;
    end
  end

  // Read process
  initial begin
    read_enable = 0;
    read_reset_n = 0;
    repeat(8) @(posedge read_clock);
    read_reset_n = 1;

    for (int iter = 0; iter < 2; iter++) begin
      for (int i = 0; i < 32; i++) begin
        @(posedge read_clock if (!fifo_empty));
        read_enable = (i % 2 == 0) ? 1 : 0;
        if (read_enable) begin
          expected_data = verification_queue.pop_back();
          $display("Checking data: expected = %h, actual = %h", expected_data, read_data);
          assert(read_data === expected_data) else $error("Mismatch: expected = %h, actual = %h", expected_data, read_data);
        end
      end
      #1us;
    end

    $finish;
  end

endmodule
