module b2g_tb();
  logic [3:0] bin;
  logic [3:0] gr_o;
 
  b2g DUT(.*);
  
 initial
  begin
    $dumpfile("bin_to_gray.vcd");
    $dumpvars(0,b2g_tb);
    $monitor ($time,"  Binary=%b, Gray=%b",bin,gr_o);
    
    for (int i=0; i<10 ; i++) begin
      bin = $urandom_range(0,4'hF);
      #5;
    end
    #5 $finish;
  end
  
endmodule

Output :
0  Binary=1001, Gray=1101
                   5  Binary=0100, Gray=0110
                  10  Binary=0000, Gray=0000
                  15  Binary=0011, Gray=0010
                  20  Binary=1000, Gray=1100
                  25  Binary=1100, Gray=1010
                  30  Binary=0011, Gray=0010
                  35  Binary=0000, Gray=0000
                  40  Binary=1000, Gray=1100
testbench.sv:17: $finish called at 55 (1s)

Waveform : https://www.edaplayground.com/w/x/UnF
