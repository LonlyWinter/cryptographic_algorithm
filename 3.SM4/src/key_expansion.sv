
module key_expansion (
    input [127:0] data_in,
    input [1023:0] data_out
);

wire [127:0] FK = {
    // 3
    32'hB27022DC,
    // 2
    32'h677D9197,
    // 1
    32'h56AA3350,
    // 0
    32'hA3B1BAC6
};
wire [1023:0] CK = {
    32'h00070E15, 32'h1C232A31, 32'h383F464D, 32'h545B6269,
    32'h70777E85, 32'h8C939AA1, 32'hA8AFB6BD, 32'hC4CBD2D9,
    32'hE0E7EEF5, 32'hFC030A11, 32'h181F262D, 32'h343B4249,
    32'h50575E65, 32'h6C737A81, 32'h888F969D, 32'hA4ABB2B9,
    32'hC0C7CED5, 32'hDCE3EAF1, 32'hF8FF060D, 32'h141B2229,
    32'h30373E45, 32'h4C535A61, 32'h686F767D, 32'h848B9299,
    32'hA0A7AEB5, 32'hBCC3CAD1, 32'hD8DFE6ED, 32'hF4FB0209,
    32'h10171E25, 32'h2C333A41, 32'h484F565D, 32'h646B7279
};

wire [1151:0] K;

// init
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin: gen_init
        localparam int INDEX1 = i * 32;
        localparam int INDEX2 = 96 - i * 32;
        assign K[INDEX1+:32] = data_in[INDEX2+:32] ^ FK[INDEX1+:32];
    end
endgenerate
// wire [127:0] k_init = K[127:0];

// 32 round
generate
    for (i = 0; i < 32; i = i + 1) begin: gen_round
        localparam int START = i * 32;
        localparam int STARTN = (i + 4) * 32;
        localparam int STARTCK = 992 - i * 32;

        // wire [31:0] k0 = K[START+:32];
        // wire [31:0] k1 = K[START+32+:32];
        // wire [31:0] k2 = K[START+64+:32];
        // wire [31:0] k3 = K[START+96+:32];
        // wire [31:0] k_ck = CK[STARTCK+:32];

        wire [31:0] temp =  K[START+32+:32]
                            ^ K[START+64+:32]
                            ^ K[START+96+:32]
                            ^ CK[STARTCK+:32];
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
        assign data_out[START+:32] = sbox ^ {
            sbox[18:0],
            sbox[31:19]
        } ^ {
            sbox[8:0],
            sbox[31:9]
        } ^ K[START+:32];
        // XOR
        assign K[STARTN+:32] =  data_out[START+:32];
        // wire [31:0] key_temp = data_out[START+:32];
    end
endgenerate

endmodule
