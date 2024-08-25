// Waveform : https://www.edaplayground.com/w/x/TK3

module reg_bank_tb ();
  
  parameter reg_size = 32;
  parameter bank_size = 32;
  parameter addr = $clog2(bank_size);
  
  logic [reg_size:0] sr1_data,sr2_data;
  logic [reg_size:0] dr_data;
  logic clk,rst;
  logic [addr-1:0] sr1_addr,sr2_addr,dr_addr;
  
  reg_bank DUT(.*);
  
  initial begin
    $dumpfile("reg_bank.vcd");
    $dumpvars(0,reg_bank_tb);
    
    clk = '0;
    rst = '0;
    sr1_addr='0;
    sr2_addr='0;
    dr_addr ='0;
    dr_data='0;
    
    #10 @(posedge clk)  rst = '1;
    
    repeat (20) begin
      #3;
      dr_data = $urandom_range(0,32'hFFFF);
      sr1_addr = $urandom_range(0,5'h1F);
      sr2_addr = $urandom_range(0,5'h1F);
      dr_addr = $urandom_range(0,5'h1F);
    end
     
    $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
