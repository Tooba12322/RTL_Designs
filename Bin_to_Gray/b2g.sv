module b2g (gr_o,bin);
  input   logic [3:0] bin;       
  output  logic [3:0] gr_o;

  assign gr_o = {bin[3],bin[3]^bin[2],bin[2]^bin[1],bin[1]^bin[0]};
  
endmodule

