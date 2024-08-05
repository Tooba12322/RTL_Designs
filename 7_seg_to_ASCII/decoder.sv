// From input code, generate 7 segment code and print its respective ASCII value

// 7-seg to ASCII decoder, active low to glow a segment

module Decoder(ascii_out,a,b,c,d,e,f,g);
  
  output logic [7:0] ascii_out; // 8-bit ASCII output
  input logic a,b,c,d,e,f,g;
  
  logic [6:0] Sel;
  
  assign Sel = {a,b,c,d,e,f,g}; // combining 7-seg dispaly inputs
  
  always @(*) begin
    case (Sel)
      7'b1001000 : ascii_out = "H";
      7'b0110000 : ascii_out = "E";
      7'b1110001 : ascii_out = "L";
      7'b0000001 : ascii_out = "O";
      7'b1111001 : ascii_out = "1";
      7'b0010010 : ascii_out = "2";
      7'b0000110 : ascii_out = "3";
      7'b0000000 : ascii_out = "8";
      default   : ascii_out = "|";
    endcase
  end
endmodule
