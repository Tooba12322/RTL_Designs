//Waveform : 

module FIFO_FLUSH_tb ();
  
  parameter depth = 32;
  parameter rd_width = 32;
  parameter wr_width = 4;
  parameter addr  = $clog2(depth);
  
  logic full,empty,flush_done,vld_rd_data;
  logic clk,rst,rd,wr,flush_req;
  logic [wr_width-1:0] wr_data; 
  logic [rd_width-1:0] rd_data;
  
  FIFO_FLUSH DUT(.*);
  
  initial begin
    $dumpfile("FIFO.vcd");
    $dumpvars(0,FIFO_FLUSH_tb);
    //$monitor ($time,"  rst=%b, clk=%b, wr=%b, rd=%b, FIFO[0]=%h, FIFO[1]=%h, FIFO[2]=%h, FIFO[5]=%h, FIFO[14]=%h, FIFO[15]=%h ",rst,clk,wr,rd,DUT.FIFO[0],DUT.FIFO[1],DUT.FIFO[2],DUT.FIFO[5],DUT.FIFO[14],DUT.FIFO[15]);
    
    clk = '0;
    rst = '0;
    rd  = '0;
    wr  = '0;
    flush_req ='0;
    
    #13  rst = '1;
    #2 @(posedge clk) wr = '1;
    wr_data = $urandom_range(0,4'hF);
    
    repeat (32) begin 
      @(posedge clk) wr_data = $urandom_range(0,4'hF); 
    end
    
    wr  = '0;
    
    #5 rd = '1;
    
    #75 rd = '0;
    
    #2 @(posedge clk) wr = '1;
    wr_data = $urandom_range(0,4'hF);
    
    repeat (4) begin 
      @(posedge clk) wr_data = $urandom_range(0,4'hF); 
    end
    
    wr = '0;
    rd = '1;
    
    #15 rd = '0;
    
    #10 $finish;
  end
    
  always #2 clk = !clk;

endmodule
