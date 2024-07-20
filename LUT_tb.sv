module LUT_tb(ram, A0, A1, A2, A3, CLK, RST);
 input logic ram[15:0];
 output logic A0, A1, A2, A3;
 output logic CLK, RST;
 logic ram_o; 
 logic addr;
 LUT DUT(.RAM(ram),.a0(A0),.a1(A1),.a2(A2),.a3(A3),.clk(CLK),.rst(RST));
 assign addr = {A0,A1,A2,A3};
 assign ram_o = ram[addr];
 initial
  begin
   
   $monitor ($time,"  CLK=%b, RST=%b, A0=%b, A1=%b, A3=%b, RAM=%b",CLK,RST,A0,A1,A2,A3,ram_o);
  
  CLK = '0;
  RST = '0;
  #5 RST = '1;
  
  #20 {A0,A1,A2,A3} = 4'b1010;
  #35 {A0,A1,A2,A3} = 4'b0111; 
 end
  
 always #5 CLK = !CLK;
 initial begin
  #45 $finish;
 end
endmodule
