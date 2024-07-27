module edge_detect_tb ();
  logic In,clk,rst;
  logic P_edge,N_edge;
  
  edge_detect DUT(.*);
  
  always #4 clk=!clk;
  
  initial begin
    $dumpfile("Edge_Detector.vcd");
    $dumpvars(0,edge_detect_tb);
    $monitor ($time,"  Rst=%b, Clk=%b, In=%b, Pos_edge=%b, Neg_edge=%b  ",rst,clk,In,P_edge,N_edge);
  
    clk='0;
    rst = '0;  //async assertion
    @(negedge clk) rst <= '1;   //sync deassertion
    for (int i='0; i<33; i++) begin
      @(posedge clk) In <= $random%2;   
    end
    $finish;
  end
  
endmodule

Waveform :
https://www.edaplayground.com/w/x/TXK
