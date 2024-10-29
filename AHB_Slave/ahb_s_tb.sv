

// Waveform : https://www.edaplayground.com/w/x/Hhr
module ahb_s_tb ();
  
  logic clk;
  logic rst;
  logic hwrite;
  logic [31:0] hwdata; 
  logic [31:0] haddr;
  logic [2:0] hsize, hburst;
  logic [1:0] htrans;
  logic [3:0] hprot;
  logic hmastlock;
  logic [31:0] hrdata;
  logic hready, hresp;
  
  
  ahb_s DUT(.*);
  
  initial begin
    $dumpfile("ahb_s.vcd");
    $dumpvars(0,ahb_s_tb);
    $monitor($time,"  rst=%b, clk=%b, req_rnw_i=%b, req_addr_i=%h, MEM[0]=%h, MEM[1]=%h, MEM[2]=%h, MEM[3]=%h, MEM[4]=%h, MEM[5]=%h, MEM[6]=%h, MEM[7]=%h, MEM[8]=%h, MEM[9]=%h, MEM[10]=%h, MEM[11]=%h, MEM[12]=%h, MEM[13]=%h, MEM[14]=%h, MEM[15]=%h,req_rdata_o = %h ",rst,clk,DUT.mem.req_rnw_i,DUT.mem.req_addr_i,DUT.mem.mem[0],DUT.mem.mem[1],DUT.mem.mem[2],DUT.mem.mem[3],DUT.mem.mem[4],DUT.mem.mem[5],DUT.mem.mem[6],DUT.mem.mem[7],DUT.mem.mem[8],DUT.mem.mem[9],DUT.mem.mem[10],DUT.mem.mem[11],DUT.mem.mem[12],DUT.mem.mem[13],DUT.mem.mem[14],DUT.mem.mem[15],DUT.mem.req_rdata_o); 
    clk       = '0;
    rst       = '0;
    hwrite    = '0;
    hwdata    = '0; 
    haddr     = '0;
    hsize     = '0;
    hburst    = '0;
    htrans    = '0;
    hprot     = '0;
    hmastlock = '0;
    
    #9 rst = '1;
  
    // Write busrt of INCR16
    #5;
    wait(hready);
      hwrite    = '1; 
      haddr     =  $urandom_range('0,32'd16);
      hsize     =  3'd2;
      hburst    =  3'd7;
      htrans    =  2'd2;
    #5;
    wait(hready);
    
    for (int i='0;i<15;i++) begin
      wait(hready);
      @ (posedge clk); 
      haddr     =  $urandom_range('0,32'd16);
      htrans    =  2'd3;
      hwdata    =  $urandom_range('0,32'hFFFFFFFF);
      
      #7;
      
    end
    wait(hready);
    @ (posedge clk) htrans    =  2'd0;
    hwdata    =  $urandom_range('0,32'hFFFFFFFF);
    #2;
    
    // Read busrt of INCR8 
    #15;
    wait(hready);
      hwrite    = '0; 
      haddr     =  $urandom_range('0,32'd16);
      hsize     =  3'd2;
      hburst    =  3'd5;
      htrans    =  2'd2;
    #5;
    wait(hready);
    
    for (int i='0;i<7;i++) begin
      wait(hready);
      @ (posedge clk); 
      haddr     =  $urandom_range('0,32'd16);
      htrans    =  2'd3;
      #7; 
    end
    wait(hready);
    @ (posedge clk) htrans    =  2'd0;
    
    
    #20 $finish;
  end
    
  always #5 clk = !clk;



  //Not related to AHB slave

  module atomic_counters (
  input                   clk,
  input                   reset,
  input                   trig_i,
  input                   req_i,
  input                   atomic_i,
  output logic            ack_o,
  output logic[31:0]      count_o
);

  
  logic [63:0] count_q;
  logic [63:0] count;
  logic ack;
  logic[31:0] cnt;

  assign ack_o = ack;
  assign count_o = cnt;
  
  always_comb count = (trig_i) ? count_q + 64'h1 : count_q;
    
  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_q[63:0] <= 64'h0;
    else
      count_q[63:0] <= count;
 
  always_ff @(posedge clk or posedge reset)
    if (reset)
      ack <= 1'h0;
    else if (req_i)
      ack <= 1'h1;
    else ack <= 1'h0;
  
  always_ff @(posedge clk or posedge reset)
    if (reset)
      cnt <= 32'h0;
    else if (req_i) 
      cnt <= (atomic_i) ? (trig_i) ? count[31:0] : count_q[31:0] : count_q[63:32];
    else cnt <= 32'h0;
 

endmodule


  
endmodule

             
