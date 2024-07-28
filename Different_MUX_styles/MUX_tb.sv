// MUX tb
module MUX_tb ();
 logic y1;
 logic y2;
 logic y3;
 logic y4;
 logic y5;
 logic y6;
 logic [3:0]In;
 logic [1:0]Sel;
  
  MUX DUT(.*);
  
  initial begin
    $dumpfile("4X1_MUX.vcd");
    $dumpvars(0,MUX_tb);
    $monitor ($time,"  y1=%b, y2=%b, y3=%b, y4=%b, y5=%b, y5=%b, In=%b, Sel=%b ",y1,y2,y3,y4,y5,y6,In,Sel);
    
    
      
    for (int j=0; j<20 ; j++) begin
      In = $urandom_range(0,4'hF);
      #5;
      for (int i=0; i<5 ; i++) begin
        Sel = $urandom_range(0,2'h3);
        #5;
      end
    end
    
    $finish;
  end
  
endmodule

Waveform : https://www.edaplayground.com/w/x/RNW
