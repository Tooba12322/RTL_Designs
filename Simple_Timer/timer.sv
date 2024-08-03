// Design a timer that counts down from a preset value to zero and generates a timeout signal, 
// then again starts with preset value till next preset value is provided

module timer(time_out,preset,preset_val,clk,rst);
  
  output logic time_out;
  input logic preset,clk,rst;
  input logic [7:0] preset_val;
  
  logic [7:0] preset_val_ff;
  logic [7:0] Cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) preset_val_ff <= '0;
    else if (preset) preset_val_ff <= preset_val;
  end   
  
  always @(posedge clk or negedge rst) begin
    if (!rst) time_out <= '0;
    else if (Cnt - 8'd1 == '0) time_out <='1;
    else time_out <= '0;
  end
    
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Cnt <= '0;
    end
    else begin
      if (preset) Cnt <= preset_val;
      else if (time_out == '1) Cnt <= preset_val_ff; 
      else Cnt <= Cnt - 8'd1;
    end
  end
endmodule
 
