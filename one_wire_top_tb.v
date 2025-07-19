//------------------------------------------------------------------------------
// File: one_wire_top_tb.v
// Description: Testbench for one_wire_top
//------------------------------------------------------------------------------
`timescale 1ns/1ps
module one_wire_top_tb;
    reg clk;
    reg rst_n;
    reg start;
    reg enable;
    reg [7:0] tx_byte;
    wire busy;
    wire done;
    wire presence_detect;
    wire rx_valid;
    wire [7:0] rx_byte;
    wire one_wire_data;

    reg manual_drive;

    // Clock generator
    initial clk = 0; always #5 clk = ~clk;

    // Drive logic: TX or manual
    wire tx_drive;
    // Extract drive_low from tx_inst via hierarchical reference
    // Note: QuestaSim may require force command; using manual drive only for reset/starvation
    assign one_wire_data = manual_drive ? 1'b0 : 1'bz;

    one_wire_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_byte(tx_byte),
        .enable(enable),
        .busy(busy),
        .done(done),
        .presence_detect(presence_detect),
        .rx_valid(rx_valid),
        .rx_byte(rx_byte),
        .one_wire_data(one_wire_data)
    );

    initial begin
        rst_n = 0; start = 0; enable = 0; tx_byte = 8'hA5; manual_drive = 0;
        #20 rst_n = 1;
        #20 enable = 1;
        #10 start = 1;
        #10 start = 0;
        wait(done);
        #100_000;
        if (rx_valid && rx_byte == tx_byte)
            $display("PASS: Top-level RX got 0x%0h", rx_byte);
        else
            $display("FAIL: Top-level RX=0x%0h", rx_byte);
        $stop;
    end
endmodule
