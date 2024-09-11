//Waveform : 

module async_FIFO_tb ();
  
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
    $monitor ($time,"  r_rst=%b, r_clk=%b, w_rst=%b, w_clk=%b,  wr=%b, rd=%b, FIFO[0]=%h, FIFO[1]=%h, FIFO[2]=%h, FIFO[5]=%h, FIFO[14]=%h, FIFO[15]=%h ",r_rst,r_clk,w_rst,w_clk,wr,rd,DUT.FIFO[0],DUT.FIFO[1],DUT.FIFO[2],DUT.FIFO[5],DUT.FIFO[14],DUT.FIFO[15]);
    
    r_clk = '0;
    r_rst = '0;
    w_clk = '0;
    w_rst = '0;
    rd  = '0;
    wr  = '0;
        
    #13  w_rst = '1;
    r_rst = '1;
    #2 @(posedge w_clk) wr = '1;
    wr_data = $urandom_range(0,16'hFFFF);
    
    repeat (8) begin 
      @(posedge w_clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #10 wr  = '0;
    
    repeat (2) begin
      @(posedge w_clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #2 rd = '1;
    
    #40 rd = '0;
    
    #2 @(posedge w_clk) wr = '1;
    wr_data = $urandom_range(0,16'hFFFF);
    
    repeat (4) begin 
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    wr = '0;
    rd = '1;
    
    #15 rd = '0;
    
    #10 $finish;
  end
    
  always #2 w_clk = !w_clk;
  
  always #4 r_clk = !r_clk;

endmodule
