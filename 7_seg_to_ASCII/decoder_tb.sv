module Dec_tb();
  logic [7:0] ascii_out;
  logic a,b,c,d,e,f,g;
  
  Decoder DUT(.*);
  
  initial begin
    $monitor($time," a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b, -- %c", a,b,c,d,e,f,g,ascii_out);
    
    #5 {a,b,c,d,e,f,g} = 7'b0011100;
    #5 {a,b,c,d,e,f,g} = 7'b1001000;
    #5 {a,b,c,d,e,f,g} = 7'b0110000;
    #5 {a,b,c,d,e,f,g} = 7'b1110001;
    #5 {a,b,c,d,e,f,g} = 7'b1110001;
    $display($time," a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b, -- %c", a,b,c,d,e,f,g,ascii_out); // Used to print L twice :)
    #5 {a,b,c,d,e,f,g} = 7'b0000001;
    #5 {a,b,c,d,e,f,g} = 7'b0010011;
  
    #5 $finish;
  end

endmodule

Output :
0 a=x, b=x, c=x, d=x, e=x, f=x, g=x, -- 
                   5 a=0, b=0, c=1, d=1, e=1, f=0, g=0, -- |
                  10 a=1, b=0, c=0, d=1, e=0, f=0, g=0, -- H
                  15 a=0, b=1, c=1, d=0, e=0, f=0, g=0, -- E
                  20 a=1, b=1, c=1, d=0, e=0, f=0, g=1, -- L
                  25 a=1, b=1, c=1, d=0, e=0, f=0, g=1, -- L
                  30 a=0, b=0, c=0, d=0, e=0, f=0, g=1, -- O
                  35 a=0, b=0, c=1, d=0, e=0, f=1, g=1, -- |
testbench.sv:21: $finish called at 40 (1s)


