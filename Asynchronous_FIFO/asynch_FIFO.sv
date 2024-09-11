
// Parameterized Asynchronous FIFO Implementation, where read and write happens in different clk domains.
// Binary pointers are used for FIFO addressing
// However, for empty and full signal generation gray coded pointers are used, 
// because of single bit change at clock domain crossing of multi-bit pointers
// Both read and write pointers has 1 extra MSB bit for empty and full logic differentiation when pointers are equal
// 2-stage synchronization module is also instantiated for pointers clock domain crossing to avoid metastability

module async_FIFO (rd_data,full,empty,rd,wr,wr_data,r_clk,w_clk,r_rst,w_rst);
  parameter depth = 8; // 8 deep FIFO
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  output logic full,empty;
  input logic r_clk,r_rst,w_clk,w_rst,rd,wr; // read,write domain clk,reset
  input logic [width-1:0] wr_data; 
  output logic [width-1:0] rd_data; 
  
  logic [addr:0] rd_ptr,wr_ptr;
  logic [width-1:0] FIFO [depth-1:0];
  logic [width-1:0] rd_data_ff; 
  logic [addr:0] sync_rd_ptr,sync_wr_ptr; // synchronized ptrs in opposite domain
  
  logic [addr:0] gr_rd_ptr,gr_wr_ptr; // gray coded pointers
  logic [addr:0] gr_rd_ptr_nxt,gr_wr_ptr_nxt;
  
  logic [addr:0] bin_rd_ptr,bin_wr_ptr; // binary pointers, same as rd_ptr and wr_ptr
  logic [addr:0] bin_rd_ptr_nxt,bin_wr_ptr_nxt;
 
  sync rd_sync (.sync_o(sync_rd_ptr),.rst(w_rst),.clk(w_clk),.sync_i(gr_rd_ptr)); // Synchronization
  
  sync wr_sync (.sync_o(sync_wr_ptr),.rst(r_rst),.clk(r_clk),.sync_i(gr_wr_ptr)); // Synchronization
  
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
    else if (wr && !full) begin // when wr is enabled and FIFO is not full
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
    else if (rd && !empty) begin //when rd is enabled and FIFO is not empty
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
//Next binary pointer value
  assign  bin_rd_ptr_nxt = (rd & !empty) ? bin_rd_ptr + 4'd1 : bin_rd_ptr; 
  assign  bin_wr_ptr_nxt = (wr & !full)  ? bin_wr_ptr + 4'd1 : bin_wr_ptr;
  
  //Next gray pointer value
  assign  gr_rd_ptr_nxt = (bin_rd_ptr_nxt>>1) ^ bin_rd_ptr_nxt;
  assign  gr_wr_ptr_nxt = (bin_wr_ptr_nxt>>1) ^ bin_wr_ptr_nxt;
  
  always @(posedge r_clk or negedge r_rst) begin
    if (!r_rst) empty <= '1;
    else       empty  <= (gr_rd_ptr_nxt == sync_wr_ptr) ? '1 : '0; // asserted when gray coded rd_ptr == gray coded synchronized wr_ptr
  end

  //full signal asserted when gray coded wr_ptr == gray coded synchronized rd_ptr,with two MSBs inverted because of gray code symmetric nature
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
  //two stage synchronizing flops, in receiving domain
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      Q <= '0;
      sync_o <= '0;
    end
    else begin
      Q <= sync_i;
      sync_o <= Q;
    end 
  end
endmodule
      
      
