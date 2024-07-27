// Positive and negative edge detetctor

module edge_detect(P_edge,N_edge,In,clk,rst);
  input logic  In,clk,rst;
  output logic  P_edge,N_edge;
  logic D_In;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) D_In <= '0;
    else D_In <= In; //Delayed input
  end
  
  always_comb P_edge = In & !D_In;
  always_comb N_edge = !In & D_In;
  
endmodule

