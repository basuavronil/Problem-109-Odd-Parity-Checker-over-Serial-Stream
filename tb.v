module tb;
    reg clk = 0, rst, bit_in;
    wire parity_odd;

    // Instantiate DUT
    odd_parity_checker uut (
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .parity_odd(parity_odd)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Waveform dump for GTKWave / any VCD viewer
    initial begin
        $dumpfile("odd_parity_checker.vcd");
        $dumpvars(0, tb);
    end

    // Stimulus
    initial begin
        // Reset
        rst = 1; bit_in = 0;
        @(posedge clk);
        rst = 0;

        // Feed a sequence of bits and watch parity flip
        bit_in = 1; @(posedge clk); // 1 one   -> odd
        bit_in = 0; @(posedge clk); // 1 one   -> odd (no change)
        bit_in = 1; @(posedge clk); // 2 ones  -> even
        bit_in = 1; @(posedge clk); // 3 ones  -> odd
        bit_in = 0; @(posedge clk); // 3 ones  -> odd (no change)
        bit_in = 0; @(posedge clk); // 3 ones  -> odd (no change)
        bit_in = 1; @(posedge clk); // 4 ones  -> even
        bit_in = 1; @(posedge clk); // 5 ones  -> odd

        // Mid-stream reset check
        rst = 1; @(posedge clk);    // reset -> even
        rst = 0;

        bit_in = 1; @(posedge clk); // 1 one   -> odd
        bit_in = 1; @(posedge clk); // 2 ones  -> even
        bit_in = 0; @(posedge clk); // 2 ones  -> even (no change)
        bit_in = 1; @(posedge clk); // 3 ones  -> odd

        #10;
        $finish;
    end

    // Live console monitor
    initial begin
        $monitor("t=%0t rst=%b bit_in=%b state_parity_odd=%b",
                   $time, rst, bit_in, parity_odd);
    end

endmodule
