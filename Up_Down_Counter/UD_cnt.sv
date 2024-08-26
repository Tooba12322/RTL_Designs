// Implement an 8-bit up-down counter
  // - Resets to 0
  // - Increments by 1 every cycle, by default
  // - Takes the load value if load_i is seen
  // - Starts to count up from load value till max cnt, then sets the flag
  // - Starts to count down after overflow till the load value, resets the flag
  // - Hence, once a value is loaded it ping-pong between load value and max value
  
module UD_Cnt(Cnt,load,load_val,clk,rst);
  output logic [7:0] Cnt;
  input logic load,clk,rst;
  input logic [7:0] load_val;
  
  logic [15:0] load_val_ff;
  logic flag;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) load_val_ff <= '0;
    else if (load) load_val_ff <= load_val; // flop to store load value
  end   
  
  always @(posedge clk or negedge rst) begin
    if (!rst) flag <= '0;
    else if (Cnt + 8'd1 =='1) flag <='1; // if cnt has reached max limit, set the flag, start count down
    else if (Cnt - 8'd1 == load_val_ff) flag <='0;// when cnt has reach load value, count up with flag =0
  end
    
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Cnt <= '0;
    end
    else begin
      if (load) Cnt <= load_val;
      else if (flag == '1) Cnt <= Cnt - 8'd1; // when flag = 1, down counter
      else Cnt <= Cnt + 8'd1; //when flag = 0, up counter
    end
  end
endmodule
