
// Baud Rate Generator
// Source : https://www.youtube.com/watch?v=ujiJGZKKw2E&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=71

module BR_gen(tick,br_div,clk,rst);
  
  output logic tick;
  input logic [10:0] br_div;
  input logic clk,rst;
  
  logic [10:0] br_cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) br_cnt <= '0;
    else if (br_cnt == br_div) br_cnt <= '0;
    else br_cnt <= br_cnt + 11'd1;
  end
    
  assign tick = (br_cnt==11'd1) ? '1 : '0; 
  
endmodule 

