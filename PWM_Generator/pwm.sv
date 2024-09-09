// Implement a Pulse Width Modulation (PWM) generator with adjustable duty cycle.

module pwm(pwm_out,duty_cycle_val,load,clk,rst);
  
  output logic pwm_out;
  input logic clk,rst,load;
  input logic [7:0] duty_cycle_val; // input value to set the duty cycle
  
  logic [7:0] Cnt;
  logic [7:0] duty_cycle_val_ff;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) duty_cycle_val_ff <= '0;
    else if (load) duty_cycle_val_ff <= duty_cycle_val; // duty_cycle value storage flop
  end   
  
  always @(posedge clk or negedge rst) begin
    if (!rst) Cnt <= '0;
    else if (Cnt < 8'd100) Cnt <= Cnt + 8'd1; //To define 100% as full time period of pwm signal
    else Cnt <= '0;
  end
  
  assign pwm_out = (Cnt < duty_cycle_val_ff) ? '1 : '0;
endmodule
 
