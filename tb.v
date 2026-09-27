`timescale 1ns/1ps

module tb_odd_parity_checker();

    // System Signals
    reg  clk;
    reg  rst;
    reg  bit_in;
    wire parity_odd;

    // Instantiate Unit Under Test (UUT)
    odd_parity_checker uut (
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .parity_odd(parity_odd)
    );

    // 100 MHz Clock Generation (10ns Period)
    always #5 clk = ~clk;

    // VCD Waveform Dumping Configuration
    initial begin
        $dumpfile("odd_parity_checker.vcd");
        $dumpvars(0, tb_odd_parity_checker);
    end

    // Task to drive serial bits on clock edges
    task send_bit(input b);
        begin
            @(posedge clk);
            bit_in <= b;
        end
    endtask

    initial begin
        // Initialize Signals at time 0
        clk    = 0;
        bit_in = 0;

        // Step 1: Assert Reset at t=0
        rst = 1;
        #15; // Hold reset
        rst = 0; // Deassert reset
        #1;
        $display("[RESET] State reset to EVEN. parity_odd = %b (Expect 0)", parity_odd);

        $display("\n--- TEST SEQUENCE 1: Streaming Bits [1, 0, 1, 1, 1, 0] ---");
        
        send_bit(1); // Total 1s = 1 (Odd)
        #1; $display("[TIME %0t ns] In: 1 | parity_odd: %b (Expect 1)", $time, parity_odd);

        send_bit(0); // Total 1s = 1 (Odd)
        #1; $display("[TIME %0t ns] In: 0 | parity_odd: %b (Expect 1)", $time, parity_odd);

        send_bit(1); // Total 1s = 2 (Even)
        #1; $display("[TIME %0t ns] In: 1 | parity_odd: %b (Expect 0)", $time, parity_odd);

        send_bit(1); // Total 1s = 3 (Odd)
        #1; $display("[TIME %0t ns] In: 1 | parity_odd: %b (Expect 1)", $time, parity_odd);

        send_bit(1); // Total 1s = 4 (Even)
        #1; $display("[TIME %0t ns] In: 1 | parity_odd: %b (Expect 0)", $time, parity_odd);

        send_bit(0); // Total 1s = 4 (Even)
        #1; $display("[TIME %0t ns] In: 0 | parity_odd: %b (Expect 0)", $time, parity_odd);

        $display("\n--- TEST SEQUENCE 2: Mid-stream Reset ---");
        @(posedge clk);
        rst <= 1;
        #5;
        rst <= 0;
        bit_in <= 0;
        #1;
        $display("[RESET] State reset back to EVEN. parity_odd = %b (Expect 0)", parity_odd);

        #20;
        $display("\n=======================================================");
        $display("               SIMULATION COMPLETE                   ");
        $display("=======================================================");
        $finish;
    end

endmodule
