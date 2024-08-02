// Parallel in serial out shift register

module PISO (Q,D,clk,rst,load);
  input logic clk,rst,load;
  input logic [3:0] D;
  output logic Q;
  
  logic [3:0] q;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) q <= '0;
    else q <= (load=='0) ?  {D[3],q[3],q[2],q[1]} : D;
  end
  
  assign Q = q[0];
  
endmodule








