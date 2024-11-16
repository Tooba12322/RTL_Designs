module tb_log2;
    parameter N = 8; // Width of the input value
    parameter M = 3; // Width of the output result

    logic clk;
    logic rst;
    logic [N-1:0] value;
    logic [M-1:0] result;
    logic valid;

    // Instantiate the log2 module
    log2 #(.N(N), .M(M)) uut (
        .clk(clk),
        .rst(rst),
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
        rst = '0;          // Assert reset
        value = '0;         // Initial value
        #10;               // Wait for reset to propagate
        rst = '1;         // Deassert reset

        // Generate random test cases
        for (int i = 0; i < 10; i++) begin
            // Generate a random value in the range [0, 255]
            value = $urandom_range(0, 255);
            #10; // Wait for clock edge
            // Check the results
            if (valid) begin
              $display("Log2 of %0d is %0d (valid)", value, result);
            end 
            else begin
              $display("Log2 of %0d is %0d (invalid)", value, result);
            end
        end

        // Finish simulation
        $finish;
    end
endmodule


// Output :
Log2 of 146 is 7 (invalid)
Log2 of 64 is 6 (valid)
Log2 of 4 is 2 (valid)
Log2 of 49 is 5 (invalid)
Log2 of 134 is 7 (invalid)
Log2 of 198 is 7 (invalid)
Log2 of 50 is 5 (invalid)
Log2 of 9 is 3 (invalid)
Log2 of 128 is 7 (valid)
Log2 of 134 is 7 (invalid)
