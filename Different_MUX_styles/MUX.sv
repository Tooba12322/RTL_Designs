// 4X1 MUX in different coding styles

module MUX(y1,y2,y3,y4,y5,y6,In,Sel);
  
  // Output using ternary operator
  output logic y1;
  // Output using if-else
  output logic y2;
  // Ouput using case
  output logic y3;
  // Output using for loop
  output logic y4;
  // Output using and-or tree
  output logic y5;
  //Output using variable slicing
  output logic y6;
  
  input logic [3:0]In;
  input logic [1:0]Sel;
  
  assign y1 = Sel[1] ? (Sel[0] ? In[3] : In[2]) : (Sel[0] ? In[1] : In[0]);
  
  always @(Sel,In) begin
    if (Sel[1]) begin
      if (Sel[0]) y2 = In[3];
      else y2 = In[2];
    end
    else begin
      if (Sel[0]) y2 = In[1];
      else if (!Sel[0]) y2 = In[0];
      else y2 = 'x;
    end
  end
  
  always @(Sel,In) begin
    case (Sel) 
      2'd0 : y3 = In[0];
      2'd1 : y3 = In[1];
      2'd2 : y3 = In[2];
      2'd3 : y3 = In[3];  
    endcase
  end
  
  logic [3:0]w;
  always @(Sel,In) begin
    for (int i=0; i<=3; i++) begin
      w[i] = (i==Sel) ? In[i] : '0; 
    end
    assign y4 = |w;
  end
  
  
  always @(Sel,In) begin 
    y5 = (!Sel[1] && !Sel[0] && In[0]) || (!Sel[1] && Sel[0] && In[1]) || (Sel[1] && !Sel[0] && In[2]) || (Sel[1] && Sel[0] && In[3]);
  end
  
  always @(Sel,In) begin
    assign y6 = In[Sel];
  end
endmodule
