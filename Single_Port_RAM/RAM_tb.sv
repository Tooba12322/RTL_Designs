module RAM_tb ();
  inout logic [7:0] data;
  logic cs,mode,clk,rst;
  logic [9:0] addr;
  logic bi_en;
  logic [7:0] out_data_tb;
  RAM DUT(.*);
  
  initial begin
    $dumpfile("RAM.vcd");
    $dumpvars(0,RAM_tb);
    
    clk = '0;
    rst = '0;
    mode = '1;
    bi_en = '1;
    cs='1;
    
    #20 @(posedge clk)  rst = '1;
    
    repeat (10) begin 
      @(posedge clk) out_data_tb = $urandom_range(0,8'hFF);
      
      addr = $urandom_range(0,10'h00F);
    end
    
    
    @(posedge clk) mode = '0; bi_en = '0;
    addr = $urandom_range(0,10'h3FF);
    
    repeat (10) begin
      @(posedge clk)    addr = $urandom_range(0,10'h00F);
    end
    
    
    $finish;
  end
    
  always #2 clk = !clk;
  
  assign data = (bi_en) ? out_data_tb : 8'bx;
  
endmodule

