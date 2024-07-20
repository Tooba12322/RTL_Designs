module LUT(RAM, a0, a1, a2, a3, clk, rst);
  
  input logic a0, a1, a2, a3;
  input logic clk;
  input logic rst;
  output logic RAM[15:0];
  logic F;
  logic addr;
  logic i;
  
  always_comb F = a3 + ((!a3)*(!a2)*(a1)) + ((a2)*(a1)*(!a0));
  always_comb addr = {a3, a2, a1, a0};
  
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (i=0; i<16; i++) RAM[i] <= '0;
    end
    else if (F) RAM[addr] <= F;
    else RAM[addr] <= '0;
    
  end 
endmodule



