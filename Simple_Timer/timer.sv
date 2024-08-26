// Design a timer that counts down from a preset value to zero and generates a timeout signal, 
// then again starts with preset value till next preset value is provided

module timer(time_out,preset,preset_val,clk,rst);
  
  output logic time_out;
  input logic preset,clk,rst;
  input logic [7:0] preset_val; // input value to set the timer
  
  logic [7:0] preset_val_ff;
  logic [7:0] Cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) preset_val_ff <= '0;
    else if (preset) preset_val_ff <= preset_val; // preset value storage flop
  end   
  
  always @(posedge clk or negedge rst) begin
    if (!rst) time_out <= '0;
    else if (Cnt - 8'd1 == '0) time_out <='1; // when cnt=0, timeout=1 at posedge clk
    else time_out <= '0;
  end
    
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Cnt <= '0;
    end
    else begin
      if (preset) Cnt <= preset_val;
      else if (time_out == '1) Cnt <= preset_val_ff; // next cycle cnt fromthe preset value, when timeout=1
      else Cnt <= Cnt - 8'd1;// down counter for timer
    end
  end
endmodule
 
