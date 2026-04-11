
// Waveform : https://www.edaplayground.com/x/AiCQ

module axi_s_mem_tb ();
  
  logic        aclk,  arst_n;
  logic [7:0]   awaddr;
  logic          awvalid;
  logic         awready;

  //Write data channel
  logic [31:0]   wdata;
  logic          wvalid;
  logic         wready;

  //Write response channel
  logic [1:0]   bresp;
  logic         bvalid;
  logic          bready;

  //Read addr channel
  logic [7:0]   araddr;
  logic          arvalid;
  logic         arready;

  //Read data channel
  logic [31:0]  rdata;
  logic [1:0]   rresp;
  logic         rvalid;
  logic          rready;
  
  axi_s_mem DUT(.*);

  logic [31:0]  wrdata, rddata;
  logic [31:0] Rd_data;
  logic [7:0] addr;
  
  task axi_write (input [7:0] addr, input [31:0] wrdata);
    begin
      // Drive write addr
      @(posedge aclk);
      awvalid <= '1;
      awaddr  <= addr;
      wait(awready);
      @(posedge aclk);
      awvalid <= '0;

      // Drive write data
      @(posedge aclk);
      wvalid <= '1;
      wdata  <= wrdata;
      wait(wready);
      @(posedge aclk);
      wvalid <= '0;

      // Check write response
      @(posedge aclk);
      bready <= '1;
      wait(bvalid);
      @(posedge aclk);
      bready <= '0;

    end
  endtask
  
  task axi_read (input [7:0] addr, output [31:0] rddata);
    begin
      // Drive read addr
      @(posedge aclk);
      arvalid <= '1;
      araddr  <= addr;
      wait(arready);
      @(posedge aclk);
      arvalid <= '0;


      // Check read response
      @(posedge aclk);
      rready <= '1;
      wait(rvalid);
      rddata <= rdata;
      @(posedge aclk);
      rready <= '0;

    end
  endtask
  
  initial begin
    //generate waveform
    $dumpfile("axi_s_mem.vcd");
    $dumpvars(0,axi_s_mem_tb);
   // $monitor("End of write transaction, Data=%h, Addr=%h",DUT.mem.mem[15],awaddr);

    //Initialization
    aclk = '0;
    arst_n = '0;
     
    #9 arst_n = '1;

    $display("==================================================");
    $display("=========AXI Simulation Started==========");
    $display("==================================================");
    
    //Stimulus
    
    axi_write(8'h1F, $urandom_range(32'h0ABE0E54,32'hCAFEBEDF));
    $display("=========== END OF WRITE TRANSACTION ============");
    @(posedge aclk);
    axi_read(8'h1F, Rd_data);
    $display("=========== END OF READ TRANSACTION ============");
    
    if (Rd_data == DUT.mem.mem[31])
      $display("=========== SUCCESS - DATA MATCH ============");
    else
      $display("============ FAILURE - DATA MIS-MATCH ===============");
    
    
    axi_write(8'hBC, $urandom_range(32'h0A0C0E23,32'hCAFEABCD));
    $display("===========END OF WRITE TRANSACTION============");
    axi_read(8'hBC, Rd_data);
    $display("=========== END OF READ TRANSACTION ============");
    
    if (Rd_data == DUT.mem.mem[188])
      $display("=========== SUCCESS - DATA MATCH ============");
    else
      $display("============ FAILURE - DATA MIS-MATCH ===============");
    
    $display("==============TEST PASSED==============");
    #10 $finish;
  end
  
   //Clk Generation 
  always #2 aclk = !aclk;
  
endmodule

Output :
VCD info: dumpfile axi_s_mem.vcd opened for output.
==================================================
=========AXI Simulation Started==========
==================================================
=========== END OF WRITE TRANSACTION ============
=========== END OF READ TRANSACTION ============
=========== SUCCESS - DATA MATCH ============
===========END OF WRITE TRANSACTION============
=========== END OF READ TRANSACTION ============
=========== SUCCESS - DATA MATCH ============
==============TEST PASSED==============
testbench.sv:129: $finish called at 112 (1s)
Finding VCD file...
./axi_s_mem.vcd

             
