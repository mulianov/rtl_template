`timescale 1ns / 1ps
module top #(
    parameter int unsigned COUNTER_MAX = 10
) (
    input        clk,
    input        reset,
    input  logic button,
    output logic red,
    output logic green,
    output logic blue
);
    typedef enum logic [1:0] {
        BLANK = 2'b00,
        RED   = 2'b01,
        GREEN = 2'b11,
        BLUE  = 2'b10,
        XXX   = 'x
    } state_e;

    state_e state, next;

    localparam int unsigned COUNTER_WIDTH = $clog2(COUNTER_MAX);
    logic [COUNTER_WIDTH-1:0] counter;
    logic counter_done;

    always_ff @(posedge clk or posedge reset)
        if (reset) counter <= '0;
        else if (state != next) counter <= '0;
        else counter <= counter + 1'b1;

    assign counter_done = (int'(counter) == COUNTER_MAX - 1) ? 1'b1 : '0;

    always_ff @(posedge clk or posedge reset)
        if (reset) state <= BLANK;
        else state <= next;

    always_comb begin
        next = XXX;
        case (state)
            BLANK:   if (button) next = RED;
                    else next = BLANK;  // @lb
            RED:     if (counter_done) next = GREEN;
                    else next = RED;  // @lb
            GREEN:   if (counter_done) next = BLUE;
                    else next = GREEN;  // @lb
            BLUE:    if (counter_done) next = BLANK;
                    else next = BLUE;  // @lb
            default: next = XXX;
        endcase
    end

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            red   <= '0;
            green <= '0;
            blue  <= '0;
        end else begin
            red   <= '0;
            green <= '0;
            blue  <= '0;
            case (next)
                BLANK:   ;
                RED:     red <= 1'b1;
                GREEN:   green <= 1'b1;
                BLUE:    blue <= 1'b1;
                default: {red, green, blue} <= 'x;
            endcase
        end

`ifdef VERIFY
    always_ff @(negedge reset) begin
        AssertionExample : assert (state == BLANK);
    end

    // And example coverage analysis
    cover property (@(posedge clk) state == BLANK);
    cover property (@(posedge clk) state == RED);
    cover property (@(posedge clk) state == GREEN);
    cover property (@(posedge clk) state == BLUE);
`endif

endmodule
