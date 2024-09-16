//Waveform : 
module FIFO_FLUSH_tb ();
  
  parameter depth = 16;
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  logic full,empty;
  logic clk,rst,rd,wr;
  logic [width-1:0] wr_data; 
  logic [width-1:0] rd_data;
  
  FIFO_FLUSH DUT(.*);
  
  initial begin
    $dumpfile("FIFO.vcd");
    $dumpvars(0,FIFO_FLUSH_tb);
    $monitor ($time,"  rst=%b, clk=%b, wr=%b, rd=%b, FIFO[0]=%h, FIFO[1]=%h, FIFO[2]=%h, FIFO[5]=%h, FIFO[14]=%h, FIFO[15]=%h ",rst,clk,wr,rd,DUT.FIFO[0],DUT.FIFO[1],DUT.FIFO[2],DUT.FIFO[5],DUT.FIFO[14],DUT.FIFO[15]);
    
    clk = '0;
    rst = '0;
    rd  = '0;
    wr  = '0;
        
    #13  rst = '1;
    #2 @(posedge clk) wr = '1;
    wr_data = $urandom_range(0,16'hFFFF);
    
    repeat (16) begin 
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #10 wr  = '0;
    
    repeat (2) begin
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #2 rd = '1;
    
    #75 rd = '0;
    
    #2 @(posedge clk) wr = '1;
    wr_data = $urandom_range(0,16'hFFFF);
    
    repeat (4) begin 
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    wr = '0;
    rd = '1;
    
    #15 rd = '0;
    
    #10 $finish;
  end
    
  always #2 clk = !clk;

endmodule

