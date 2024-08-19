
// Single port synchronous RAM

module RAM (data,addr,cs,mode,clk,rst);
  
  inout logic [7:0] data;
  input logic cs,mode,clk,rst;
  input logic [9:0] addr;
  
  paramter size = 1024;
  logic [7:0] RAM [0:size-1];
  logic [7:0] data_reg;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i=0;i<size;i++) RAM[i] <= '0;
    end
    else if (cs && mode) begin
      for (int i=0;i<size;i++) RAM[i] <= (i==addr) ? data : RAM[i];//write
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) data_reg <= '0;
    else if (cs && !mode) data_reg <= RAM[addr];//read
  end   
  
  assign data = (cs && mode) ? data_reg ? 8'bx;
    
endmodule
