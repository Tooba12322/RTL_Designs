

// Waveform : https://www.edaplayground.com/w/x/Vse

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
    $monitor($time,"  rst=%b, clk=%b, req_rnw_i=%b, req_addr_i=%h, MEM[0]=%h, MEM[1]=%h, MEM[2]=%h, MEM[3]=%h, MEM[4]=%h, MEM[5]=%h, req_rdata_o = %h ",rst,clk,DUT.mem.req_rnw_i,DUT.mem.req_addr_i,DUT.mem.mem[0],DUT.mem.mem[1],DUT.mem.mem[2],DUT.mem.mem[3],DUT.mem.mem[4],DUT.mem.mem[5],DUT.mem.req_rdata_o); 
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
    
    /*for (int i='0;i<16;i++) begin
      wait(pready_o);
      psel_i    = '1;
      penable_i = '0;
      paddr_i   = $urandom_range('0,4'hF);
      pwrite_i  = '0;
          
      #2 @ (posedge clk) penable_i = '1;
      
      if (!pready_o) begin
        wait (pready_o);
        #3;
        wait (pready_o);
        #4 @ (posedge clk) psel_i = '0;
      end
      else begin
        #3;
        wait (pready_o);
        #4 @ (posedge clk) psel_i = '0;
      end
      
      #7;
      
    end*/
    
    #100 $finish;
  end
    
  always #5 clk = !clk;
  
endmodule

             
