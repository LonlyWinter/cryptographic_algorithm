
module sm4_de (
    input [127:0] data_in,
    input [127:0] key,
    output [127:0] data_out
);

wire [1023:0] key_all;
key_expansion key_inst (
    .data_in(key),
    .data_out(key_all)
);

wire [1151:0] data_mid;

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin: gen_init
        localparam int INDEX1 = i * 32;
        localparam int INDEX2 = 96 - i * 32;
        assign data_mid[INDEX1+:32] = data_in[INDEX2+:32];
    end
endgenerate
// wire [127:0] data_init = data_mid[127:0];

generate
    for (i = 0; i < 32; i = i + 1) begin: gen_round
        localparam int START = i * 32;
        localparam int STARTN = (i + 4) * 32;
        localparam int STARTK = (31 - i) * 32;

        // wire [31:0] data0 = data_mid[START+:32];
        // wire [31:0] data1 = data_mid[START+32+:32];
        // wire [31:0] data2 = data_mid[START+64+:32];
        // wire [31:0] data3 = data_mid[START+96+:32];
        // wire [31:0] data_ck = key_all[START+:32];

        wire [31:0] temp =  data_mid[START+32+:32]
                            ^ data_mid[START+64+:32]
                            ^ data_mid[START+96+:32]
                            ^ key_all[STARTK+:32];
        // T
        // sbox
        wire [31:0] sbox;
        sbox #(
            .NUM(4)
        ) sbox_inst (
            .data_in(temp),
            .data_out(sbox)
        );
        // L
        assign data_mid[STARTN+:32] = sbox ^ {
            sbox[29:0],
            sbox[31:30]
        } ^ {
            sbox[21:0],
            sbox[31:22]
        } ^ {
            sbox[13:0],
            sbox[31:14]
        } ^ {
            sbox[7:0],
            sbox[31:8]
        } ^ data_mid[START+:32];
        // wire [31:0] data_temp = data_mid[STARTN+:32];
    end
endgenerate

assign data_out = data_mid[1151:1024];

endmodule
