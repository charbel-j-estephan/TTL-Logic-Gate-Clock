`timescale 1ns/1ps

module tb_timekeeper;

  //----------------------------------------------------------------
  // Signals
  //----------------------------------------------------------------
  reg        clk = 1'b0;
  reg        rst_n;
  reg        tick;
  reg        set_hh;
  reg        set_mm;
  reg        set_ss;
  reg        toggle_ampm;

  wire [3:0] sec_ones;
  wire [3:0] sec_tens;
  wire [3:0] min_ones;
  wire [3:0] min_tens;
  wire [3:0] hr_ones;
  wire [3:0] hr_tens;

  integer    errors = 0;

  //----------------------------------------------------------------
  // Device under test
  //----------------------------------------------------------------
  timekeeper dut (
               .clk         (clk),
               .rst_n       (rst_n),
               .tick        (tick),
               .set_hh      (set_hh),
               .set_mm      (set_mm),
               .set_ss      (set_ss),
               .toggle_ampm (toggle_ampm),
               .sec_ones    (sec_ones),
               .sec_tens    (sec_tens),
               .min_ones    (min_ones),
               .min_tens    (min_tens),
               .hr_ones     (hr_ones),
               .hr_tens     (hr_tens)
             );

  always #5 clk = ~clk;

  //----------------------------------------------------------------
  // Helpers
  //----------------------------------------------------------------
  task show;
    input [8*14:1] label;
    begin
      $display("%0s  %0d%0d:%0d%0d:%0d%0d", label,
               hr_tens, hr_ones, min_tens, min_ones, sec_tens, sec_ones);
    end
  endtask

  task check_time;
    input [3:0] e_ht, e_ho, e_mt, e_mo, e_st, e_so;
    begin
      if (hr_tens !== e_ht || hr_ones !== e_ho ||
          min_tens !== e_mt || min_ones !== e_mo ||
          sec_tens !== e_st || sec_ones !== e_so)
      begin
        $display("  MISMATCH  expected %0d%0d:%0d%0d:%0d%0d  got %0d%0d:%0d%0d:%0d%0d",
                 e_ht, e_ho, e_mt, e_mo, e_st, e_so,
                 hr_tens, hr_ones, min_tens, min_ones, sec_tens, sec_ones);
        errors = errors + 1;
      end
    end
  endtask

  task check_hour;
    input [3:0] e_ht, e_ho;
    begin
      if (hr_tens !== e_ht || hr_ones !== e_ho)
      begin
        $display("  MISMATCH  hour expected %0d%0d  got %0d%0d",
                 e_ht, e_ho, hr_tens, hr_ones);
        errors = errors + 1;
      end
    end
  endtask

  //----------------------------------------------------------------
  // Stimulus, all on the falling edge
  //----------------------------------------------------------------
  initial
  begin
    $dumpfile("timekeeper.vcd");
    $dumpvars(0, tb_timekeeper);

    rst_n       = 1'b0;
    tick        = 1'b0;
    set_hh      = 1'b0;
    set_mm      = 1'b0;
    set_ss      = 1'b0;
    toggle_ampm = 1'b0;
    repeat (3) @(negedge clk);

    rst_n = 1'b1;
    @(negedge clk);
    check_time(0,0, 0,0, 0,0);

    tick = 1'b1;

    //------------------------------------------------------------
    // Phase 1, set minutes. Minutes climb, hours must not move.
    //------------------------------------------------------------
    $display("=== phase 1, set minutes ===");
    show("before      ");

    set_mm = 1'b1;
    repeat (10) @(negedge clk);
    set_mm = 1'b0;
    @(negedge clk);

    show("after 10    ");
    // 10 ticks of setting plus 11 elapsed seconds
    check_hour(4'd0, 4'd0);
    if (min_tens !== 4'd1 || min_ones !== 4'd0)
    begin
      $display("  MISMATCH  minutes expected 10  got %0d%0d",
               min_tens, min_ones);
      errors = errors + 1;
    end

    //------------------------------------------------------------
    // Phase 2, set hours. Hours climb, minutes must not move.
    //------------------------------------------------------------
    $display("=== phase 2, set hours ===");
    show("before      ");

    set_hh = 1'b1;
    repeat (7) @(negedge clk);
    set_hh = 1'b0;
    @(negedge clk);

    show("after 7     ");
    check_hour(4'd0, 4'd7);

    //------------------------------------------------------------
    // Phase 3, set seconds. Minutes must not carry.
    //------------------------------------------------------------
    $display("=== phase 3, set seconds ===");
    show("before      ");

    set_ss = 1'b1;
    repeat (70) @(negedge clk);      // more than a full minute
    set_ss = 1'b0;
    @(negedge clk);

    show("after 70    ");
    check_hour(4'd0, 4'd7);          // hours untouched

    //------------------------------------------------------------
    // Phase 4, ampm toggle still works
    //------------------------------------------------------------
    $display("=== phase 4, ampm toggle ===");
    toggle_ampm = 1'b1;
    repeat (3) @(negedge clk);
    toggle_ampm = 1'b0;
    @(negedge clk);

    show("flipped     ");
    check_hour(4'd1, 4'd9);

    toggle_ampm = 1'b1;
    repeat (3) @(negedge clk);
    toggle_ampm = 1'b0;
    @(negedge clk);

    show("flipped back");
    check_hour(4'd0, 4'd7);

    //------------------------------------------------------------
    // Verdict
    //------------------------------------------------------------
    if (errors == 0)
      $display("PASS");
    else
      $display("FAIL, %0d mismatches", errors);

    $finish;
  end

endmodule
