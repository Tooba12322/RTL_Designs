//Waveform

module RAM_tb ();
  logic [7:0] data;
  logic cs,mode,clk,rst;
  logic [9:0] addr;
  
  RAM DUT(.*);
  
  initial begin
    $dumpfile("RAM.vcd");
    $dumpvars(0,RAM_tb);
    
    clk = '0;
    rst = '0;
    mode = '1;
    #20 @(posedge clk)  rst = '1;
    
    repeat (10) begin 
      @(posedge clk) data = $urandom_range(0,8'hFF);
      @(posedge clk) addr = $urandom_range(0,10'h3FF);
    end
    
    
    @(posedge clk) mode = '0;
    @(posedge clk) addr = $urandom_range(0,10'h3FF);
    
    repeat (10) begin
      @(posedge clk)    addr = $urandom_range(0,10'h3FF);
    end
    #50 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

