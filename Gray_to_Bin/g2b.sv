module g2b (bin_o,gr_in);
  input   logic [3:0] gr_in;       
  output  logic [3:0] bin_o;
  
  assign bin_o[3] = gr_in[3];
  assign bin_o[2] = bin_o[3] ^ gr_in[2];
  assign bin_o[1] = bin_o[2] ^ gr_in[1];
  assign bin_o[0] = bin_o[1] ^ gr_in[0];
  
  
endmodule
