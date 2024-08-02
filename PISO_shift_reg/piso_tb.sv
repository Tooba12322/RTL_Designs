module piso_reg_tb();
 
  logic clk,rst,load;
  logic [3:0] D;
  logic [3:0] Q;
  
  PISO DUT(.*);
    
 initial
  begin
    $dumpfile("PISO_reg.vcd");
    $dumpvars(0,piso_reg_tb);
    
    clk = '0;
    rst = '0;
    load = '0;
    D='0;
    #3 @(posedge clk) rst = '1;
    for (int i='0;i<5;i++) begin
      #5 @(posedge clk) load = '1; D=$urandom_range(0,4'hF);
      #3 @(posedge clk) load = '0; D[3] = $random%2;
      #5;
    end
    
    #15 $finish;
  end
  
 always #2 clk = !clk;  
 
endmodule

Waveform : https://www.edaplayground.com/w/x/7GC
