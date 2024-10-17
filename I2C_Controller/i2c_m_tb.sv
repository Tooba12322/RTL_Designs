
// Waveform : 

`timescale 1ns/1ps
module i2c_m_tb();
 
  logic ready,cmd_done,ack,nack;
  logic [7:0] rd_out;
  tri sda;
  tri sclk;
  logic store_cmd,clk,rst;
  logic [2:0] cmd;
  logic [7:0] din;
  logic [15:0] dvsr;

  i2c_m DUT(.*);
    
 initial
  begin
    $dumpfile("i2c_m.vcd");
    $dumpvars(0,i2c_m_tb);
    
    rst      = '0;
    store_cmd= '0;
    clk      = '0;
    din      = '0;
    cmd      = '0;
    dvsr     = '0;
    ack      = '0;
    
    #7 @(posedge clk) rst = '1;
    wait(ready);
    #7 @(posedge clk) store_cmd = '1; din = 8'h92; dvsr = 16'd25; // for 100MHz system clk, and 1MHz sclk,dvsr should be 250, reducing due to simulation time
    #3 @(posedge clk) store_cmd = '0;
    
    wait(cmd_done);
    @(posedge clk) store_cmd = '1; cmd = 3'd1;
    
    wait(cmd_done);
    @(posedge clk) store_cmd = '1; cmd = 3'd4; ack = '1;
    
    wait(cmd_done);
    @(posedge clk) store_cmd = '1; cmd = 3'd2; ack = '0;
    
    wait(cmd_done);
     @(posedge clk) store_cmd = '1; cmd = 3'd3;

   #12000 $finish;
  end
 
   always #5 clk = !clk; 
endmodule
