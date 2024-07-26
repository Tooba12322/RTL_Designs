module binary_add_sub_tb(s,co,m,a,b);
 input logic co;
  input logic [3:0]s;
  output logic m;
  output logic [3:0]a,b;
 
  binary_add_sub DUT(.Sum(s),.Co(co),.M(m),.A(a),.B(b));
  
 initial
  begin
    $dumpfile("Add_sub.vcd");
    $dumpvars(0,add_sub_tb);
    $monitor ($time,"  Sum=%b, Co=%b, M=%b, A=%b, B=%b  ",s,co,m,a,b);
  
    
  #4 m='0; a=4'b1011; b=4'b1100;
  #4 m='1; a=4'b1011; b=4'b1100; 
  #4 m='1; a=4'b0001; b=4'b0101;
  #4 m='0; a=4'b0001; b=4'b0101;
  
  #5 $finish;
  end

endmodule

Output :
0  Sum=xxxx, Co=x, M=x, A=xxxx, B=xxxx  
                   4  Sum=0111, Co=1, M=0, A=1011, B=1100  
                   8  Sum=1111, Co=0, M=1, A=1011, B=1100  
                  12  Sum=1100, Co=0, M=1, A=0001, B=0101  
                  16  Sum=0110, Co=0, M=0, A=0001, B=0101  
testbench.sv:21: $finish called at 21 (1s)
