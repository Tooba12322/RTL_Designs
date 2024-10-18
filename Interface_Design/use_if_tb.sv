// Waveform : https://www.edaplayground.com/w/x/Wti

`timescale 1ns/1ps

module use_if_tb ();
  logic clk, rst;
  parameter ADDRW = 32;
  parameter BYTE_CNTw = 16;
  
  use_if DUT(.*);
  
  initial
  begin
    $dumpfile("use_if.vcd");
    $dumpvars(0,use_if_tb);
    
    clk = '0;
    rst = '0;
    DUT.in.req = '0;
    DUT.in.byte_cnt = '0;
    DUT.in.wr  = '0;
    DUT.out.req_ack = '0;
    DUT.in.start_addr = '0;
    
    #7 @(posedge clk) rst = '1;
    #5;
    for (int i=0; i<6; i++) begin // Drive slave(in) interface signal of use_if module
      @(posedge clk) DUT.in.req = '1;
      DUT.in.byte_cnt = $urandom_range(16'd30,16'd550);
      DUT.in.wr       = '1;
      DUT.in.start_addr = $urandom_range(32'd10,32'd100);
      DUT.out.req_ack = '1;
      #3 @(posedge clk) DUT.in.req = '0;
    
      wait(DUT.out.req); // Drive req_ack for master(out) interface signal of use_if module
      #3 @(posedge clk) DUT.out.req_ack = '0;
      
      #15;
    end   
    #100 $finish;
  end
  
 always #5 clk = !clk;  
  
endmodule


