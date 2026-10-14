
`timescale 1ns / 1ps

module tb_uart_rx;

    // Reduced parameters for faster simulation
    localparam CLK_FREQ  = 100;
    localparam BAUD_RATE = 10;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] rx_data;
    wire rx_done;

    integer errors;
    integer i;
    reg [7:0] expected_data;

    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Send a UART frame: idle, start, 8 data bits, stop
    task send_uart_byte;
        input [7:0] data;
        integer j;
        begin
            // Idle state
            rx = 1'b1;
            repeat (CLKS_PER_BIT) @(negedge clk);

            // Start bit
            rx = 1'b0;
            repeat (CLKS_PER_BIT) @(negedge clk);

            // Data bits, LSB first
            for (j = 0; j < 8; j = j + 1) begin
                rx = data[j];
                repeat (CLKS_PER_BIT) @(negedge clk);
            end

            // Stop bit
            rx = 1'b1;
            repeat (CLKS_PER_BIT) @(negedge clk);
        end
    endtask

    initial begin
        rst = 1'b1;
        rx = 1'b1;
        errors = 0;
        expected_data = 8'hA5;

        repeat (5) @(negedge clk);
        rst = 1'b0;

        // Allow the receiver to settle
        repeat (3) @(negedge clk);

        $display("Sending UART byte: %h", expected_data);
        send_uart_byte(expected_data);

        // Allow the receiver to finish processing the stop bit
        repeat (3) @(negedge clk);

        if (rx_data !== expected_data) begin
            $display("FAIL: Expected %h, received %h",
                     expected_data, rx_data);
            errors = errors + 1;
        end else begin
            $display("PASS: Received data correctly: %h", rx_data);
        end

        if (errors == 0)
            $display("ALL UART RX TESTS PASSED");
        else
            $display("UART RX TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

    initial begin
        #5000;
        $display("FAIL: Simulation timeout");
        $finish;
    end

endmodule
