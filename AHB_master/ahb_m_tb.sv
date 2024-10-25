// Waveform : 

`timescale 1ns/1ps

module ahb_m_tb ();
  logic clk, rst;
  parameter ADDRW = 32;
  parameter BYTE_CNTw = 16;
  parameter DATAW = 256;
  
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
    DUT.out.hresp='1;
    
    
    #7 @(posedge clk) rst = '1;
    #5;
    @(posedge clk) DUT.in.req = '1;
    DUT.in.byte_cnt = $urandom_range(16'd600,16'd1000);
    DUT.in.wr       = '1;
    DUT.in.start_addr = $urandom_range(32'd10,32'd100);
    DUT.in.wdata = $urandom_range(32'd1000,32'd2000);
    
    #30;
    
    /*wait(DUT.in.req_ack);
    #5 @(posedge clk) DUT.in.req = '1;
    DUT.in.byte_cnt = 16'd128;
    DUT.in.wr       = '0;
    DUT.in.start_addr = $urandom_range(32'd10,32'd100);
    
    #50;
    
    wait(DUT.in.req_ack);
    #5 @(posedge clk) DUT.in.req = '1;
    DUT.in.byte_cnt = $urandom_range(16'd2,16'd30);
    DUT.in.wr       = '1;
    DUT.in.start_addr = $urandom_range(32'd10,32'd100);
    DUT.in.wdata = $urandom_range(32'd1000,32'd2000);*/
    
    #50;
    
    wait(DUT.in.req_ack);
    #5 @(posedge clk) DUT.in.req = '0;
    
    #1000 $finish;
    
  end
 
 always #8 DUT.out.hready = $random%2;
 always begin
   wait(DUT.in.wr_done);
   #2;
   DUT.in.wdata = $urandom_range(32'd1000,32'd5000);
 end
 always begin
   wait(!DUT.out.hwrite && DUT.out.htrans!='0 && DUT.out.hready);
   #2;
   DUT.out.hrdata = $urandom_range(32'd100,32'd700);
 end
 always #5 clk = !clk;  
  
endmodule
