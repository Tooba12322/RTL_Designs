

// Waveform : https://www.edaplayground.com/w/x/Vse

module apb_tb ();
  
  logic        clk,  rst;
  logic        psel_i;
  logic        penable_i;
  logic [3:0]  paddr_i;
  logic        pwrite_i;
  logic [31:0] pwdata_i;
  logic [31:0] prdata_o;
  logic        pready_o;
  
  
  apb DUT(.*);
  
  initial begin
    $dumpfile("apb.vcd");
    $dumpvars(0,apb_tb);
    $monitor($time,"  rst=%b, clk=%b, req_rnw_i=%b, req_addr_i=%h, MEM[0]=%h, MEM[1]=%h, MEM[2]=%h, MEM[3]=%h, MEM[4]=%h, MEM[5]=%h, req_rdata_o = %h ",rst,clk,DUT.mem.req_rnw_i,DUT.mem.req_addr_i,DUT.mem.mem[0],DUT.mem.mem[1],DUT.mem.mem[2],DUT.mem.mem[3],DUT.mem.mem[4],DUT.mem.mem[5],DUT.mem.req_rdata_o); 
    clk       = '0;
    rst       = '0;
    psel_i    = '0;
    penable_i = '1;
    paddr_i   = '0;
    pwrite_i  = '0;
    pwdata_i  = '0;
    
    #9 rst = '1;
  
    #5;
    for (int i='0;i<16;i++) begin
      wait(pready_o);
      psel_i    = '1;
      penable_i = '0;
      paddr_i   =  $urandom_range('0,4'hF);
      pwrite_i  = '1;
      pwdata_i  = $urandom_range('0,32'hFFFFFFFF);
    
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
        @ (posedge clk) psel_i = '0;
      end
      
      #7;
      
    end
    #2;
    
    for (int i='0;i<16;i++) begin
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
      
    end
    
    #10 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

             
