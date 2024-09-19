
// Waveform : https://www.edaplayground.com/w/x/PzZ

module apb_tb ();
  
  logic        clk,  rst;
  logic        psel_i;
  logic        penable_i;
  logic [3:0]  paddr_i;
  logic        pwrite_i;
  logic [31:0] pwdata_i;
  logic [31:0] prdata_o;
  logic        pready_o;
  
  
  apb DUT(.*);
  
  initial begin
    $dumpfile("apb.vcd");
    $dumpvars(0,apb_tb);
     
    clk       = '0;
    rst       = '0;
    psel_i    = '0;
    penable_i = '1;
    paddr_i   = '0;
    pwrite_i  = '0;
    pwdata_i  = '0;
    
    #9 rst = '1;
  
    #5;
    @ (posedge clk);
    psel_i    = '1;
    penable_i = '1;
    paddr_i   = $urandom_range('0,4'hF);
    pwrite_i  = '1;
    pwdata_i  = $urandom_range('0,4'hF);
    
    #2;
    @ (posedge clk);
    penable_i = '0;
    
    #2;
    @ (posedge clk);
    penable_i = '1;
    
    #2;
    repeat (!pready_o) begin
      @ (posedge clk);
      psel_i = '1;
    end
    
    @ (posedge clk); psel_i = '0;
    #7;
    @ (posedge clk);
    psel_i    = '1;
    penable_i = '1;
    paddr_i   = $urandom_range('0,4'hF);
    pwrite_i  = '0;
    
    #2;
    @ (posedge clk);
    penable_i = '0;
    
    #2;
    @ (posedge clk);
    penable_i = '1;
    
    #2;
    repeat (!pready_o) begin
      @ (posedge clk);
      psel_i = '1;
    end
    
    @ (posedge clk); psel_i = '0;
    #7;
    $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

             
