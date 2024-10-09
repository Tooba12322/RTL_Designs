// SPI top module implementation 
// Here only 8 data bits are transferred
// sclk signal is generated by master and is different from system clk

`timescale 1ns/1ps

module spi_m (dout,ready,sclk,mosi,done,miso,cpol,cpha,din,dvsr,start,clk,rst);
  
  output logic done,ready,sclk,mosi;
  output logic [7:0] dout;
  input logic miso,cpol,cpha,start,clk,rst;
  input logic [7:0] din;
  input logic [15:0] dvsr;

  logic [15:0] cnt,cnt_nxt; //counter to calculate number of clks till dvsr
  logic [2:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits transmitted
  logic [7:0] data_in, din_nxt; // flop for storing data thai is serially available on miso
  logic [7:0] dout_reg,dout_nxt; // flop for storing data to be serially transferred on mosi
  logic iclk,sclk_nxt,sclk_reg,done_nxt;

  parameter DBITS = 8; //total number of data bits to be communicated
  
  typedef enum logic [1:0] {idle = 2'd0,cpha_delay = 2'd1,drive = 2'd2,sample = 2'd3} state;
  state pr_state,nx_state;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      dbits_cnt <= '0;
      data_in   <= '0;
      dout_reg  <= '0;
      cnt       <= '0;
      sclk_reg  <= '0;
      done      <= '0;
    end
    else begin
      dbits_cnt <= dbits_cnt_nxt;
      data_in   <= din_nxt;
      dout_reg  <= dout_nxt;
      cnt       <= cnt_nxt;
      sclk_reg  <= sclk_nxt;
      done      <= done_nxt;
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= idle;
    else pr_state <= nx_state;
  end   
  
  always @(*) begin
      nx_state      = pr_state; //default values
      dbits_cnt_nxt = dbits_cnt;
      din_nxt       = data_in;
      dout_nxt      = dout_reg;
      cnt_nxt       = cnt;
      done_nxt      = '0; // assert done at the end for one cycle
      ready         = '0; // during data transfer ready=0
          
    case (pr_state) 
      idle      : begin //master asserts ready by default, depending on cpha value either drive first bit, or delay one clk
                     ready = '1;
                     if (start == '1) begin
                       if (cpha) nx_state   =  cpha_delay;
                       else nx_state   =  drive;
                       dout_nxt   = din;
                     end
                   end
      
      cpha_delay : begin // wait for next cycle, as if cpha = '1, driving should be at clk edge 
                     if (cnt == dvsr) begin
                       nx_state   =  drive;
                       cnt_nxt    = '0;
                     end
                     else cnt_nxt = cnt + 16'd1;
                   end
      
      drive      : begin // in next sclk cycle, capture miso input into data_in reg
                     if (cnt==dvsr) begin
                       din_nxt  = {data_in[6:0],miso};
                       nx_state = sample;
                       cnt_nxt = '0;
                     end
                     else cnt_nxt = cnt + 16'd1;
                   end
        
      sample     : begin // in next sclk cycle, deliver mosi output from dout reg, repeat till all DBITS are sent/captured
                     if (cnt ==  dvsr) begin
                       if (dbits_cnt == DBITS - 1) begin
                         nx_state = idle;
                         cnt_nxt  = '0;
                         done_nxt = '1;
                         dbits_cnt_nxt = '0;
                         din_nxt  = {data_in[6:0],miso};// for last bit to be captured
                       end
                       else begin
                         dbits_cnt_nxt = dbits_cnt + 3'd1;
                         dout_nxt = {dout_reg[6:0],1'b0};
                         nx_state = drive;
                         cnt_nxt  = '0;
                       end 
                     end
                     else cnt_nxt = cnt + 16'd1;
                   end
     endcase
  end
  
  //sclk generation
  assign iclk = (nx_state==sample && !cpha) || (nx_state==drive && cpha);
  assign sclk_nxt = (cpol) ? !iclk : iclk;
  
  assign dout = (done) ? data_in : '0; // drive input reg contents at the end, should equal to 8 miso bits received serially
  assign mosi = dout_reg[7]; // drive mosi output pin
  assign sclk = sclk_reg; // drive sclk output
  
endmodule

module spi_s (miso,dout,ready,sclk,mosi,done,din,cpha,clk,rst);
  
  output logic done,miso;
  output logic [7:0] dout;
  input logic mosi,rst,cpha,sclk,clk,ready;
  input logic [7:0] din;
 
  logic [2:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits transmitted
  logic [7:0] data_in, din_nxt; // flop for storing data that is serially available on mosi
  logic [7:0] dout_reg,dout_nxt; // flop for storing data to be serially transferred on miso
  logic done_nxt;

  parameter DBITS = 8; //total number of data bits to be communicated
  
  typedef enum logic [1:0] {idle = 2'd0,cpha_delay = 2'd1,drive = 2'd2,sample = 2'd3} state;
  state pr_state,nx_state;

  always @(posedge sclk or negedge sclk or negedge rst) begin
    if (!rst) begin
      dbits_cnt <= '0;
      data_in   <= '0;
      dout_reg  <= '0; 
    end
    else begin
      dbits_cnt <= dbits_cnt_nxt;
      data_in   <= din_nxt;
      dout_reg  <= dout_nxt;
      
    end
  end
  
  always @(posedge sclk or negedge sclk or negedge rst) begin
    if (!rst)  done      <= '0;
    else done            <= done_nxt;
  end
      
  always @(posedge sclk or negedge sclk or negedge rst) begin
    if (!rst) pr_state <= idle;
    else pr_state <= nx_state;
  end   
  
  always @(*) begin
      nx_state      = pr_state; //default values
      dbits_cnt_nxt = dbits_cnt;
      din_nxt       = data_in;
      dout_nxt      = dout_reg;
      done_nxt      = '0; // assert done at the end for one cycle
          
    case (pr_state) 
      idle      : begin 
                   if (ready == '0) begin
                     if (cpha) nx_state   =  cpha_delay; 
                     else      nx_state   =  drive;
                     dout_nxt   = din;
                   end
                 end
      
      cpha_delay : begin 
                     nx_state    =  drive;
                   end
      
      drive      : begin // in next sclk cycle, capture mosi input into data_in reg
                       din_nxt  = {data_in[6:0],mosi};
                       if (dbits_cnt == DBITS - 1 && cpha=='0) nx_state = idle;
                       else nx_state = sample;
                       done_nxt      = (dbits_cnt == DBITS - 1 && cpha=='0) ? '1 : '0;
                   end
        
      sample     : begin // in next sclk cycle, deliver miso output from dout reg, repeat till all DBITS are sent/captured
                       if (dbits_cnt == DBITS - 2 && cpha=='1) begin
                         nx_state      = idle;
                         done_nxt      = '1;
                         dbits_cnt_nxt = '0;
                       end
                       else begin
                         dbits_cnt_nxt = dbits_cnt + 3'd1;
                         din_nxt  = (dbits_cnt == DBITS - 2 && cpha=='1) ? {data_in[6:0],mosi} : data_in;//sample last bit when cpha=1
                         dout_nxt = {dout_reg[6:0],1'b0};
                         nx_state = drive;
                         
                       end
                   end
     endcase
  end
 
  
  assign dout = (done) ? data_in : '0; // drive input reg contents at the end, should equal to 8 mosi bits received serially
  assign miso = dout_reg[7]; // drive miso output pin
  
endmodule
 


module spi_top (dout_s,dout_m,done_s,done_m,cpol,cpha,din_s,din_m,dvsr,start,clk,rst);
  
  output logic done_s,done_m;
  output logic [7:0] dout_s,dout_m;
  input logic cpol,cpha,start,clk,rst;
  input logic [7:0] din_m,din_s;
  input logic [15:0] dvsr;

  logic mosi_i,miso_i,sclk_i,ready_i;

  parameter DBITS = 8; //total number of data bits to be communicated
  
  spi_m master (.mosi(mosi_i),.rst(rst),.clk(clk),.dvsr(dvsr),.miso(miso_i),.done(done_m),.ready(ready_i),.sclk(sclk_i),.dout(dout_m),.cpol(cpol),.cpha(cpha),.start(start),.din(din_m));
  spi_s slave (.miso(miso_i),.mosi(mosi_i),.done(done_s),.din(din_s),.rst(rst),.clk(clk),.sclk(sclk_i),.dout(dout_s),.cpha(cpha),.ready(ready_i));
 
  
endmodule
 
