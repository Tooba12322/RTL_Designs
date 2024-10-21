module tb_log2;
    parameter int N = 8; // Width of the input value
    parameter int M = 3; // Width of the output result

    logic clk;
    logic reset;
    logic [N-1:0] value;
    logic [M-1:0] result;
    logic valid;

    // Instantiate the log2 module
    log2 #(.N(N), .M(M)) uut (
        .clk(clk),
        .reset(reset),
        .value(value),
        .result(result),
        .valid(valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Test stimulus
    initial begin
        reset = 1;          // Assert reset
        value = 0;         // Initial value
        #10;               // Wait for reset to propagate
        reset = 0;         // Deassert reset

        // Generate random test cases
        for (int i = 0; i < 10; i++) begin
            // Generate a random value in the range [0, 255]
            value = $urandom_range(0, 255);
            #10; // Wait for clock edge
            // Check the results
            if (valid) begin
                $display("Log2 of %0d is %0d (valid)", value, result);
            end else begin
                $display("Log2 of %0d is undefined (invalid)", value);
            end
        end

        // Finish simulation
        $finish;
    end
endmodule
