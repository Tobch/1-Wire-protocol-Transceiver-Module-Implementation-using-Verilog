//------------------------------------------------------------------------------
// File: one_wire_rx_tb.v
// Description: Testbench for one_wire_rx module
//------------------------------------------------------------------------------
module one_wire_rx_tb;
    reg        clk;
    reg        rst_n;
    reg        enable;
    reg        drive_master;
    wire       one_wire_data;
    wire       presence_detect;
    wire       rx_valid;
    wire [7:0] rx_byte;
    integer    i;

    initial begin clk = 1'b0; forever #5 clk = ~clk; end

    one_wire_rx dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .one_wire_data(one_wire_data),
        .presence_detect(presence_detect),
        .rx_valid(rx_valid),
        .rx_byte(rx_byte)
    );

    assign one_wire_data = drive_master ? 1'b0 : 1'bz;

    initial begin
        // Reset and init
        rst_n         = 1'b0;
        enable        = 1'b0;
        drive_master  = 1'b0;
        #20 rst_n = 1'b1;
        #20 enable = 1'b1;

        // Master reset pulse (480us)
        drive_master = 1'b1; #480_000;
        drive_master = 1'b0; #100_000;

        // Send 8 bits MSB->LSB of 0xA5
        for (i = 7; i >= 0; i = i - 1) begin
            if ((8'hA5 >> i) & 1) begin
                drive_master = 1'b1; #6_000;
                drive_master = 1'b0; #54_000;
            end else begin
                drive_master = 1'b1; #60_000;
                drive_master = 1'b0; #0;
            end
        end

        // Wait for reception
        #100_000;
        if (rx_valid && rx_byte == 8'hA5)
            $display("PASS: RX captured A5");
        else
            $display("FAIL: RX=0x%0h", rx_byte);
        $stop;
    end
endmodule
