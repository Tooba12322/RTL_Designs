// Code your testbench here
module ALU_tb ();
  logic [15:0] Out;
  logic Sign,Zero,Parity,Overflow;
  logic [15:0] A;
  logic [15:0] B; 
  logic [2:0] Op;
  
  ALU_16b DUT(.*);
  
  initial begin
    $dumpfile("ALU.vcd");
    $dumpvars(0,ALU_tb);
    $monitor ($time,"  Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Out=%h, Op=%b, A=%h, B=%h  ",Sign,Zero,Parity,Overflow,Out,Op,A,B);
  
    for (int i=0; i<4; i++) begin
      for (int j=0; j<8; j++) begin
        A = $urandom_range(0,16'hFFFF);
        B = $urandom_range(0,16'hFFFF);
        Op = 3'(j);
        #5;
      end
    end
    
    $finish;
  end
  
endmodule

Waveform : 
https://www.edaplayground.com/w/x/6Hn


