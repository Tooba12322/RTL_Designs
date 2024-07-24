module adder_16b_tb(co,s,a,b,ci);
 input logic co;
 input logic [15:0]s;
  output logic [15:0]a;
  output logic [15:0]b;
  output logic ci;
 
  adder_16b DUT(.Co(co),.Sum(s),.A(a),.B(b),.Cin(ci));
  
 initial
  begin
    $dumpfile("Adder.vcd"); 
    $dumpvars(0,adder_16b_tb);
    $monitor ($time," Co=%b, Sum=%h, A=%h, B=%h,  Cin=%b",co,s,a,b,ci);
  
 
  #5 a=16'h8FFF; b=16'h8000; ci='0;
  #5 a=16'hFFFE; b=16'h0002; ci='0;
  #5 a=16'hAAAA; b=16'h5555; ci='0;
  #5 $finish;
  end
  
endmodule
