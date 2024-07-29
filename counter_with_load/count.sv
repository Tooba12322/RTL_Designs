// Implement the counter
  // - Resets to 0
  // - Increments by 1 every cycle
  // - Takes the load value if load_i is seen
  // - Starts back from the load value after overflow
  
module Counter(Cnt,load,load_val,clk,rst);
  output logic [15:0] Cnt;
  input logic load,clk,rst;
  input logic [15:0] load_val;
  
  logic [15:0] load_val_ff;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) load_val_ff <= '0;
    else if (load) load_val_ff <= load_val;
  end   
      
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Cnt <= '0;
    end
    else begin
      Cnt <= load ? load_val : (Cnt == '1) ? load_val_ff : Cnt + 16'd1;
    end
  end
endmodule
