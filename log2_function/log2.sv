
module log2 (
    input logic clk,                // Clock input
    input logic rst,              // Reset input
    input logic [N-1:0] value,      // Input value
    output logic [M-1:0] result,     // Output result
    output logic valid              // Valid signal
);
    parameter N = 8; // Width of the input value
    parameter M = 3; // Width of the output result 

  always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            result <= '0;  // Reset result
            valid <= 0;    // Reset valid signal
        end 
        else begin
            if (value == 0) begin
                result <= '0; // Undefined log2(0)
                valid <= 0;   // Not valid
            end 
            else begin
                // Find the highest power of 2
              for (int i = 0; i < 8; i++) begin
                if (value >= (1 << i)) begin
                  result <= i; // Update result
                  valid <= ((1 << i) == value) ? '1 : '0;  // result is valid only if value is power of 2
                end
              end 
            end
        end
    end
endmodule
