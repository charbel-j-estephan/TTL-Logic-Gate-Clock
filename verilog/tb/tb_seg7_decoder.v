`timescale 1ns/1ps

module tb_seg7_decoder;

  reg  [3:0] code;
  wire [6:0] seg;

  seg7_decoder dut (
                 .code (code),
                 .seg  (seg)
               );

  integer i;

  initial
  begin
    for (i = 0; i < 16; i = i + 1)
    begin
      code = i[3:0];
      #10;
      $display("code=%2d  seg=%b", code, seg);
    end
    $finish;
  end

endmodule
