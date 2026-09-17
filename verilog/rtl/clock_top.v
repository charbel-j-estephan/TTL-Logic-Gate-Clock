`default_nettype none


module clock_top (
    input  wire       clk,
    input  wire       tick,
    input  wire [5:0] sw,

    output wire [6:0] seg0,
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4,
    output wire [6:0] seg5,
    output wire [6:0] seg6
  );

  wire mode_12     = sw[3];
  wire toggle_ampm = sw[4];
  wire rst_n       = ~sw[5];

  wire [3:0] sec_ones, sec_tens;
  wire [3:0] min_ones, min_tens;
  wire [3:0] hr_ones,  hr_tens;

  wire [3:0] disp_hr_tens;
  wire [3:0] disp_hr_ones;
  wire       am_pm;

  wire [3:0] ampm_code = mode_12 ? (am_pm ? 4'd11 : 4'd10) : 4'd15;

  wire set_hh      = sw[0];
  wire set_mm      = sw[1];
  wire set_ss      = sw[2];

  seg7_decoder u_seg0 (
                 .code (sec_ones),
                 .seg  (seg0)
               );
  seg7_decoder u_seg1 (
                 .code (sec_tens),
                 .seg  (seg1)
               );
  seg7_decoder u_seg2 (
                 .code (min_ones),
                 .seg  (seg2)
               );
  seg7_decoder u_seg3 (
                 .code (min_tens),
                 .seg  (seg3)
               );
  seg7_decoder u_seg4 (
                 .code (disp_hr_ones),
                 .seg  (seg4)
               );
  seg7_decoder u_seg5 (
                 .code (disp_hr_tens),
                 .seg  (seg5)
               );
  seg7_decoder u_seg6 (
                 .code (ampm_code),
                 .seg  (seg6)
               );
  timekeeper u_timekeeper (
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

  format_convert u_format (
                   .mode_12    (mode_12),
                   .hr_tens_24 (hr_tens),
                   .hr_ones_24 (hr_ones),
                   .hr_tens_12 (disp_hr_tens),
                   .hr_ones_12 (disp_hr_ones),
                   .am_pm      (am_pm)
                 );

endmodule

`default_nettype wire
