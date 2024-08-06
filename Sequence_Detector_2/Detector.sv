// Design a sequence detector to detect "101010" in overlapping fashion using Mealey FSM


module Seq_Det (In,Out,clk,rst);
  
  output logic Out; 
  input logic In,clk,rst;
   
  typedef enum logic [2:0] {S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101} state;
    state pr_state,nx_state;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= S0;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
      Out      = '0;
    
    case (pr_state) 
      S0 : begin
             if (In == '1) nx_state = S1;
           end
      S1 : begin
             if (In == '0) nx_state = S2;
           end
      S2 : begin
             if (In == '1) nx_state = S3;
             else nx_state = S0;
           end
      S3 : begin
             if (In == '0) nx_state = S4;
             else nx_state = S1;
           end
      S4 : begin
             if (In == '1) nx_state = S5;
             else nx_state = S0;
           end
      S5 : begin
             if (In == '0) nx_state = S3;
             else nx_state = S1;
             Out = '1;
           end
      endcase
  end
  
endmodule
 
