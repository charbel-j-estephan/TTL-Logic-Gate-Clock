`default_nettype none

module format_convert(
    input wire mode_12, // 1 for 12 hour mode, 0 for 24 hour mode
    input wire [3:0] hr_tens_24,
    input wire [3:0] hr_ones_24,

    output reg [3:0] hr_tens_12,
    output reg [3:0] hr_ones_12,
    output reg am_pm // 1 for PM, 0 for AM
  );
  wire [4:0] hour24 = (hr_tens_24 * 4'd10)+ hr_ones_24;
  wire[4:0] hour12 = (hour24
                      == 5'd0)?5'd12: (hour24>5'd12)?(hour24-5'd12):hour24;
  always@(*)
  begin
    if(mode_12 == 1'b1)
    begin
      am_pm = (hour24 >= 5'd12);
      hr_tens_12 = (hour12 >= 5'd10) ? 4'd1 : 4'd0;
      hr_ones_12 = (hour12 >= 5'd10) ? (hour12 - 5'd10) : hour12;
    end
    else
    begin
      hr_tens_12 = hr_tens_24;
      hr_ones_12 = hr_ones_24;
      am_pm = 1'b0;

    end
  end
endmodule
`default_nettype wire
