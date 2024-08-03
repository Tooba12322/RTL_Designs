// Variable swapping using blocking and non-blocking statements
module swap_1();
  int A,B;
  int tmp;
  initial begin
    $display(" With blocking assignment : ");
    repeat(4) begin
      A = $urandom_range(0,80);
      B = $urandom_range(0,255);
      $display($time," A = %0d, B = %0d",A,B);
      tmp = A;
      A   = B; 
      B   = tmp;
      #5 $display($time," A = %0d, B = %0d",A,B);
    end
  end 
endmodule

module swap_2();
  int A,B;
  int tmp;
  initial begin
    repeat(4) begin
      A = $urandom_range(0,80);
      B = $urandom_range(0,255);
      $display($time," A = %0d, B = %0d",A,B);
      tmp = A;
      A   = B; 
      B   = tmp;
      #5 $display($time," A = %0d, B = %0d",A,B);
    end
  end
  
endmodule



