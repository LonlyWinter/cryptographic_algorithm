
module aes_en #(
    parameter int LEN_KEY = 128,
    parameter int NUM_ROUND = 10
) (
    input [127:0] data_in,
    input [LEN_KEY-1:0] key,
    output [127:0] data_out
);


localparam int NUMALL = (NUM_ROUND + 1) * 128;

// key expansion with state
wire [NUMALL-1:0] key_all;
key_expansion #(
    .LEN_KEY(LEN_KEY),
    .NUM_ROUND(NUM_ROUND)
) key_inst (
    .data_in(key),
    .data_out(key_all)
);

wire [NUMALL-1:0] data_mid;
// 初始轮
// add_round_key
assign data_mid[127:0] = data_in ^ key_all[127:0];
// wire [127:0] round0_key = key_all[127:0];
// wire [127:0] round0_res = data_mid[127:0];

genvar index;
generate
    for (index = 1; index <= NUM_ROUND; index = index + 1) begin: gen_round
        // index last
        localparam int IL = (index - 1) * 128;
        // index now
        localparam int IN = index * 128;
        // sub_bytes
        wire [127:0] sub_bytes;
        sbox #(
            .NUM(16)
        ) sbox_inst (
            .data_in(data_mid[IL+:128]),
            .data_out(sub_bytes)
        );
        // state
        wire [127:0] state_now;
        state state_inst1 (
            .data_in(sub_bytes),
            .data_out(state_now)
        );
        // shift_rows
        wire [127:0] shift_now;
        shift_rows shift_inst (
            .data_in(state_now),
            .data_out(shift_now)
        );
        // mix_columns
        wire [127:0] mix_now;
        if (index < NUM_ROUND)
            mix_columns mix_inst (
                .data_in(shift_now),
                .data_out(mix_now)
            );
        else
            assign mix_now = shift_now;
        // state
        wire [127:0] state_res;
        state state_inst2 (
            .data_in(mix_now),
            .data_out(state_res)
        );
        // add_round_key
        assign data_mid[IN+:128] = state_res ^ key_all[IN+:128];
        // wire [127:0] round_inp = data_mid[IL+:128];
        // wire [127:0] round_key = key_all[IN+:128];
        // wire [127:0] round_res = data_mid[IN+:128];
    end
endgenerate

state state_inst_res (
    .data_in(data_mid[NUMALL-128+:128]),
    .data_out(data_out)
);


endmodule
