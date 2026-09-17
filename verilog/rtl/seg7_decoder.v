`default_nettype none

//whithout it, any misspell woill cause the creation of new 1 bit wire

module seg7_decoder(
    input wire [3:0] code, // why wire? because we don't need to store the input
    output reg [6:0] seg // seg because will will store it and compare it later on
  );

  always @(*)
  begin // I am telling the compiler "Hey, just automatically watch every single signal used inside this block. If any of them change even a tiny bit, rerun the whole block right away!"
    case(code) // declare swicth statement
      4'd0  : //if code = 0; 4 means width in bits d means decimal 0 means the value
        seg = 7'b0111111; // gfedcba
      4'd1  ://if code = 1
        seg = 7'b0000110; // 1
      4'd2  :
        seg = 7'b1011011; // 2
      4'd3  :
        seg = 7'b1001111; // 3
      4'd4  :
        seg = 7'b1100110; // 4
      4'd5  :
        seg = 7'b1101101; // 5
      4'd6  :
        seg = 7'b1111101; // 6
      4'd7  :
        seg = 7'b0000111; // 7
      4'd8  :
        seg = 7'b1111111; // 8
      4'd9  :
        seg = 7'b1101111; // 9
      4'd10 :
        seg = 7'b1110111; // A
      4'd11 :
        seg = 7'b1110011; // P
      default :
        seg = 7'b0000000; // blank
    endcase
  end
endmodule

`default_nettype wire

