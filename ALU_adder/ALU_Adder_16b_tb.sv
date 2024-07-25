module ALU_adder_16b_tb(co,s,a,b,ci);
 input logic co;
  input logic S,Z,P,O;
 input logic [15:0]s;
  output logic [15:0]a;
  output logic [15:0]b;
  output logic ci;
 
  ALU_adder_16b DUT(.Sign(S),.Zero(Z),.Parity(P),.Overflow(O),.Co(co),.Sum(s),.A(a),.B(b),.Cin(ci));
  
 initial
  begin
    $dumpfile("Adder.vcd"); 
    $dumpvars(0,ALU_adder_16b_tb);
    $monitor ($time," Sign=%b ,Zero=%b ,Parity=%b ,Overflow=%b, Co=%b, Sum=%h, A=%h, B=%h,  Cin=%b",S,Z,P,O,co,s,a,b,ci);
  
 
  #5 a=16'h8FFF; b=16'h8000; ci='0;
  #5 a=16'hFFFE; b=16'h0002; ci='0;
  #5 a=16'hAAAA; b=16'h5555; ci='0;
  #5 a=16'h8FFF; b=16'h8000; ci='1;
  #5 $finish;
  end
  
endmodule


Output : 
0 Sign=x ,Zero=x ,Parity=x ,Overflow=x, Co=x, Sum=xxxx, A=xxxx, B=xxxx,  Cin=x
                   5 Sign=0 ,Zero=0 ,Parity=1 ,Overflow=1, Co=1, Sum=0fff, A=8fff, B=8000,  Cin=0
                  10 Sign=0 ,Zero=1 ,Parity=1 ,Overflow=0, Co=1, Sum=0000, A=fffe, B=0002,  Cin=0
                  15 Sign=1 ,Zero=0 ,Parity=1 ,Overflow=0, Co=0, Sum=ffff, A=aaaa, B=5555,  Cin=0
                  20 Sign=0 ,Zero=0 ,Parity=0 ,Overflow=1, Co=1, Sum=1000, A=8fff, B=8000,  Cin=1
testbench.sv:22: $finish called at 25 (1s)

Waveform :
https://www.edaplayground.com/w/x/7Dj
