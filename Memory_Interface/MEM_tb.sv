//Waveform : 

module MEM_tb ();
  
  logic      clk;
  logic      rst;

  logic       req_i;
  logic       req_rnw_i;    // 1 - read, 0 - write
  logic [3:0] req_addr_i;
  logic [31:0]req_wdata_i;
  logic       req_ready_o;
  logic [31:0]req_rdata_o;
 
  
  MEM DUT(.*);
  
  initial begin
    $dumpfile("MEM.vcd");
    $dumpvars(0,MEM_tb);
    $monitor($time,"  rst=%b, clk=%b, req_rnw_i=%b, req_addr_i=%h, MEM[0]=%h, MEM[4]=%h, MEM[3]=%h, MEM[5]=%h, MEM[8]=%h, MEM[12]=%h, req_rdata_o = %h ",rst,clk,req_rnw_i,req_addr_i,DUT.mem[0],DUT.mem[4],DUT.mem[3],DUT.mem[5],DUT.mem[8],DUT.mem[12],req_rdata_o);
    
    clk = '0;
    rst = '0;
    req_i  = '0;
    req_rnw_i = '0;    // 1 - read, 0 - write
    req_addr_i = '0;
    req_wdata_i ='0;
        
    #13  rst = '1;
    
    #5 @(posedge clk) req_i = '1;
    req_wdata_i = (req_ready_o) ? $urandom_range(0,32'hFFFFFFFF) : '0;
    req_addr_i = (req_ready_o) ? $urandom_range(0,4'hF) : '0;
    
    repeat (10) begin 
      @(posedge clk) req_wdata_i = (req_ready_o) ?$urandom_range(0,32'hFFFFFFFF) : '0;
      req_addr_i = (req_ready_o) ? $urandom_range(0,4'hF) : '0;
    end
    
    req_i  = '0;
    
    #10 @(posedge clk) req_i = '1;
    req_rnw_i  = '1;
    
    repeat (10) begin 
      @(posedge clk) req_addr_i = (req_ready_o) ? $urandom_range(0,4'hC) : '0;
    end
    
    #10 $finish;
  end
    
  always #2 clk = !clk;

endmodule

Output :
0  rst=0, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                   2  rst=0, clk=1, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                   4  rst=0, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                   
                  12  rst=0, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  13  rst=1, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  14  rst=1, clk=1, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  16  rst=1, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  18  rst=1, clk=1, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  20  rst=1, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=00000000, MEM[4]=00000000, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  22  rst=1, clk=1, req_rnw_i=0, req_addr_i=4, MEM[0]=00000000, MEM[4]=92153524, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  24  rst=1, clk=0, req_rnw_i=0, req_addr_i=4, MEM[0]=00000000, MEM[4]=92153524, MEM[3]=00000000, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  26  rst=1, clk=1, req_rnw_i=0, req_addr_i=3, MEM[0]=00000000, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  28  rst=1, clk=0, req_rnw_i=0, req_addr_i=3, MEM[0]=00000000, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=00000000, req_rdata_o = 00000000 
                  30  rst=1, clk=1, req_rnw_i=0, req_addr_i=c, MEM[0]=00000000, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  32  rst=1, clk=0, req_rnw_i=0, req_addr_i=c, MEM[0]=00000000, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  34  rst=1, clk=1, req_rnw_i=0, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  36  rst=1, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  38  rst=1, clk=1, req_rnw_i=0, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  40  rst=1, clk=0, req_rnw_i=0, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=00000000, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  42  rst=1, clk=1, req_rnw_i=0, req_addr_i=8, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  44  rst=1, clk=0, req_rnw_i=0, req_addr_i=8, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  46  rst=1, clk=1, req_rnw_i=0, req_addr_i=9, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  48  rst=1, clk=0, req_rnw_i=0, req_addr_i=9, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=86b97b0d, req_rdata_o = 00000000 
                  50  rst=1, clk=1, req_rnw_i=0, req_addr_i=c, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  
                  66  rst=1, clk=1, req_rnw_i=0, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  68  rst=1, clk=0, req_rnw_i=0, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  70  rst=1, clk=1, req_rnw_i=1, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  72  rst=1, clk=0, req_rnw_i=1, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  74  rst=1, clk=1, req_rnw_i=1, req_addr_i=c, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  76  rst=1, clk=0, req_rnw_i=1, req_addr_i=c, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  78  rst=1, clk=1, req_rnw_i=1, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 32c28465 
                  80  rst=1, clk=0, req_rnw_i=1, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 32c28465 
                  82  rst=1, clk=1, req_rnw_i=1, req_addr_i=3, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 0484d609 
                  84  rst=1, clk=0, req_rnw_i=1, req_addr_i=3, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 0484d609 
                  86  rst=1, clk=1, req_rnw_i=1, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 32c28465 
                  88  rst=1, clk=0, req_rnw_i=1, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 32c28465 
                  90  rst=1, clk=1, req_rnw_i=1, req_addr_i=a, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  92  rst=1, clk=0, req_rnw_i=1, req_addr_i=a, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                  94  rst=1, clk=1, req_rnw_i=1, req_addr_i=c, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = f6d457ed 
                  96  rst=1, clk=0, req_rnw_i=1, req_addr_i=c, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = f6d457ed 
                  98  rst=1, clk=1, req_rnw_i=1, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                 100  rst=1, clk=0, req_rnw_i=1, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                 102  rst=1, clk=1, req_rnw_i=1, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 32c28465 
                 104  rst=1, clk=0, req_rnw_i=1, req_addr_i=0, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 32c28465 
                 106  rst=1, clk=1, req_rnw_i=1, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 
                
testbench.sv:50: $finish called at 120 (1s)
                 120  rst=1, clk=0, req_rnw_i=1, req_addr_i=5, MEM[0]=32c28465, MEM[4]=92153524, MEM[3]=0484d609, MEM[5]=00000000, MEM[8]=80f3e301, MEM[12]=f6d457ed, req_rdata_o = 00000000 

