
`timescale 1ns / 1ps

module uart_rx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output reg  [7:0] rx_data,
    output reg        rx_done
);

    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    localparam [1:0] IDLE  = 2'd0,
                     START = 2'd1,
                     DATA  = 2'd2,
                     STOP  = 2'd3;

    reg [1:0] state;
    reg [31:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] rx_shift_reg;

    // Synchronize the asynchronous UART input to clk
    reg rx_sync_1;
    reg rx_sync_2;

    always @(posedge clk) begin
        if (rst) begin
            rx_sync_1 <= 1'b1;
            rx_sync_2 <= 1'b1;
        end else begin
            rx_sync_1 <= rx;
            rx_sync_2 <= rx_sync_1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            clk_count    <= 0;
            bit_index    <= 0;
            rx_shift_reg <= 0;
            rx_data      <= 0;
            rx_done      <= 0;
        end else begin
            rx_done <= 1'b0;

            case (state)
                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;

                    if (rx_sync_2 == 1'b0)
                        state <= START;
                end

                START: begin
                    if (clk_count == (CLKS_PER_BIT / 2) - 1) begin
                        clk_count <= 0;

                        if (rx_sync_2 == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        rx_shift_reg[bit_index] <= rx_sync_2;

                        if (bit_index == 3'd7) begin
                            bit_index <= 0;
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        state <= IDLE;
                        rx_data <= rx_shift_reg;
                        rx_done <= 1'b1;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                default: begin
                    state <= IDLE;
                    clk_count <= 0;
                end
            endcase
        end
    end

endmodule
