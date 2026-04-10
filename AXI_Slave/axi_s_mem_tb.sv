
// Waveform : 

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

  logic [31:0]  data;

  logic [7:0] addr;
  
  task axi_write (input [7:0] addr, input [31:0] data);
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
      wdata  <= data;
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
  
  initial begin
    //generate waveform
    $dumpfile("axi_s_mem.vcd");
    $dumpvars(0,axi_s_mem_tb);
    $monitor("End of write transaction, Data=%h, Addr=%h",DUT.mem.mem[15],awaddr);

    //Initialization
    aclk = '0;
    arst_n = '0;
     
    #9 arst_n = '1;

    $display("==================================================");
    $display("=========AXI Simulation Started==========");
    $display("==================================================");
    
    //Stimulus
    
    axi_write(8'h0F, $urandom_range(32'h0A0E0E00,32'hCAFEBEDF));

    $display("===========TEST PASSED============");
    #80 $finish;
  end
  
   //Clk Generation 
  always #2 aclk = !aclk;
  
endmodule

             
