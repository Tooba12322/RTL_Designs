module LUT(F,a0, a1, a2, a3, clk, rst, addr, RAM);
  output logic F;
  input logic a0, a1, a2, a3;
  input logic clk;
  input logic rst;
  output logic RAM[15:0];
  output logic addr;
  
  always_comb F = a3 + ((!a3)*(!a2)*(a1)) + ((a2)*(a1)*(!a0));
  always_comb addr = {a3, a2, a1, a0};
  
  wire i;
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (i=0; i<16; i++) RAM[i] <= '0;
    end
    else if (F) RAM[addr] <= F;
    else RAM[addr] <= '0;
    
  end 
endmodule



