// ALU with flags
module ALU_16b(Sign,Zero,Parity,Overflow,Out,Op,A,B);
  output logic [15:0]Out;
  output logic Sign,Zero,Parity,Overflow;
  input logic [15:0]A;
  input logic [15:0]B; 
  input logic [2:0] Op;
  logic Co,Bo;
  
  localparam ADD = 3'b000;
  localparam SUB = 3'b001;
  localparam SL  = 3'b010;
  localparam SR  = 3'b011;
  localparam OR  = 3'b100;
  localparam AND = 3'b101;
  localparam XOR = 3'b110;
  localparam POW  = 3'b111;
  
  always_comb begin
    case (Op)
      ADD : {Co,Out} = {1'b0,A} + {1'b0,B};
      SUB : {Bo,Out} = {1'b0,A} - {1'b0,B};
      SL  : Out = A << B[1:0];
      SR  : Out = A >> B[1:0];
      OR  : Out = A || B;
      AND : Out = A && B;
      XOR : Out = A ^ B;
      POW : Out = A[1:0] ** B[1:0];
    endcase
  end
      
    
  
  assign Sign = (Op[2:1]=='0) ? Out[15] : 'x; //Only for arithmatic operation
  assign Zero = ~|Out;
  assign Parity = ~^Out;
  assign Overflow = (Op=='0) ? ((A[15] && B[15] && !Out[15]) || (!A[15] && !B[15] && Out[15])) : 'x; //Only for addition
  
endmodule
      
    
  
