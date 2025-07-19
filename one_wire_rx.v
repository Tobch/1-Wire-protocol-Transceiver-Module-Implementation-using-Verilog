//------------------------------------------------------------------------------
// File: one_wire_rx.v
// Description: 1-Wire Receiver FSM (Slave mode)
//------------------------------------------------------------------------------
module one_wire_rx (
    input        clk,
    input        rst_n,
    input        enable,
    inout        one_wire_data,
    output reg   presence_detect,
    output reg   rx_valid,
    output reg [7:0] rx_byte
);
    // 1-Wire timing in microseconds
    localparam integer T_PDL  = 60;
    localparam integer T_RDS  = 15;
    localparam integer T_REC  = 1;
    // convert to cycles
    localparam integer CLK_MHZ   = 100;
    localparam integer PDL_CYC   = T_PDL * CLK_MHZ;
    localparam integer RDSAMP_CYC= T_RDS * CLK_MHZ;
    localparam integer REC_CYC   = T_REC * CLK_MHZ;

    // FSM states
    localparam R_IDLE       = 3'd0;
    localparam R_WAIT_RST   = 3'd1;
    localparam R_PRES_PULSE = 3'd2;
    localparam R_SAMPLE     = 3'd3;
    localparam R_CAPTURE    = 3'd4;
    localparam R_DONE       = 3'd5;

    reg [2:0]  rstate, rnstate;
    reg [31:0] cnt;
    reg [2:0]  bit_cnt;
    reg        drive_low;
    reg        data_in;

    assign one_wire_data = drive_low ? 1'b0 : 1'bz;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rstate        <= R_IDLE;
            cnt           <= 32'd0;
            bit_cnt       <= 3'd0;
            rx_valid      <= 1'b0;
            presence_detect <= 1'b0;
        end else begin
            if (rstate == rnstate)
                cnt <= cnt + 1;
            else
                cnt <= 32'd0;
            rstate <= rnstate;
        end
    end

    always @(*) begin
        rnstate        = rstate;
        drive_low      = 1'b0;
        presence_detect= 1'b0;
        rx_valid       = 1'b0;
        data_in        = 1'b1;
        case (rstate)
            R_IDLE:    if (enable) rnstate = R_WAIT_RST;
            R_WAIT_RST:if (!one_wire_data) rnstate = R_PRES_PULSE;
            R_PRES_PULSE: begin
                drive_low       = 1'b1;
                presence_detect = 1'b1;
                if (cnt >= PDL_CYC) rnstate = R_SAMPLE;
            end
            R_SAMPLE:  begin
                if (!one_wire_data) begin
                    data_in = 1'b0;
                    rnstate = R_CAPTURE;
                end else if (cnt >= RDSAMP_CYC) begin
                    data_in = 1'b1;
                    rnstate = R_CAPTURE;
                end
            end
            R_CAPTURE: begin
                rx_byte[bit_cnt] = data_in;
                if (bit_cnt == 3'd7)
                    rnstate = R_DONE;
                else begin
                    rnstate = R_SAMPLE;
                    bit_cnt = bit_cnt + 1;
                end
            end
            R_DONE:    begin
                rx_valid = 1'b1;
                rnstate  = R_IDLE;
            end
        endcase
    end
endmodule