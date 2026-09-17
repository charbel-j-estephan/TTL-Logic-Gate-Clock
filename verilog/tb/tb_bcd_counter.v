`timescale 1ns/1ps

module tb_bcd_counter;

  //----------------------------------------------------------------
  // Signals. Inputs to the DUT are reg, outputs are wire.
  //----------------------------------------------------------------
  reg        clk = 1'b0;
  reg        rst_n;
  reg        en;
  wire [3:0] count;
  wire       carry;

  //----------------------------------------------------------------
  // Device under test, MAX set to 9 for a ones digit
  //----------------------------------------------------------------
  bcd_counter #(
                .MAX (9)
              ) dut (
                .clk   (clk),
                .rst_n (rst_n),
                .en    (en),
                .count (count),
                .carry (carry)
              );

  //----------------------------------------------------------------
  // Clock, 10 ns period
  //----------------------------------------------------------------
  always #5 clk = ~clk;

  //----------------------------------------------------------------
  // Stimulus
  //----------------------------------------------------------------
  initial
  begin
    $dumpfile("bcd.vcd");
    $dumpvars(0, tb_bcd_counter);

    rst_n = 1'b0;
    en    = 1'b0;
    repeat (3) @(posedge clk);

    rst_n = 1'b1;
    @(posedge clk);

    en = 1'b1;
    repeat (25) @(posedge clk);

    en = 1'b0;
    repeat (3) @(posedge clk);

    $finish;
  end

  //----------------------------------------------------------------
  // Monitor, samples on the falling edge
  //----------------------------------------------------------------
  always @(negedge clk)
  begin
    $display("t=%4t  rst_n=%b en=%b  count=%2d  carry=%b",
             $time, rst_n, en, count, carry);
  end

endmodule
