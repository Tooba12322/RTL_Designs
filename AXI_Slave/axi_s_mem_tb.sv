// Waveform : 

module axi_s_mem_tb ();
  
  logic        aclk,  arst_n;
  logic [31:0]   awaddr;
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
  logic [31:0]   araddr;
  logic          arvalid;
  logic         arready;

  //Read data channel
  logic [31:0]  rdata;
  logic [1:0]   rresp;
  logic         rvalid;
  logic          rready;
  axi_s_mem DUT(.*);

  logic [31:0]  addr, data;

  task axi_write (input addr, input data);
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

      $display("End of write transaction, Data=%0h, Addr=%0h",wdata,awaddr);
    end
  endtask
  
  initial begin
    //generate waveform
    $dumpfile("axi_s_mem.vcd");
    $dumpvars(0,axi_s_mem_tb);

    //Initialization
    aclk = '0;
    arst_n = '0;
     
    #9 arst_n = '1;

    $display("==================================================");
    $display("=========AXI Simulation Started==========");
    $display("==================================================");
    
    //Stimulus
    
    axi_write($urandom_range(32'h0,32'hCAFEBEDF), $urandom_range(32'h0,32'h0000000F));

    #50;
    $display("===========TEST PASSED============");
    #20 $finish;
  end
  
   //Clk Generation 
  always #2 aclk = !aclk;
  
endmodule

             
