// Waveform : 

module cir_fifo_tb ();
  
  parameter depth = 16;
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  logic full,empty;
  logic clk,rst,rd,wr;
  logic [width-1:0] wr_data; 
  logic [width-1:0] rd_data;
  
  cir_fifo DUT(.*);
  
  initial begin
    $dumpfile("cir_fifo.vcd");
    $dumpvars(0,cir_fifo_tb);
    
    clk = '0;
    rst = '0;
    rd  = '0;
    wr  = '0;
        
    #20 @(posedge clk)  rst = '1;
    wr = '1;
    
    repeat (16) begin 
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #10 wr  = '0;
    
    repeat (2) begin
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #5 rd = '1;
    
    #50 rd = '0;
    
    #10 $finish;
  end
    
  always #2 clk = !clk;

endmodule
