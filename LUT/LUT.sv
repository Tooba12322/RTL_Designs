//Implementing 4-variable function in LUT as F

module LUT(RAM, a0, a1, a2, a3, clk, rst);
  
  input logic a0, a1, a2, a3;
  input logic clk;
  input logic rst;
  output logic RAM[15:0]; // 16 locations for LUT implementation
  logic F;
  logic addr;
  int i;
  
  always_comb F = a3 || ((!a3) && (!a2) && (a1)) || ((a2) && (a1) && (!a0));// four variable function to be implemented
  always_comb addr = {a3, a2, a1, a0}; 
  
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (i=0; i<16; i++) RAM[i] <= '0;
    end
    else if (F) RAM[addr] <= F; // if F=1, store in LUT
    else RAM[addr] <= '0; // else store 0 if F=0 
    
  end 
endmodule

