
// Parameterized Asynchronous FIFO Implementation

module async_FIFO (rd_data,full,empty,rd,wr,wr_data,r_clk,w_clk,r_rst,w_rst);
  parameter depth = 8;
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  output logic full,empty;
  input logic r_clk,r_rst,w_clk,w_rst,rd,wr;
  input logic [width-1:0] wr_data; 
  output logic [width-1:0] rd_data; 
  
  logic [addr:0] rd_ptr,wr_ptr;
  logic [width-1:0] FIFO [depth-1:0];
  logic [width-1:0] rd_data_ff; 
  logic [addr:0] sync_rd_ptr,sync_wr_ptr;
  
  logic [addr:0] gr_rd_ptr,gr_wr_ptr;
  logic [addr:0] gr_rd_ptr_nxt,gr_wr_ptr_nxt;
  
  logic [addr:0] bin_rd_ptr,bin_wr_ptr;
  logic [addr:0] bin_rd_ptr_nxt,bin_wr_ptr_nxt;
 
  sync rd_sync (.sync_rd_ptr(sync_o),.w_rst(rst),.w_clk(clk),.gr_rd_ptr(sync_i));
  
  sync wr_sync (.sync_wr_ptr(sync_o),.r_rst(rst),.r_clk(clk),.gr_wr_ptr(sync_i));
  
  always_ff @(posedge w_clk or negedge w_rst) begin
    if (!w_rst) begin
      for (int i=0;i<depth;i++) FIFO[i] <= '0;
    end
    else if (wr && !full) begin
      FIFO[wr_ptr[addr-1:0]] <= wr_data;//write
    end
  end
  
  always @(posedge w_clk or negedge w_rst) begin
    if (!w_rst) wr_ptr <= '0;
    else if (wr && !full) begin
      wr_ptr <= wr_ptr + 4'd1;
    end
  end   
  
  always @(posedge r_clk or negedge r_rst) begin
    if (!r_rst) rd_data_ff <= '0;
    else if (rd && !empty) begin
      rd_data_ff <= FIFO [rd_ptr[addr-1:0]];
    end
  end 
  
  assign rd_data =  rd_data_ff;//read
  
  always @(posedge r_clk or negedge r_rst) begin
    if (!r_rst) rd_ptr <= '0;
    else if (rd && !empty) begin
      rd_ptr <= rd_ptr + 4'd1;
    end
  end 
  
  // full and empty output implementation using gray coded rd/wr ptr 
    
  always @(posedge r_clk or negedge r_rst) begin
    if (!r_rst) gr_rd_ptr <= '0;
    else        gr_rd_ptr <= gr_rd_ptr_nxt;
  end 
  
   always @(posedge r_clk or negedge r_rst) begin
     if (!r_rst) bin_rd_ptr <= '0;
    else         bin_rd_ptr <= bin_rd_ptr_nxt;
  end
  
  always @(posedge w_clk or negedge w_rst) begin
    if (!w_rst) gr_wr_ptr <= '0;
    else        gr_wr_ptr <= gr_wr_ptr_nxt;
  end
  
  always @(posedge w_clk or negedge w_rst) begin
    if (!w_rst) bin_wr_ptr <= '0;
    else        bin_wr_ptr <= bin_wr_ptr_nxt;
  end
  
  assign  bin_rd_ptr_nxt = (rd & !empty) ? bin_rd_ptr + 4'd1 : bin_rd_ptr;
  assign  bin_wr_ptr_nxt = (wr & !full)  ? bin_wr_ptr + 4'd1 : bin_wr_ptr;
  
  assign  gr_rd_ptr_nxt = (bin_rd_ptr_nxt>>1) ^ bin_rd_ptr_nxt;
  assign  gr_wr_ptr_nxt = (bin_wr_ptr_nxt>>1) ^ bin_wr_ptr_nxt;
  
  always @(posedge r_clk or negedge r_rst) begin
    if (!r_rst) empty <= '1;
    else       empty  <= (gr_rd_ptr_nxt == sync_wr_ptr) ? '1 : '0;
  end
  
  always @(posedge w_clk or negedge w_rst) begin
    if (!w_rst) full <= '0;
    else        full <= ({!gr_wr_ptr_nxt[addr:addr-1],gr_wr_ptr_nxt[addr-2:0]} == sync_rd_ptr) ? '1 : '0;
  end
  
endmodule

// Synchronizer module for clock domain crossing
module sync(sync_o,rst,clk,sync_i);
  parameter depth = 8;
  parameter addr  = $clog2(depth);
  
  input logic [addr:0] sync_i;
  output logic [addr:0] sync_o;
  input logic clk,rst;
  
  logic [addr:0] Q;
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      Q <= '0;
      sync_o <= '0;
    end
    else begin
      Q <= sync_i;
      sync_o <= Q;
    end 
endmodule
      
      
