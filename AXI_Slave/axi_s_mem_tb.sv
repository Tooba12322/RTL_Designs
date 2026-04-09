// Waveform : 

module axi_s_mem_tb ();
  
  logic        aclk,  arst_n;


  logic[31:0]  prdata_i;
  
  axi_s_mem DUT(.*);
  
  initial begin
    //generate waveform
    $dumpfile("axi_s_mem.vcd");
    $dumpvars(0,axi_s_mem_tb);

    //Initialization
    aclk = '0;
    arst_n = '0;
    pready_i = '1;
    cmd_i = '0;
     
    #9 arst_n = '1;
    //Stimulus
    #5 cmd_i = 2'b01;
    for (int i=0; i<4; i++) begin
        prdata_i = $urandom_range(32'h0,32'hCAFEBEDF);
        pready_i = $random%5;
        #3;
    end
    
    cmd_i = 2'b10;
    for (int i=0; i<4; i++) begin
      pready_i = $random%2;
      #5;
    end
    
    #5 cmd_i = 2'b01;
    for (int i=0; i<4; i++) begin
        prdata_i = $urandom_range(32'h0,32'hCAFEBEDF);
        pready_i = $random%3;
        #3;
    end
    
    cmd_i = 2'b10;
    for (int i=0; i<4; i++) begin
      pready_i = $random%6;
      #5;
    end
    pready_i = '1;
    #20 $finish;
  end
  
   //Clk Generation 
  always #2 aclk = !aclk;
  
endmodule

             
