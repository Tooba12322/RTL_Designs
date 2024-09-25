// Waveform : 

module DB_tb ();
  
  logic sw,db;
  
  logic clk,rst;
  
  DB  DUT(.*);
  
  initial begin
    $dumpfile("DB.vcd");
    $dumpvars(0,DB_tb);
    //$monitor($time, " rst=%b, clk=%b, Out = %b",rst,clk,Out);   
    clk = '0;
    rst = '0;
    sw = '0;
    #9 rst = '1;
    #3 sw = '1;
    #25 sw = '0;
    #11 sw = '1;
    #25 sw = '0;
    #5  sw ='1;
    #500 sw='0;
    #3 sw = '1;
    #25 sw = '0;
    #11 sw = '1;
    #25 sw = '0;
    #5  sw ='0;
    #500 sw='1;
    #20 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
