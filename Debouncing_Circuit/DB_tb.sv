// Waveform : 

module DB_tb ();
  
  logic sw,db;
  
  logic clk,rst;
  
  DB  DUT(.*);
  
  initial begin
    $dumpfile("DB.vcd");
    $dumpvars(0,DB_tb);
    //$monitor($time, " rst=%b, clk=%b, db = %b",rst,clk,db);   
    clk = '0;
    rst = '0;
    sw = '0;
    #9 rst = '1;
    #100 sw = '1;
    for (int i='0;i<12;i++) begin
      sw = !sw;
      #10;
    end
    sw = '1;
    #3000 sw='0;
    for (int i='0;i<9;i++) begin
      sw = !sw;
      #6;
    end
    sw = '0;
    #4000 sw='1;
    for (int i='0;i<6;i++) begin
      sw = !sw;
      #13;
    end
    sw = '1;
    #4000 sw='0;
    #550 $finish;
  end
    
  always #5 clk = !clk;
  
endmodule
