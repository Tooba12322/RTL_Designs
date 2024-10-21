module tb_sigmoid;
    parameter int INPUT_WIDTH = 8;       // Input width (8 bits)
    parameter int OUTPUT_WIDTH = 16;      // Output width (16 bits)

    logic signed [INPUT_WIDTH-1:0] x;    // Input to the sigmoid module
    logic signed [OUTPUT_WIDTH-1:0] y;    // Output from the sigmoid module
    logic clk;                             // Clock signal
    logic reset;                           // Reset signal

    // Instantiate the sigmoid module
    sigmoid uut (
        .x(x),
        .y(y),
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time unit clock period
    end

    // Test stimulus
    initial begin
        reset = 1;              // Assert reset
        x = 0;                  // Initial value
        #10;                    // Wait for reset to propagate
        reset = 0;              // Deassert reset

        // Generate random test cases
        for (int i = 0; i < 20; i++) begin
            // Generate a random signed input in the range [-128, 127]
            x = $urandom_range(-128, 127);
            #10; // Wait for clock edge
            
            // Display input and output values
            $display("Input: %d, Sigmoid Output: %d", x, y);
        end

        // Finish simulation
        $finish;
    end
endmodule
