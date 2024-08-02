// Long sequence detector without FSM

module seq_det (out,In,clk,rst);
  input logic clk,rst;
  input logic In;
  output logic out;
  
  logic [15:0] reg_in;
  
  parameter seq = 16'hABCD; //Initialize the sequence to be detected
  
  always @(posedge clk or negedge rst) begin
    if (!rst) reg_in <= '0;
    else begin // shift reg
      reg_in  <= {In,reg_in[15:1]};
    end
  end
  
  assign out = (seq==reg_in) ? '1 : '0; //when last 16-bits of In == Seq to be dtected
  
endmodule








