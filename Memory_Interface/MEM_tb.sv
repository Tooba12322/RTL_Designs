//Waveform : 

module MEM_tb ();
  
  logic      clk,
  logic      rst,

  logic       req_i,
  logic       req_rnw_i,    // 1 - read, 0 - write
  logic [3:0] req_addr_i,
  logic [31:0]req_wdata_i,
  logic       req_ready_o,
  logic [31:0]req_rdata_o
 
  
  MEM DUT(.*);
  
  initial begin
    $dumpfile("MEM.vcd");
    $dumpvars(0,MEM_tb);
    $monitor ($time,"  rst=%b, clk=%b, wr=%b, rd=%b, FIFO[0]=%h, FIFO[1]=%h, FIFO[2]=%h, FIFO[5]=%h, FIFO[14]=%h, FIFO[15]=%h ",rst,clk,wr,rd,DUT.FIFO[0],DUT.FIFO[1],DUT.FIFO[2],DUT.FIFO[5],DUT.FIFO[14],DUT.FIFO[15]);
    
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
      req_addr_i = (req_ready_o) ? $urandom_range(0,4'hF) : '0;
    end
    
    #50 $finish;
  end
    
  always #2 clk = !clk;

endmodule
