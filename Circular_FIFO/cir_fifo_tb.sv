//Waveform : https://www.edaplayground.com/w/x/XeQ

module cir_fifo_tb ();
  
  parameter depth = 16;
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  logic full,empty;
  logic clk,rst,rd,wr;
  logic [width-1:0] wr_data; 
  logic [width-1:0] rd_data;
  
  cir_fifo DUT(.*);
  
  initial begin
    $dumpfile("cir_fifo.vcd");
    $dumpvars(0,cir_fifo_tb);
    $monitor ($time,"  rst=%b, clk=%b, wr=%b, rd=%b, FIFO[0]=%h, FIFO[1]=%h, FIFO[2]=%h, FIFO[5]=%h, FIFO[14]=%h, FIFO[15]=%h ",rst,clk,wr,rd,DUT.FIFO[0],DUT.FIFO[1],DUT.FIFO[2],DUT.FIFO[5],DUT.FIFO[14],DUT.FIFO[15]);
    
    clk = '0;
    rst = '0;
    rd  = '0;
    wr  = '0;
        
    #13  rst = '1;
    #2 @(posedge clk) wr = '1;
    wr_data = $urandom_range(0,16'hFFFF);
    
    repeat (16) begin 
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #10 wr  = '0;
    
    repeat (2) begin
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    #2 rd = '1;
    
    #75 rd = '0;
    
    #2 @(posedge clk) wr = '1;
    wr_data = $urandom_range(0,16'hFFFF);
    
    repeat (4) begin 
      @(posedge clk) wr_data = $urandom_range(0,16'hFFFF); 
    end
    
    wr = '0;
    rd = '1;
    
    #15 rd = '0;
    
    #10 $finish;
  end
    
  always #2 clk = !clk;

endmodule

Output :
0  rst=0, clk=0, wr=0, rd=0, FIFO[0]=00, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                   2  rst=0, clk=1, wr=0, rd=0, FIFO[0]=00, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                   4  rst=0, clk=0, wr=0, rd=0, FIFO[0]=00, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                   6  rst=0, clk=1, wr=0, rd=0, FIFO[0]=00, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                   
                  14  rst=1, clk=1, wr=0, rd=0, FIFO[0]=00, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  16  rst=1, clk=0, wr=0, rd=0, FIFO[0]=00, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  18  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  20  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=00, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  22  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  24  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=00, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  26  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  28  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  30  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  32  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  34  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  36  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=00, FIFO[14]=00, FIFO[15]=00 
                  38  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  40  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  42  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  44  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  46  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  48  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  50  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  52  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  54  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  56  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  58  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  60  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  62  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  64  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  66  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  68  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  70  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  72  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=00, FIFO[15]=00 
                  74  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=00 
                  76  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=00 
                  78  rst=1, clk=1, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                  80  rst=1, clk=0, wr=1, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                  
                  98  rst=1, clk=1, wr=0, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 100  rst=1, clk=0, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 102  rst=1, clk=1, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 104  rst=1, clk=0, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 106  rst=1, clk=1, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 108  rst=1, clk=0, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 
                 172  rst=1, clk=0, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 174  rst=1, clk=1, wr=0, rd=1, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 175  rst=1, clk=1, wr=0, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 176  rst=1, clk=0, wr=0, rd=0, FIFO[0]=15, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 178  rst=1, clk=1, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 180  rst=1, clk=0, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=89, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 182  rst=1, clk=1, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 184  rst=1, clk=0, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=84, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 186  rst=1, clk=1, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 188  rst=1, clk=0, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 190  rst=1, clk=1, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 192  rst=1, clk=0, wr=1, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 194  rst=1, clk=1, wr=0, rd=1, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 196  rst=1, clk=0, wr=0, rd=1, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 198  rst=1, clk=1, wr=0, rd=1, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 200  rst=1, clk=0, wr=0, rd=1, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 
                 216  rst=1, clk=0, wr=0, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
                 218  rst=1, clk=1, wr=0, rd=0, FIFO[0]=d2, FIFO[1]=32, FIFO[2]=ec, FIFO[5]=df, FIFO[14]=fd, FIFO[15]=37 
testbench.sv:54: $finish called at 219 (1s)
