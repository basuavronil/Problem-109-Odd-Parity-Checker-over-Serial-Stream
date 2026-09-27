module odd_parity_checker (
    input  wire clk,
    input  wire rst,        // Active-high asynchronous reset
    input  wire bit_in,     // Serial input bit
    output wire parity_odd  // 1 if number of 1s seen so far is odd
);

    // Two states: EVEN (even number of 1s seen) and ODD (odd number of 1s seen)
    reg state; 
    localparam EVEN = 1'b0;
    localparam ODD  = 1'b1;

    // Asynchronous Reset Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EVEN;
        end else begin
            case (state)
                EVEN: state <= bit_in ? ODD  : EVEN;
                ODD : state <= bit_in ? EVEN : ODD;
            endcase
        end
    end

    // Output logic
    assign parity_odd = (state == ODD);

endmodule
