// Waveform : https://www.edaplayground.com/w/x/PzZ

module apb_1_tb ();
  
  logic        clk,  rst;
   
  logic         event_a_i;
  logic         event_b_i;
  logic         event_c_i;

  logic        psel_o;
  logic        penable_o;
  logic[31:0]  paddr_o;
  logic        pwrite_o;
  logic[31:0]  pwdata_o;
  logic        pready_i;
  logic[31:0]  prdata_i;
  
  apb_1 DUT(.*);
  
  initial begin
    $dumpfile("apb_1.vcd");
    $dumpvars(0,apb_1_tb);
     
    clk = '0;
    rst = '0;
    pready_i = '1;
    event_a_i = '0;
    event_b_i = '0;
    event_c_i = '0;
    
    #9 rst = '1;
  
    for (int i=0; i<20; i++) begin
      pready_i =  $random%15;
      event_a_i = $random%5;
      event_b_i = $random%7;
      event_c_i = $random%9;
      #5;
    end
    
    #50 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

             
