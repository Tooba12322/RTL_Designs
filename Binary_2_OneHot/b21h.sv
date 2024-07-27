// Binary to one hot encoder using parameters
module b21h (Bin,One_Hot);
  
  parameter Bin_w = 4;
  parameter O_w = 2**Bin_w;
  
  input logic [Bin_w-1:0] Bin;
  output logic [O_w-1:0] One_Hot;
  
  assign One_Hot = 1'b1 << Bin;
endmodule
