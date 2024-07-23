module LUT_tb(ram, A0, A1, A2, A3, CLK, RST);
 input logic ram[15:0];
 output logic A0, A1, A2, A3;
 output logic CLK, RST;
  logic ram_o; 
 logic addr;
 LUT DUT(.RAM(ram),.a0(A0),.a1(A1),.a2(A2),.a3(A3),.clk(CLK),.rst(RST));
  assign addr = {A3,A2,A1,A0};
 assign ram_o = ram[addr];
 initial
  begin
   
    $monitor ($time,"  CLK=%b, RST=%b, A3=%b, A2=%b, A1=%b, A0=%b,  RAM=%b",CLK,RST,A3,A2,A1,A0,ram_o);
  
  CLK = '0;
  RST = '0;
    {A3,A2,A1,A0} = 4'b0000;
  #5 {A3,A2,A1,A0} = 4'b0011;
  #5 RST = '1;
  
  #5 {A3,A2,A1,A0} = 4'b1010;
  #5 {A3,A2,A1,A0} = 4'b0111;
  #5 $finish;
  end
  
 always #2 CLK = !CLK; 
 
endmodule
