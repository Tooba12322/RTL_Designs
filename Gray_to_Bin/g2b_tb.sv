module g2b_tb();
  logic [3:0] bin_o;
  logic [3:0] gr_in;
 
  g2b DUT(.*);
  
 initial
  begin
    $dumpfile("gray_to_bin.vcd");
    $dumpvars(0,g2b_tb);
    $monitor ($time,"  Gray=%b, Binary=%b",gr_in,bin_o);
    
    for (int i=0; i<10 ; i++) begin
      gr_in = $urandom_range(0,4'hF);
      #5;
    end
    #5 $finish;
  end
  
endmodule

Output : 
0  Gray=1001, Binary=1110
                   5  Gray=0100, Binary=0111
                  10  Gray=0000, Binary=0000
                  15  Gray=0011, Binary=0010
                  20  Gray=1000, Binary=1111
                  25  Gray=1100, Binary=1000
                  30  Gray=0011, Binary=0010
                  35  Gray=0000, Binary=0000
                  40  Gray=1000, Binary=1111
testbench.sv:17: $finish called at 55 (1s)

Waveform : https://www.edaplayground.com/w/x/7FK
