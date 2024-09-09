// Parameterized Circular FIFO Implementation

module cir_fifo(rd_data,full,empty,rd,wr,wr_data,clk,rst);
  parameter depth = 16;
  parameter width = 8;
  parameter addr  = $clog2(depth);
  
  output logic full,empty;
  input logic clk,rst,rd,wr;
  input logic [width-1:0] wr_data; 
  output logic [width-1:0] rd_data; 
  
  logic [addr-1:0] rd_ptr,wr_ptr;
  logic [width-1:0] FIFO [depth-1:0];
  logic rd_ptr_ov,wr_ptr_ov;
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i=0;i<depth;i++) FIFO[i] <= '0;
    end
    else if (wr && !full) begin
      FIFO[wr_ptr] <= wr_data;//write
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) wr_ptr <= '0;
    else if (wr && !full) begin
      wr_ptr <= (wr_ptr == 4'd15) ? '0 : wr_ptr + 4'd1;
    end
  end   
  
  assign rd_data = (rd && !empty) ? FIFO [rd_ptr] : 8'bx;//read
  
  always @(posedge clk or negedge rst) begin
    if (!rst) rd_ptr <= '0;
    else if (rd && !empty) begin
      wr_ptr <= (rd_ptr == 4'd15) ? '0 : rd_ptr + 4'd1;
    end
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) wr_ptr_ov <= '0;
    else if (wr_ptr == 4'd15 && wr && !full) wr_ptr_ov <= !wr_ptr_ov;
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) rd_ptr_ov <= '0;
    else if (rd_ptr == 4'd15 && rd && !empty) rd_ptr_ov <= !rd_ptr_ov;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) full <= '0;
    else if (wr_ptr == rd_ptr) begin
      full <= (wr_ptr_ov == rd_ptr_ov) ? '0 : '1;
    end
    else full <= '0;
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) empty <= '1;
    else if (wr_ptr == rd_ptr) begin
      empty <= (wr_ptr_ov == rd_ptr_ov) ? '1 : '0;
    end
    else empty <= '0;
  end 
  
endmodule
