// Design a circuit that detects three or more consequtive 1's in the continuous bit stream.


module Seq_Det (In,Out,clk,rst);
  
  output logic Out; 
  input logic In,clk,rst;
   
  typedef enum logic [1:0] {S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10,
    S3 = 2'b11} state;
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
             if (In == '1) nx_state = S2;
             else nx_state = S0;
           end
      S2 : begin
             if (In == '1) nx_state = S3;
             else nx_state = S0;
           end
      S3 : begin
             if (In == '0) nx_state = S0;
             Out = '1;
           end
      
      endcase
  end
  
endmodule
 
