module comp_2b_tb(e,g,l,a,b);
 input logic e,g,l;
  output logic [1:0]a,b;
 
  comp_2b DUT(.Eq(e),.Gt(g),.Lt(l),.A(a),.B(b));
  
 initial
  begin
    $dumpfile("comparator.vcd");
    $dumpvars(0,comp_2b_tb);
    $monitor ($time,"  A=%b, B=%b, A==B=%b, A>B=%b, A<B=%b  ",a,b,e,g,l);
  
    
  #4 a=2'b10; b=2'b00;
  #4 a=2'b11; b=2'b11; 
  #4 a=2'b00; b=2'b01;
  #4 a=2'b01; b=2'b10;
  
  #5 $finish;
  end
endmodule
