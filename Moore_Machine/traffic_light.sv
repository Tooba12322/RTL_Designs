//Design a Moore FSM to control a traffic light system. 
//The FSM should have three states corresponding to the traffic light colors: Red, Green, and Yellow. 
//The traffic light should cycle through these states in the order Red → Green → Yellow → Red, with a fixed time duration for each color. 
//The FSM should have a clock input for timing and a reset input to restart the cycle. The output should indicate the current color of the traffic light.


module traffic_light (Out,clk,rst);
  
  output logic [6*8:1] Out; // to hold an ASCII value
  input logic clk,rst;
   
  logic [1:0] Cnt;
  logic ld_Cnt;
  
  typedef enum logic [1:0] {RED = 2'b00,
    GREEN = 2'b01,
    YELLOW = 2'b10} state;
    state pr_state,nx_state;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= RED;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
      Out      = "RED";
      ld_Cnt   = '0;
    
    case (pr_state) 
      RED : begin
              if (Cnt == '0) begin
                nx_state = GREEN;
                ld_Cnt = '1;
              end
              Out = "RED";
            end
      GREEN : begin
             if (Cnt == '0) begin
               nx_state = YELLOW;
               ld_Cnt = '1;
             end
             Out = "GREEN";
           end
      YELLOW : begin
              if (Cnt == '0) begin
                nx_state = RED;
                ld_Cnt = '1;
              end
              Out = "YELLOW";
           end
      endcase
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst || ld_Cnt) Cnt <= '1;
    else Cnt <= Cnt - 2'd1;
  end 
  
endmodule
 
