module seq_gen_tb();
  logic [31:0] seq_o;
  logic clk,reset;
 
  seq_generator DUT(.*);
  
 initial
  begin
    $dumpfile("seq_generator.vcd");
    $dumpvars(0,seq_gen_tb);
      
    clk = '0;
    reset = '1;
    
    #13 reset = '0;
  
    #200 $finish;
  end
  
 always #2 clk = !clk;  
  
endmodule

Waveform : https://www.edaplayground.com/w/x/NdN
