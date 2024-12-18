module serial_adder_tb(s,c,si_1,si_2,l,Clk,Rst);
 input logic s,c;
  output logic si_1,si_2,l,Clk,Rst;
 
  serial_adder DUT(.Sum(s),.Cy(c),.SI_1(si_1),.SI_2(si_2),.load(l),.clk(Clk),.rst(Rst));
  
 initial
  begin
    $dumpfile("Serial_Adder.vcd");
    $dumpvars(0,serial_adder_tb);
    $monitor ($time,"  Rst=%b, Clk=%b, Sum=%b, Cy=%b, SI_1=%b,  SI_2=%b,  load=%b,  ",Rst,Clk,s,c,si_1,si_2,l);
  
    Clk = '0;
    Rst = '0;
    
  #5 Rst = '1;

 //  way-1
  // l ='1; si_1='1; si_2='1;
 // #4 si_1='0; si_2='1;
 // #4 si_1='1; si_2='0; 
 // #4 si_1='0; si_2='1;
 // #4 l ='0; si_1='1; si_2='0;
 // #4 si_1='0; si_2='1;
 // #4 si_1='1; si_2='0;
 // #4 si_1='0; si_2='0;
    
    //Better way of coding for same stimulus more test cases - way-2
    for (int i=0 ; i<33 ; i++) begin
      l = $random%2;
      si_1=$random%5; 
      si_2=$random%8;
      #4;
    end
  
  #5 $finish;
  end
  
 always #2 Clk = !Clk;  
  
endmodule

Waveform (w-1) : https://www.edaplayground.com/w/x/LSp

Waveform (w-2) : https://www.edaplayground.com/w/x/USx
