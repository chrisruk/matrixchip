`default_nettype none

module chrisruk_matrix #( parameter MAX_COUNT = 1000 ) (
  input [7:0] io_in,
  output [7:0] io_out
);
    wire clk = io_in[0];
    wire reset = io_in[1];

    reg [0:0] resetflag = 1;
    reg [0:0] clock_1 = 0;
    reg [0:0] strip_1 = 0;
    
    assign io_out[0] = clock_1;
    assign io_out[1] = strip_1;

    reg [0:64-1] fonts [0:4-1];
    reg [12:0] counter1;
    reg [4:0] lcounter;
    reg [7:0] idx;
    reg [7:0] pidx;
    reg [7:0] zz;
    reg [0:32-1] ledreg;
    reg [0:32-1] ledreg2;

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
        if (reset || resetflag) begin
            lcounter = 0;
            counter1 = 0;
            idx = 0;
            pidx = 0;
            strip_1 = 0;
            clock_1 = 0;
            resetflag = 0;
            zz = 0;
            ledreg = 32'hf00f0000;
            ledreg2 = 32'hf0000000;
            fonts[0] = 64'he0_60_6c_76_66_66_e6_00;  // h
            fonts[1] = 64'h00_00_78_cc_fc_c0_78_00;  // e
            fonts[2] = 64'h70_30_30_30_30_30_78_00;  // l
            fonts[3] = 64'h00_00_78_cc_cc_cc_78_00;  // o
        end else begin
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
    end
endmodule

