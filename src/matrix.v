`default_nettype none

module chrisruk_matrix #( parameter MAX_COUNT = 1000 ) (
  input [7:0] io_in,
  output [7:0] io_out
);
    wire clk = io_in[0];
    reg [0:0] clock_1 = 0;
    reg [0:0] strip_1 = 0;
    
    assign io_out[0] = clock_1;
    assign io_out[1] = strip_1;

    reg [0:64-1] fonts [0:4-1];
    reg [12:0] counter1;
    reg [4:0] lcounter = 0;
    reg [7:0] idx = 0;
    reg [7:0] pidx = 0;
    reg [7:0] zz = 0;
    reg [0:32-1] ledreg = 32'hf00f0000;
    reg [0:32-1] ledreg2 = 32'hf0000000;

    /*wire [7:0] data [0:4];
    assign data[0]  = "h";
    assign data[1]  = "e";
    assign data[2]  = "l";
    assign data[3]  = "l";
    assign data[4]  = "o";*/



    initial begin
        counter1 = 0;
        strip_1 = 0;
        clock_1 = 0;

        fonts[0] = 64'he0_60_6c_76_66_66_e6_00;  // h
        fonts[1] = 64'h00_00_78_cc_fc_c0_78_00;  // e
        fonts[2] = 64'h70_30_30_30_30_30_78_00;  // l
        fonts[3] = 64'h00_00_78_cc_cc_cc_78_00;  // o

        /*fonts[0] = 64'h00_00_78_0c_7c_cc_76_00; // a
        fonts[1] = 64'he0_60_60_7c_66_66_dc_00;   // b
        fonts[2] = 64'h00_00_78_cc_c0_cc_78_00;   // c
        fonts[3] = 64'h1c_0c_0c_7c_cc_cc_76_00;   // d
        fonts[4] = 64'h00_00_78_cc_fc_c0_78_00;   // e
        fonts[5] = 64'h38_6c_60_f0_60_60_f0_00;   // f
        fonts[6] = 64'h00_00_76_cc_cc_7c_0c_f8;   // g
        fonts[7] = 64'he0_60_6c_76_66_66_e6_00;   // h
        fonts[8] = 64'h30_00_70_30_30_30_78_00;   // i
        fonts[9] = 64'h0c_00_0c_0c_0c_cc_cc_78;   // j
        fonts[10] = 64'he0_60_66_6c_78_6c_e6_00;  // k
        fonts[11] = 64'h70_30_30_30_30_30_78_00;  // l
        fonts[12] = 64'h00_00_cc_fe_fe_d6_c6_00;  // m
        fonts[13] = 64'h00_00_f8_cc_cc_cc_cc_00;  // n
        fonts[14] = 64'h00_00_78_cc_cc_cc_78_00;  // o
        fonts[15] = 64'h00_00_dc_66_66_7c_60_f0;  // p
        fonts[16] = 64'h00_00_76_cc_cc_7c_0c_1e;  // q
        fonts[17] = 64'h00_00_dc_76_66_60_f0_00;  // r
        fonts[18] = 64'h00_00_7c_c0_78_0c_f8_00;  // s
        fonts[19] = 64'h10_30_7c_30_30_34_18_00;  // t
        fonts[20] = 64'h00_00_cc_cc_cc_cc_76_00;  // u
        fonts[21] = 64'h00_00_cc_cc_cc_78_30_00;  // v
        fonts[22] = 64'h00_00_c6_d6_fe_fe_6c_00;  // w
        fonts[23] = 64'h00_00_c6_6c_38_6c_c6_00;  // x
        fonts[24] = 64'h00_00_cc_cc_cc_7c_0c_f8;  // y
        fonts[25] = 64'h00_00_fc_98_30_64_fc_00;  // z */
    end 

`ifdef FPGA
    reg [0:0] clk2 = 0;
    integer counter = 0;

    always @(posedge clk) begin
        if (counter == 2000) begin
            clk2 = ~clk2;
            counter = 0;
        end else begin
            counter <= counter + 1;
        end
    end

    always @(posedge clk2) begin
`else
    always @(posedge clk) begin
`endif

        clock_1 = ~clock_1 ;

        if (clock_1 == 1) begin 
            if (counter1 < 32) begin
                strip_1 = 0;
            end else if (counter1 < 32 + (32 * (8*8))) begin

                if((pidx / 8) == 0) begin
                    zz = 8 - 1 - pidx;
                end else if((pidx / 8) == 2) begin
                    zz = 40 - 1 -  pidx;
                end else if((pidx / 8) == 4) begin
                    zz = 72 - 1 - pidx;
                end else if((pidx / 8) == 6) begin
                    zz = 104 - 1 - pidx;
                end else begin
                    zz = pidx;
                end

                //if (fonts[data[lcounter] - 97][zz] == 1) begin
                if (fonts[lcounter][zz] == 1) begin
                    strip_1 = ledreg[idx];
                end else begin
                    strip_1 = ledreg2[idx];
                end

                idx = idx + 1;

                if (idx == 32) begin
                    idx = 0;
                    pidx = pidx + 1;
                end

                if (pidx == 64) begin
                    pidx = 0;
                end

            end else if (counter1 < 32 + (32 * (8*8)) + 32 + 32) begin
                strip_1 = 0;
            end else begin
                counter1 = 0;
                strip_1 = 0;
                pidx = 0;
                idx = 0;
                lcounter = lcounter + 1;

                if (lcounter == 5) begin
                    lcounter = 0;
                end
            end

            counter1 = counter1 + 1;
        end
    end
endmodule

