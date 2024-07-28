// Linear feedback shift reg
module lfsr(Q,clk,rst);
  output logic [3:0]Q;
  input logic clk,rst;
   
  logic Fo;

  // Non-zero initialization after reset
  assign Fo = !((Q[0] ^ Q[1]) ^ (!Q[2]));
  always @(posedge clk or negedge rst) begin
    if (!rst) Q <= 4'b1000;
    else Q <=  {Fo,Q[3:1]}; 
  end
  
  //Also possible with '0 reset value initialization
  //assign Fo = !(Q[0] ^ Q[1]);
  //always @(posedge clk or negedge rst) begin
  //  if (!rst) Q <= 4'b0000;
  //  else Q <=  {Fo,Q[3:1]}; 
  //end
endmodule 
