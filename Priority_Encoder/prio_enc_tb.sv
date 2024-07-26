module prio_enc_tb(o,i0,i1,i2,i3);
  input logic [1:0]o;
  output logic i0,i1,i2,i3;
 
  priority_enc DUT(.Out(o),.In0(i0),.In1(i1),.In2(i2),.In3(i3));
  
 initial
  begin
    $dumpfile("priority_encoder.vcd");
    $dumpvars(0,prio_enc_tb);
    $monitor ($time,"  Selected_input=%h, I_3=%b, I_2=%b, I_1=%b, I_0=%b  ",o,i3,i2,i1,i0);
  
    
  #4 i3 = '0; i2='0; i1='0; i0='0;
  #4 i3 = '0; i2='1; i1='1; i0='1; 
  #4 i3 = '0; i2='0; i1='0; i0='1;
  #4 i3 = '1; i2='0; i1='1; i0='0;
  #4 i3 = '0; i2='0; i1='1; i0='1;
  #4 i3 = '1; i2='1; i1='1; i0='1;
  #5 $finish;
  end

endmodule

Output :
0  Selected_input=x, I_3=x, I_2=x, I_1=x, I_0=x  
                   4  Selected_input=x, I_3=0, I_2=0, I_1=0, I_0=0  
                   8  Selected_input=2, I_3=0, I_2=1, I_1=1, I_0=1  
                  12  Selected_input=0, I_3=0, I_2=0, I_1=0, I_0=1  
                  16  Selected_input=3, I_3=1, I_2=0, I_1=1, I_0=0  
                  20  Selected_input=1, I_3=0, I_2=0, I_1=1, I_0=1  
                  24  Selected_input=3, I_3=1, I_2=1, I_1=1, I_0=1  
testbench.sv:20: $finish called at 29 (1s)
