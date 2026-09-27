module odd_parity_checker (
    input  wire clk,
    input  wire rst,     // synchronous reset, active high
    input  wire bit_in,  // serial input bit
    output wire parity_odd // 1 if number of 1s seen so far is odd
);

    // Two states: EVEN (even number of 1s seen) and ODD (odd number of 1s seen)
    reg state; 
    localparam EVEN = 1'b0;
    localparam ODD  = 1'b1;

    always @(posedge clk) begin
        if (rst)
            state <= EVEN;
        else begin
            case (state)
                EVEN: state <= bit_in ? ODD  : EVEN;
                ODD : state <= bit_in ? EVEN : ODD;
            endcase
        end
    end

    // Output is high whenever we're in the ODD state
    assign parity_odd = (state == ODD);

endmodule
