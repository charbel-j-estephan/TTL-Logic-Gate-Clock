`default_nettype none

module bcd_counter #( // the hashtag is used to declare a parameterized module
    parameter MAX=9
  )(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    input  wire clr,
    input  wire load,
    input  wire [3:0] load_val,
    output reg [3:0] count,
    output wire carry
  );


  assign carry = en && (count == MAX);
  // this will automatically link the carry with the en and the count


  always @(posedge clk or negedge rst_n) // check if the clk is rising or the rst_n is falling
  begin
    if (!rst_n)
      count <= 4'd0;
    else if (clr)
      count <= 4'd0;
    else if (load)
      count <= load_val;
    else if (en)
    begin
      if (count == MAX)
        count <= 4'd0;
      else
        count <= count + 1'b1;
    end
  end
endmodule


`default_nettype wire
