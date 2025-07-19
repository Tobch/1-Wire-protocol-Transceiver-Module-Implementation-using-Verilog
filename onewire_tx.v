`timescale 1ns/1ps

//------------------------------------------------------------------------------
// File: one_wire_timing.v
// Description: Parameter definitions for 1-Wire protocol timing (standard speed only)
//------------------------------------------------------------------------------
module one_wire_timing #(
    // Standard speed timing (in microseconds)
    parameter integer T_RSTL = 480,
    parameter integer T_RSTH = 480,
    parameter integer T_PDH  = 15,
    parameter integer T_PDL  = 60,
    parameter integer T_SLOT = 60,
    parameter integer T_REC  = 1,
    parameter integer T_W1L  = 6,
    parameter integer T_W0L  = 60,
    parameter integer T_RDS = 15
) (
    input  clk,        // system clock
    input  rst_n       // active-low reset
);
// Timing-only module; conversion to cycles done in TX/RX modules
endmodule