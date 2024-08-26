
// Twisted_Ring / Johnson counter - Synchronous counter, Fout = Fin / 2*NFF
module tw_ring_cnt(Q,clk,rst);
  output logic [3:0]Q;
  input logic clk,rst;
   
  logic Fo;
  
  assign Fo = !Q[0];
  always @(posedge clk or negedge rst) begin
    if (!rst) Q <= '0;
    else Q <=  {Fo,Q[3:1]}; // Feedback connection with Qbar, freq divider
  end
endmodule 
  
