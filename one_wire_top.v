//------------------------------------------------------------------------------
// File: one_wire_top.v
// Description: Top-level 1-Wire Transceiver integrating TX and RX
//------------------------------------------------------------------------------
`timescale 1ns/1ps
module one_wire_top (
    input        clk,
    input        rst_n,
    input        start,       // Master start
    input  [7:0] tx_byte,     // Master data
    input        enable,      // Slave enable
    output       busy,
    output       done,
    output       presence_detect,
    output       rx_valid,
    output [7:0] rx_byte,
    inout        one_wire_data
);
    wire tx_busy;
    wire tx_done;
    wire rx_presence;

    // Instantiate TX
    one_wire_tx tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_byte(tx_byte),
        .busy(tx_busy),
        .done(tx_done),
        .one_wire_data(one_wire_data)
    );

    // Instantiate RX
    one_wire_rx rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .one_wire_data(one_wire_data),
        .presence_detect(rx_presence),
        .rx_valid(rx_valid),
        .rx_byte(rx_byte)
    );

    assign busy = tx_busy;
    assign done = tx_done;
    assign presence_detect = rx_presence;
endmodule
