`default_nettype none

module chrisruk_matrix #( parameter MAX_COUNT = 1000 ) (
  input [7:0] io_in,
  output [7:0] io_out
);
    integer bitidx = 0;
    integer pix = 0;
    integer size = 64;     //    -- Number of LEDs
    wire clk = io_in[0];
    wire reset = io_in[1];

    reg [0:0] strip_1 = 0;
    reg [0:0] clock_1 = 0;
    
    assign io_out[0] = strip_1;
    assign io_out[1] = clock_1;

    reg [64-1:0] fonts [0:26-1]; 

    reg [1:0] mem [0:64-1]; 
    

    // external clock is 6kHz, so need 10 bit counter
    reg [32:0] counter1;
    integer j;

    initial begin
        counter1 = 0;
        strip_1 = 0;
        clock_1 = 0;
        pix = 0;
        for(j = 0; j < 64; j = j + 1) 
            mem[j] = 1'b0;

        fonts[0] = 64'h00_00_1E_30_3E_33_6E_00;
        fonts[1] = 64'h07_06_06_3E_66_66_3B_00;
        fonts[2] = 64'h00_00_1E_33_03_33_1E_00;
        fonts[3] = 64'h38_30_30_3e_33_33_6E_00;
        fonts[4] = 64'h00_00_1E_33_3f_03_1E_00;
        fonts[5] = 64'h1C_36_06_0f_06_06_0F_00;
        fonts[6] = 64'h00_00_6E_33_33_3E_30_1F;
        fonts[7] = 64'h07_06_36_6E_66_66_67_00;
        fonts[8] = 64'h0C_00_0E_0C_0C_0C_1E_00;
        fonts[9] = 64'h30_00_30_30_30_33_33_1E;
        fonts[10] = 64'h07_06_66_36_1E_36_67_00;
        fonts[11] = 64'h0E_0C_0C_0C_0C_0C_1E_00;
        fonts[12] = 64'h00_00_33_7F_7F_6B_63_00;
        fonts[13] = 64'h00_00_1F_33_33_33_33_00;
        fonts[14] = 64'h00_00_1E_33_33_33_1E_00;
        fonts[15] = 64'h00_00_3B_66_66_3E_06_0F;
        fonts[16] = 64'h00_00_6E_33_33_3E_30_78;
        fonts[17] = 64'h00_00_3B_6E_66_06_0F_00;
        fonts[18] = 64'h00_00_3E_03_1E_30_1F_00;
        fonts[19] = 64'h08_0C_3E_0C_0C_2C_18_00;
        fonts[20] = 64'h00_00_33_33_33_33_6E_00;
        fonts[21] = 64'h00_00_33_33_33_1E_0C_00;
        fonts[22] = 64'h00_00_63_6B_7F_7F_36_00;
        fonts[23] = 64'h00_00_63_36_1C_36_63_00;
        fonts[24] = 64'h00_00_33_33_33_3E_30_1F;
        fonts[25] = 64'h00_00_3F_19_0C_26_3F_00;
    end 

    always @(posedge clk) begin
      

        clock_1 = ~clock_1 ;   


        if (clock_1 == 1) begin 

            if (counter1 < 32) begin
                strip_1 = 0;
            end else if (counter1 < 32 + (32 * 64)) begin
                strip_1 = 1;
            end else if (counter1 < 32 + (32 * 64) + 32 + 32) begin
                strip_1 = 0;
            end else begin
                counter1 = 0;
                strip_1 = 0;
            end

            counter1 = counter1 + 1;

        end


        
        
    end
endmodule

