// Design an parity detector for serial bit stream and generate a single bit output each cycle using Moore FSM,
// 0 indicates even parity and 1 indicates odd parity as output.

module pr_detect (out,sr_in,clk,rst);
  
  output logic out;
  input logic sr_in,clk,rst;
  
  //typedef enum logic {EVEN, ODD} statetype;
  //statetype pr_state,nx_state;
  // Not working with enum as of now, still debugging
  
  parameter EVEN='0, ODD='1;
  logic pr_state,nx_state;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= '0;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
      out = '0;
    case (pr_state) 
      EVEN : begin
               nx_state = (sr_in=='1) ? ODD : EVEN;
               out = '0;
             end
      ODD  : begin
               nx_state = (sr_in=='1) ? EVEN : ODD;
               out = '1;
             end
    endcase
  end
endmodule
 
