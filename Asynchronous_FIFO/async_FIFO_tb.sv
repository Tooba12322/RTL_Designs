//Waveform (w_clk>r_clk) : https://www.edaplayground.com/w/x/7NW
//Waveform (r_clk>w_clk) : https://www.edaplayground.com/w/x/4ur

module async_FIFO_tb();
  
  parameter depth = 8;
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  logic full,empty;
  logic r_clk,r_rst,w_clk,w_rst,rd,wr;;
  logic [width-1:0] wr_data; 
  logic [width-1:0] rd_data;
  
  async_FIFO DUT(.*);
  
  initial begin
    $dumpfile("async_FIFO.vcd");
    $dumpvars(0,async_FIFO_tb);
    $monitor ($time,"  r_rst=%b, r_clk=%b, w_rst=%b, w_clk=%b,  wr=%b, rd=%b, FIFO[0]=%h, FIFO[1]=%h, FIFO[6]=%h, FIFO[7]=%h ",r_rst,r_clk,w_rst,w_clk,wr,rd,DUT.FIFO[0],DUT.FIFO[1],DUT.FIFO[6],DUT.FIFO[7]);
    
    r_clk = '0;
    r_rst = '0;
    w_clk = '0;
    w_rst = '0;
    rd  = '0;
    wr  = '0;
        
    #13  w_rst = '1;
    r_rst = '1;
    #2 @(posedge w_clk) wr = '1;
    wr_data = $urandom_range(0,8'hFF);
    
    repeat (8) begin 
      @(posedge w_clk) wr_data = $urandom_range(0,8'hFF); 
    end
    
    #10 wr  = '0;
    
    repeat (2) begin
      @(posedge w_clk) wr_data = $urandom_range(0,8'hFF); 
    end
    
    #2 rd = '1;
    
    #40 rd = '0;
    
    #2 @(posedge w_clk) wr = '1;
    wr_data = $urandom_range(0,8'hFF);
    
    repeat (4) begin 
      @(posedge w_clk) wr_data = $urandom_range(0,8'hFF); 
    end
    
    wr = '0;
    rd = '1;
    
    #15 rd = '0;
    
    #10 $finish;
  end
  // w_clk > r_clk 
  always #2 w_clk = !w_clk;
  
  always #4 r_clk = !r_clk;
  // r_clk > w_clk
  always #3 r_clk = !r_clk;
  
  always #5 w_clk = !w_clk;

endmodule
