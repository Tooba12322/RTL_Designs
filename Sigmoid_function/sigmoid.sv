module sigmoid (
    input logic signed [7:0] x,         // Input value (8-bit signed)
    output logic signed [15:0] y,        // Output value (16-bit fixed-point)
    input logic clk,                     // Clock input
    input logic reset                    // Reset input
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0; // Reset output
        end else begin
            // Calculate sigmoid: y = 1 / (1 + exp(-x))
            logic signed [15:0] exp_neg_x;
            exp_neg_x = 0; // Initialize for calculation

            // Calculate e^-x using a simple approximation
            if (x < 0) begin
                exp_neg_x = (1 << 15) / (1 + (1 << -x)); // Fixed-point approximation
            end else begin
                exp_neg_x = (1 << 15) / (1 + (1 << x));
            end

            // Calculate sigmoid value in fixed-point
            y <= (1 << 16) / (exp_neg_x + (1 << 15)); // Scale output to fixed-point
        end
    end
endmodule
