// Waveform : 

module traffic_light_tb ();
  
  logic [6*8:1] Out;
  
  logic clk,rst;
  
  traffic_light DUT(.*);
  
  initial begin
    $dumpfile("traffic_light.vcd");
    $dumpvars(0,traffic_light_tb);
    $monitor($time, " rst=%b, clk=%b,  Light = %s",rst,clk,Out);   
    clk = '0;
    rst = '0;
    
    #9 rst = '1;
    
        
    #70 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

Output :

0 rst=0, clk=0,  Light =    RED
                   2 rst=0, clk=1,  Light =    RED
                   4 rst=0, clk=0,  Light =    RED
                   6 rst=0, clk=1,  Light =    RED
                   8 rst=0, clk=0,  Light =    RED
                   9 rst=1, clk=0,  Light =    RED
                  10 rst=1, clk=1,  Light =    RED
                  12 rst=1, clk=0,  Light =    RED
                  14 rst=1, clk=1,  Light =    RED
                  16 rst=1, clk=0,  Light =    RED
                  18 rst=1, clk=1,  Light =    RED
                  20 rst=1, clk=0,  Light =    RED
                  22 rst=1, clk=1,  Light =  GREEN
                  24 rst=1, clk=0,  Light =  GREEN
                  26 rst=1, clk=1,  Light =  GREEN
                  28 rst=1, clk=0,  Light =  GREEN
                  30 rst=1, clk=1,  Light =  GREEN
                  32 rst=1, clk=0,  Light =  GREEN
                  34 rst=1, clk=1,  Light =  GREEN
                  36 rst=1, clk=0,  Light =  GREEN
                  38 rst=1, clk=1,  Light = YELLOW
                  40 rst=1, clk=0,  Light = YELLOW
                  42 rst=1, clk=1,  Light = YELLOW
                  44 rst=1, clk=0,  Light = YELLOW
                  46 rst=1, clk=1,  Light = YELLOW
                  48 rst=1, clk=0,  Light = YELLOW
                  50 rst=1, clk=1,  Light = YELLOW
                  52 rst=1, clk=0,  Light = YELLOW
                  54 rst=1, clk=1,  Light =    RED
                  56 rst=1, clk=0,  Light =    RED
                  58 rst=1, clk=1,  Light =    RED
                  60 rst=1, clk=0,  Light =    RED
                  62 rst=1, clk=1,  Light =    RED
                  64 rst=1, clk=0,  Light =    RED
                  66 rst=1, clk=1,  Light =    RED
                  68 rst=1, clk=0,  Light =    RED
                  70 rst=1, clk=1,  Light =  GREEN
                  72 rst=1, clk=0,  Light =  GREEN
                  74 rst=1, clk=1,  Light =  GREEN
                  76 rst=1, clk=0,  Light =  GREEN
                  78 rst=1, clk=1,  Light =  GREEN
testbench.sv:21: $finish called at 79 (1s)
