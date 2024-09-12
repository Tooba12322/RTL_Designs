// Waveform : https://www.edaplayground.com/w/x/Hqg

module apb_2_tb ();
  
  logic        clk,  rst;

  logic[1:0]   cmd_i;

  logic        psel_o;
  logic        penable_o;
  logic[31:0]  paddr_o;
  logic        pwrite_o;
  logic[31:0]  pwdata_o;
  logic        pready_i;
  logic[31:0]  prdata_i;
  
  apb_2 DUT(.*);
  
  initial begin
    //generate waveform
    $dumpfile("apb_2.vcd");
    $dumpvars(0,apb_2_tb);

    //Initialization
    clk = '0;
    rst = '0;
    pready_i = '1;
    cmd_i = '0;
     
    #9 rst = '1;
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
  always #2 clk = !clk;
  
endmodule

             
