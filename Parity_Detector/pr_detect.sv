// Design an parity detector for serial bit stream and generate a single bit output each cycle using Moore FSM, 0 indicates even parity and 1 indicates odd parity as output.

module pr_detect (out,sr_in,clk,rst);
  
  output logic out;
  input logic sr_in,clk,rst;
  
  typedef enum {EVEN, ODD} state;
  state pr_state,nx_state;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= '0;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
      out = '0;
    case (pr_state) 
      EVEN : begin
               if (sr_in=='1) nx_state = ODD;
               else nx_state = EVEN;
               out = '0;
             end
      ODD  : begin
               if (sr_in=='1) nx_state = EVEN;
               else nx_state = ODD;
               out = '1;
             end
    endcase
  end
endmodule
 
