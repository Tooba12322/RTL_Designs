
// Single port synchronous RAM

module RAM (data,addr,cs,mode,clk,rst);
  
  inout logic [7:0] data;
  input logic cs,mode,clk,rst;
  input logic [9:0] addr;
  logic [7:0] in_data;
  logic [7:0] out_data;
  input bi_en;
  
  parameter size = 1024;
  logic [7:0] RAM [0:size-1];
  logic [7:0] data_reg;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i=0;i<size;i++) RAM[i] <= '0;
    end
    else if (cs && mode) begin
      RAM[addr] <= in_data;//write
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) data_reg <= '0;
    else if (cs && !mode) data_reg <= RAM[addr];//read
  end   
  
  assign out_data = (cs && !mode) ? data_reg : 8'bx;
  
  assign in_data = (bi_en) ? data : 8'bx;
  
  assign data = (!bi_en) ? out_data : 8'bx;
  
endmodule

