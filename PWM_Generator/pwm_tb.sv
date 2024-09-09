// Waveform : https://www.edaplayground.com/w/x/RVX

module pwm_tb ();
  logic pwm_out;
  logic clk,rst,load;
  logic [7:0] duty_cycle_val; 
  
  pwm DUT(.*);
  
  initial begin
    $dumpfile("PWM.vcd");
    $dumpvars(0,pwm_tb);
    
    clk = '0;
    rst = '0;
    load = '0;
    #20 @(posedge clk);
    rst = '1;
    load = '1;// load into duty cycle flop
    duty_cycle_val = 8'd20; // duty cycle value - 20% 
    
    #3 load = '0;
    
    #400 @(posedge clk); 
    load = '1;
    duty_cycle_val = 8'd75; // // duty cycle value  later again - 75%
    
    #3 load = '0;
    
    #400 @(posedge clk); 
    load = '1;
    duty_cycle_val = 8'd50; // // duty cycle value  later again - 50%
    
    #3 load = '0;
    
    #450 $finish;
  end
    
  always #2 clk = !clk; // clk generation
  
endmodule
