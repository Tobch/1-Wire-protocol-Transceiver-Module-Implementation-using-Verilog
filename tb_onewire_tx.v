//------------------------------------------------------------------------------
// File: one_wire_tx_tb.v
// Description: Testbench for one_wire_tx module
//------------------------------------------------------------------------------
module one_wire_tx_tb;
    reg clk;
    initial clk = 0; always #5 clk = ~clk; // 100 MHz

    reg rst_n;
    reg start;
    reg [7:0] tx_byte;
    wire busy;
    wire done;
    wire one_wire_data;

    one_wire_tx dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_byte(tx_byte),
        .busy(busy),
        .done(done),
        .one_wire_data(one_wire_data)
    );

    initial begin
        rst_n   = 0;
        start   = 0;
        tx_byte = 8'hA5;
        #20 rst_n = 1;
        #20 start = 1;
        #10 start = 0;
        wait(done);
        #100_000;  // 100 µs more to be safe
        $display("PASS: Transmission complete");
        $stop;
    end
endmodule