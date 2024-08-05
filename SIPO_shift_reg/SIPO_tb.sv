// Waveform : 

module SIPO_tb ();
  
  logic [7:0] parallel_out;
  logic sr_in,clk,rst;
  
  SIPO DUT(.*); // instantiation
  
  initial begin
    $dumpfile("SIPO.vcd");
    $dumpvars(0,SIPO_tb); //generate waveform
    
    clk = '0; // initialization
    rst = '0;
    sr_in = '0;
    #17 sr_in = '1;
    rst = '1;
    
    repeat (35) begin // Stimulus
      sr_in = $random%3;
      #3;
    end
    
    #5 $finish;
  end
    
  always #2 clk = !clk; // clk generation
  
endmodule
