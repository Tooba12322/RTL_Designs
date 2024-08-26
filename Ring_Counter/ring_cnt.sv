// Ring counter - Synchronous counter, Fout = Fin / NFF
module ring_cnt(Q,clk,rst);
  output logic [3:0]Q;
  input logic clk,rst;
   
  logic Fo;
  
  assign Fo = Q[0];
  always @(posedge clk or negedge rst) begin
    if (!rst) Q <= 4'b0100;
    else Q <=  {Fo,Q[3:1]}; // feedback connection from LSB to MSB flop, divides freq as Fout
  end
endmodule 
  
