module b21h_tb ();
  parameter Bin_w = 4;
  parameter O_w = 2**Bin_w;
  logic [Bin_w-1:0] Bin;
  logic [O_w-1:0] One_Hot;
  
  b21h DUT(.*);
  
  initial begin
    $dumpfile("Bin_to_OneHot.vcd");
    $dumpvars(0,b21h_tb);
    $monitor ($time,"  Binary_input=%b, One_Hot=%b ",Bin,One_Hot);
    
    for (int i=0; i<33 ; i++) begin
      Bin = $urandom_range(0,4'hF);
      #5;
    end
    
    $finish;
  end
endmodule

Waveform : https://www.edaplayground.com/w/x/JbY
