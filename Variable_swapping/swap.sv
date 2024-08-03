// Variable swapping using blocking and non-blocking statements

module swap_1();
  int A,B;
  int tmp;
  initial begin
    $display(" With blocking assignment : ");
    repeat(2) begin
      A = $urandom_range(0,80);
      B = $urandom_range(0,255);
      $display($time," Before swap, A = %0d, B = %0d",A,B);
      tmp = A;
      A   = B; 
      B   = tmp;
      #5 $display($time," After swap, A = %0d, B = %0d",A,B);
    end
  end 
endmodule

module swap_2();
  int C,D;
  int tmp;
  initial begin
   #25 $display(" With non-blocking assignment : ");
    repeat(2) begin
      C = $urandom_range(0,80);
      D = $urandom_range(0,255);
      $display($time," Before swap, C = %0d, D = %0d",C,D);
      tmp = C;
      C   = D; 
      D   = tmp;
      #5 $display($time," Before swap, C = %0d, D = %0d",C,D);
    end
  end
  
endmodule

Output : 
With blocking assignment : 
                   0 Before swap, A = 46, B = 64
                   5 After swap, A = 64, B = 46
                   5 Before swap, A = 1, B = 49
                  10 After swap, A = 49, B = 1
 With non-blocking assignment : 
                  25 Before swap, C = 42, D = 198
                  30 Before swap, C = 198, D = 42
                  30 Before swap, C = 16, D = 9
                  35 Before swap, C = 9, D = 16




