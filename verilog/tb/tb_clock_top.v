`timescale 1ns/1ps

module tb_clock_top;

  //----------------------------------------------------------------
  // Signals
  //----------------------------------------------------------------
  reg        clk = 1'b0;
  reg        tick;
  reg  [5:0] sw;

  wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6;

  //----------------------------------------------------------------
  // Device under test
  //----------------------------------------------------------------
  clock_top dut (
              .clk  (clk),
              .tick (tick),
              .sw   (sw),
              .seg0 (seg0),
              .seg1 (seg1),
              .seg2 (seg2),
              .seg3 (seg3),
              .seg4 (seg4),
              .seg5 (seg5),
              .seg6 (seg6)
            );

  always #5 clk = ~clk;

  //----------------------------------------------------------------
  // Turn a segment pattern back into a character. This is the
  // reverse of seg7_decoder, so it proves the whole display path.
  //----------------------------------------------------------------
  function [7:0] undecode;
    input [6:0] s;
    begin
      case (s)
        7'b0111111 :
          undecode = "0";
        7'b0000110 :
          undecode = "1";
        7'b1011011 :
          undecode = "2";
        7'b1001111 :
          undecode = "3";
        7'b1100110 :
          undecode = "4";
        7'b1101101 :
          undecode = "5";
        7'b1111101 :
          undecode = "6";
        7'b0000111 :
          undecode = "7";
        7'b1111111 :
          undecode = "8";
        7'b1101111 :
          undecode = "9";
        7'b1110111 :
          undecode = "A";
        7'b1110011 :
          undecode = "P";
        7'b0000000 :
          undecode = " ";
        default    :
          undecode = "?";
      endcase
    end
  endfunction

  task show;
    input [8*12:1] label;
    begin
      $display("%0s  %0s%0s:%0s%0s:%0s%0s  %0s", label,
               undecode(seg5), undecode(seg4),
               undecode(seg3), undecode(seg2),
               undecode(seg1), undecode(seg0),
               undecode(seg6));
    end
  endtask

  //----------------------------------------------------------------
  // Stimulus. All changes on the falling edge.
  //----------------------------------------------------------------
  initial
  begin
    $dumpfile("clock_top.vcd");
    $dumpvars(0, tb_clock_top);

    sw   = 6'b100000;        // sw[5] high, so rst_n is low
    tick = 1'b0;
    repeat (3) @(negedge clk);

    sw[5] = 1'b0;            // release reset
    @(negedge clk);
    show("after reset");

    tick = 1'b1;

    //------------------------------------------------------------
    // 24 hour mode, run to 07:00:00
    //------------------------------------------------------------
    $display("=== 24 hour mode ===");
    repeat (25200) @(negedge clk);
    show("07:00      ");

    //------------------------------------------------------------
    // Switch to 12 hour mode, indicator should show A
    //------------------------------------------------------------
    $display("=== 12 hour mode ===");
    sw[3] = 1'b1;
    @(negedge clk);
    show("07:00 am   ");

    //------------------------------------------------------------
    // Flip to PM, hour becomes 19 internally, display stays 07
    //------------------------------------------------------------
    sw[4] = 1'b1;
    repeat (3) @(negedge clk);
    sw[4] = 1'b0;
    @(negedge clk);
    show("07:00 pm   ");

    //------------------------------------------------------------
    // Back to 24 hour mode, should read 19 with a blank indicator
    //------------------------------------------------------------
    $display("=== back to 24 hour ===");
    sw[3] = 1'b0;
    @(negedge clk);
    show("19:00      ");

    //------------------------------------------------------------
    // Run to noon the next day, checking the boundaries
    //------------------------------------------------------------
    $display("=== 12 hour mode across midnight ===");
    sw[3] = 1'b1;

    repeat (18000) @(negedge clk);   // to 00:00
    show("midnight   ");

    repeat (43200) @(negedge clk);   // to 12:00
    show("noon       ");

    $finish;
  end

endmodule
