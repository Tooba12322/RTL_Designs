// Waveform : https://www.edaplayground.com/w/x/C9J

`timescale 1ns/1ps

module ahb_m_tb ();
  logic clk, rst;
  parameter ADDRW = 32;
  parameter BYTE_CNTw = 16;
  parameter DATAW = 32;
  
  ahb_m DUT(.*);
  
  initial
  begin
    $dumpfile("ahb_m.vcd");
    $dumpvars(0,ahb_m_tb);
    
    clk = '0;
    rst = '0;
    DUT.in.req = '0;
    DUT.in.byte_cnt = '0;
    DUT.in.wr  = '0;
    DUT.in.wdata = '0;
    DUT.in.start_addr = '0;
    
    
    #7 @(posedge clk) rst = '1;
    #5;
    @(posedge clk) DUT.in.req = '1;
     // DUT.in.byte_cnt = $urandom_range(16'd30,16'd550);
    DUT.in.byte_cnt = 16'd1024;
    DUT.in.wr       = '1;
    DUT.in.start_addr = $urandom_range(32'd10,32'd100);
    
    wait(DUT.in.req_ack);
    #3 @(posedge clk) DUT.in.req = '0; 
    
    #1000 $finish;
  end
 
 always #8 DUT.out.hready = $random%2;
 always #5 clk = !clk;  
  
endmodule
