module log2 (
    input logic clk,                // Clock input
    input logic reset,              // Reset input
    input logic [N-1:0] value,      // Input value
    output logic [M-1:0] result,     // Output result
    output logic valid              // Valid signal
);
    parameter int N = 8; // Width of the input value
    parameter int M = 3; // Width of the output result 

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= '0;  // Reset result
            valid <= 0;    // Reset valid signal
        end else begin
            if (value == 0) begin
                result <= '0; // Undefined log2(0)
                valid <= 0;   // Not valid
            end else begin
                result <= 0;  // Reset result
                valid <= 1;   // Assume valid initially

                // Find the highest power of 2
                for (int i = 0; i < 8; i++) begin
                    if (value >= (1 << i)) begin
                        result <= i; // Update result
                    end
                end
                
                // Check if value is an exact power of 2
                if ((1 << result) != value) begin
                    valid <= 0; // Mark as invalid if not an exact power of 2
                end
            end
        end
    end
endmodule
