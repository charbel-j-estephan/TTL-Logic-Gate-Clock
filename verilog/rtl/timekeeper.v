`default_nettype none

module timekeeper(
    input wire clk, // rising edge
    input wire rst_n, // active low reset
    input wire tick, // 1s
    input wire set_hh,
    input wire set_mm,
    input wire set_ss,
    input wire toggle_ampm,


    output wire [3:0] sec_ones,
    output wire [3:0] sec_tens,
    output wire [3:0] min_ones,
    output wire [3:0] min_tens,
    output wire [3:0] hr_ones,
    output wire [3:0] hr_tens
  );

  wire c_sec_ones;
  wire c_sec_tens;
  wire c_min_ones;
  wire c_min_tens;
  wire c_hour_ones;
  wire c_hour_tens;


  wire en_sec_tens;


  assign en_sec_tens  = c_sec_ones;
  wire en_min_ones  = set_mm ? tick :
       set_ss ? 1'b0 :
       c_sec_tens;
  wire en_min_tens  = c_min_ones;
  wire en_hour_ones = set_hh ? tick :
       set_mm ? 1'b0 :
       c_min_tens;
  wire en_hour_tens = c_hour_ones;

  wire hour_wrap = en_hour_ones && (hr_tens == 4'd2) && (hr_ones == 4'd3);

  // debounce function
  reg toggle_prev;

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      toggle_prev <= 1'b0;
    else
      toggle_prev <= toggle_ampm;
  end

  wire toggle_pulse = toggle_ampm && !toggle_prev;
  // combine hours tens and ones
  wire [4:0] hour_now = (hr_tens * 4'd10) + hr_ones;
  //add or substarct 12 based on the current hour
  wire [4:0] hour_flip = (hour_now >= 5'd12) ? (hour_now - 5'd12)
       : (hour_now + 5'd12);
  // split back into tens and ones
  wire [3:0] flip_tens = (hour_flip >= 5'd20) ? 4'd2 :
       (hour_flip >= 5'd10) ? 4'd1 :
       4'd0;
  wire [3:0] flip_ones = (hour_flip >= 5'd20) ? (hour_flip - 5'd20) :
       (hour_flip >= 5'd10) ? (hour_flip - 5'd10) :
       hour_flip;



  bcd_counter #(
                .MAX (9)
              ) u_sec_ones (
                .clk   (clk),
                .rst_n (rst_n),
                .en    (tick),
                .clr(1'b0),

                .load  (1'b0),
                .load_val (4'd0),
                .count (sec_ones),
                .carry (c_sec_ones)
              );

  bcd_counter #(
                .MAX (5)
              ) u_sec_tens (
                .clk   (clk),
                .rst_n (rst_n),
                .en    (en_sec_tens),
                .clr(1'b0),

                .load  (1'b0),
                .load_val (4'd0),
                .count (sec_tens),
                .carry (c_sec_tens)
              );
  bcd_counter #(
                .MAX (9)
              ) u_min_ones (
                .clk   (clk),
                .rst_n (rst_n),
                .en    (en_min_ones),
                .clr(1'b0),

                .load  (1'b0),
                .load_val (4'd0),
                .count (min_ones),
                .carry (c_min_ones)
              );

  bcd_counter #(
                .MAX (5)
              ) u_min_tens (
                .clk   (clk),
                .rst_n (rst_n),
                .en    (en_min_tens),
                .clr (1'b0),
                .load  (1'b0),
                .load_val (4'd0),
                .count (min_tens),
                .carry (c_min_tens)
              );
  bcd_counter #(.MAX(9)) u_hour_ones (
                .clk      (clk),
                .rst_n    (rst_n),
                .en       (en_hour_ones),
                .clr      (hour_wrap),
                .load     (toggle_pulse),
                .load_val (flip_ones),
                .count    (hr_ones),
                .carry    (c_hour_ones)
              );

  bcd_counter #(.MAX(2)) u_hour_tens (
                .clk      (clk),
                .rst_n    (rst_n),
                .en       (en_hour_tens),
                .clr      (hour_wrap),
                .load     (toggle_pulse),
                .load_val (flip_tens),
                .count    (hr_tens),
                .carry    (c_hour_tens)
              );
endmodule
`default_nettype wire

