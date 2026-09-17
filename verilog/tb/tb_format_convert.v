`timescale 1ns/1ps

module tb_format_convert;

  //----------------------------------------------------------------
  // Signals
  //----------------------------------------------------------------
  reg        mode_12;
  reg  [3:0] hr_tens_24;
  reg  [3:0] hr_ones_24;

  wire [3:0] hr_tens_12;
  wire [3:0] hr_ones_12;
  wire       am_pm;

  integer h;
  integer errors = 0;

  //----------------------------------------------------------------
  // Device under test
  //----------------------------------------------------------------
  format_convert dut (
                   .mode_12    (mode_12),
                   .hr_tens_24 (hr_tens_24),
                   .hr_ones_24 (hr_ones_24),
                   .hr_tens_12 (hr_tens_12),
                   .hr_ones_12 (hr_ones_12),
                   .am_pm      (am_pm)
                 );

  //----------------------------------------------------------------
  // Check task. Compares actual against expected and counts errors.
  //----------------------------------------------------------------
  task check;
    input [4:0] exp_hour;
    input       exp_pm;
    reg   [4:0] got_hour;
    begin
      got_hour = (hr_tens_12 * 4'd10) + hr_ones_12;
      if (got_hour !== exp_hour || am_pm !== exp_pm)
      begin
        $display("  MISMATCH  expected %0d pm=%b  got %0d pm=%b",
                 exp_hour, exp_pm, got_hour, am_pm);
        errors = errors + 1;
      end
    end
  endtask

  //----------------------------------------------------------------
  // Stimulus
  //----------------------------------------------------------------
  initial
  begin
    $dumpfile("format.vcd");
    $dumpvars(0, tb_format_convert);

    //------------------------------------------------------------
    // 12 hour mode, all 24 inputs
    //------------------------------------------------------------
    $display("=== 12 hour mode ===");
    mode_12 = 1'b1;

    for (h = 0; h < 24; h = h + 1)
    begin
      hr_tens_24 = h / 10;
      hr_ones_24 = h % 10;
      #10;

      $display("24h=%2d  ->  %0d%0d  %s",
               h, hr_tens_12, hr_ones_12, am_pm ? "PM" : "AM");

      if (h == 0)
        check(5'd12, 1'b0);
      else if (h < 12)
        check(h[4:0], 1'b0);
      else if (h == 12)
        check(5'd12, 1'b1);
      else
        check(h[4:0] - 5'd12, 1'b1);
    end

    //------------------------------------------------------------
    // 24 hour mode, digits must pass through unchanged
    //------------------------------------------------------------
    $display("=== 24 hour mode ===");
    mode_12 = 1'b0;

    for (h = 0; h < 24; h = h + 1)
    begin
      hr_tens_24 = h / 10;
      hr_ones_24 = h % 10;
      #10;

      $display("24h=%2d  ->  %0d%0d",
               h, hr_tens_12, hr_ones_12);

      check(h[4:0], am_pm);   // value must match, pm ignored here
    end

    //------------------------------------------------------------
    // Verdict
    //------------------------------------------------------------
    if (errors == 0)
      $display("PASS, all 48 cases correct");
    else
      $display("FAIL, %0d mismatches", errors);

    $finish;
  end

endmodule
