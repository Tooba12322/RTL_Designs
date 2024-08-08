// 4-master-1-slave priority arbiter with Valid

module priority_arb(S,M0,P0,M1,P1,M2,P2,M3,P3);
  
  output logic S;
  input logic M0,M1,M2,M3; // master request
  input logic [2:0] P0,P1,P2,P3; // master priority level 0-7
  
  logic Vld;
  logic [2:0] max1, max2, max;
  
  assign Vld = (M0 || M1 || M2 || M3) && (max1 != max2); // valid request, when at least there is one req and priorities are not equal
  
  assign max1 = (P0 > P1) ? P0 : P1;
  assign max2 = (P2 > P3) ? P2 : P3;
  assign max  = (max1 > max2) ? max1 : max2; // find master with max priority
  
  assign S = Vld ? ((P0 == max) ? M0 :
                    (P1 == max) ? M1 :
                    (P2 == max) ? M2 :
                    (P3 == max) ? M3 :
                    '0) : 'z;  // master connected to slve depending on priority
endmodule
