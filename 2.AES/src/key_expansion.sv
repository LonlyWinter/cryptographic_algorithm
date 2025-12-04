
module key_expansion #(
    parameter int LEN_KEY = 128,
    parameter int NUM_ROUND = 10
) (
    input [LEN_KEY-1:0] data_in,
    output [NUMWORD*32-1:0] data_out
);


localparam int NUMWORD = (NUM_ROUND + 1) * 4;
localparam int NUMHEAD = LEN_KEY / 32;

// 初始轮
genvar i;
generate
    for (i = 0; i < NUMHEAD; i = i + 1) begin: gen_init
        localparam int I1 = LEN_KEY - i * 32 - 32;
        localparam int I5 = (NUMHEAD - i - 1) * 32;
        assign data_out[I5+:32] = data_in[I1+:32];
    end
endgenerate

wire [111:0] rcon_all = {
    8'h01,
    8'h02,
    8'h04,
    8'h08,
    8'h10,
    8'h20,
    8'h40,
    8'h80,
    8'h1B,
    8'h36,
    8'h6C,
    8'hD8,
    8'hAB,
    8'h4D
};

// 4/5/6/7 0/1/2/3
generate
    for (i = NUMHEAD; i < NUMWORD; i = i + 1) begin: gen_key
        localparam logic I01 = i / NUMHEAD * NUMHEAD;
        localparam logic I02 = NUMHEAD - i % NUMHEAD;
        localparam logic I1 = i % NUMHEAD == 0;
        localparam int I2 = (I1) ? (i - NUMHEAD) * 32 : (I01 + I02) * 32;
        localparam int I3 = (I1) ? (i - 1) * 32 : (I01 - i % NUMHEAD - 1) * 32;
        localparam int I4 = (14 - i / NUMHEAD) * 8;
        localparam int I5 = (I01 + I02 - 1) * 32;
        wire [31:0] temp = data_out[I2+:32];
        wire [31:0] w_i_nk = data_out[I3+:32];
        if (I1) begin: gen_i1
            // subword(rotword(temp)) XOR rcon[i/NUMHEAD]
            wire [31:0] rotword = {temp[23:0], temp[31:24]};
            wire [31:0] subword;
            sbox #(
                .NUM(4)
            ) sbox_inst (
                .data_in(rotword),
                .data_out(subword)
            );
            wire [31:0] rcon = {
                rcon_all[I4+:8],
                24'd0
            };
            // wire [31:0] res = w_i_nk ^ (subword ^ rcon);
            assign data_out[I5+:32] = w_i_nk ^ (subword ^ rcon);
        end
        else
            // wire [31:0] res = w_i_nk ^ temp;
            assign data_out[I5+:32] = w_i_nk ^ temp;
    end
endgenerate


endmodule
