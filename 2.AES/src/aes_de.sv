
module aes_de #(
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
wire [127:0] data_init;
wire [127:0] key_init;
state state_inst_key (
    .data_in({
        key_all[NUMALL-128+:32],
        key_all[NUMALL-96+:32],
        key_all[NUMALL-64+:32],
        key_all[NUMALL-32+:32]
    }),
    .data_out(key_init)
);
state state_inst_init (
    .data_in(data_in),
    .data_out(data_init)
);

assign data_mid[127:0] = data_init ^ key_init;
wire [127:0] round0 = data_mid[127:0];

genvar index;
generate
    for (index = 1; index <= NUM_ROUND; index = index + 1) begin: gen_round
        // index last
        localparam int IL = (index - 1) * 128;
        // index now
        localparam int IN = index * 128;
        // shift_rows
        wire [127:0] shift_now;
        shift_rows #(
            .EN(0)
        ) shift_inst (
            .data_in(data_mid[IL+:128]),
            .data_out(shift_now)
        );
        // sub_bytes
        wire [127:0] sub_bytes;
        sbox #(
            .NUM(16),
            .EN(0)
        ) sbox_inst (
            .data_in(shift_now),
            .data_out(sub_bytes)
        );
        // add_round_key
        wire [127:0] round_key;
        state state_inst_key (
            .data_in({
                key_all[NUMALL-IN-128+:32],
                key_all[NUMALL-IN-96+:32],
                key_all[NUMALL-IN-64+:32],
                key_all[NUMALL-IN-32+:32]
            }),
            .data_out(round_key)
        );
        wire [127:0] add_key = sub_bytes ^ round_key;
        // mix_columns
        wire [127:0] mix_now;
        if (index < NUM_ROUND)
            mix_columns #(
                .EN(0)
            ) mix_inst (
                .data_in(add_key),
                .data_out(mix_now)
            );
        else
            assign mix_now = add_key;
        // res
        assign data_mid[IN+:128] = mix_now;
    end
endgenerate

state state_inst_res (
    .data_in(data_mid[NUMALL-128+:128]),
    .data_out(data_out)
);

endmodule
