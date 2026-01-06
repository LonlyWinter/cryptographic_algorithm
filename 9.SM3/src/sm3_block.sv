
module sm3_block (
    input [511:0] data,
    input [255:0] state_init,
    output [255:0] state_res
);


wire [2175:0] msg;
wire [2047:0] msg0;
msg_expand msg_inst (
    .data(data),
    .msg(msg),
    .msg0(msg0)
);

wire [2047:0] t_rot = {
    32'h79cc4519,
    32'hf3988a32,
    32'he7311465,
    32'hce6228cb,
    32'h9cc45197,
    32'h3988a32f,
    32'h7311465e,
    32'he6228cbc,
    32'hcc451979,
    32'h988a32f3,
    32'h311465e7,
    32'h6228cbce,
    32'hc451979c,
    32'h88a32f39,
    32'h11465e73,
    32'h228cbce6,
    32'h9d8a7a87,
    32'h3b14f50f,
    32'h7629ea1e,
    32'hec53d43c,
    32'hd8a7a879,
    32'hb14f50f3,
    32'h629ea1e7,
    32'hc53d43ce,
    32'h8a7a879d,
    32'h14f50f3b,
    32'h29ea1e76,
    32'h53d43cec,
    32'ha7a879d8,
    32'h4f50f3b1,
    32'h9ea1e762,
    32'h3d43cec5,
    32'h7a879d8a,
    32'hf50f3b14,
    32'hea1e7629,
    32'hd43cec53,
    32'ha879d8a7,
    32'h50f3b14f,
    32'ha1e7629e,
    32'h43cec53d,
    32'h879d8a7a,
    32'h0f3b14f5,
    32'h1e7629ea,
    32'h3cec53d4,
    32'h79d8a7a8,
    32'hf3b14f50,
    32'he7629ea1,
    32'hcec53d43,
    32'h9d8a7a87,
    32'h3b14f50f,
    32'h7629ea1e,
    32'hec53d43c,
    32'hd8a7a879,
    32'hb14f50f3,
    32'h629ea1e7,
    32'hc53d43ce,
    32'h8a7a879d,
    32'h14f50f3b,
    32'h29ea1e76,
    32'h53d43cec,
    32'ha7a879d8,
    32'h4f50f3b1,
    32'h9ea1e762,
    32'h3d43cec5
};

wire [256*(64+1)-1:0] state_mid;
assign state_mid[0+:256] = state_init;

genvar index;
generate
    for (index = 0; index < 64; index = index + 1) begin: gen_loop
        localparam int AIDX = 256 * index + 32 * 7;
        localparam int BIDX = 256 * index + 32 * 6;
        localparam int CIDX = 256 * index + 32 * 5;
        localparam int DIDX = 256 * index + 32 * 4;
        localparam int EIDX = 256 * index + 32 * 3;
        localparam int FIDX = 256 * index + 32 * 2;
        localparam int GIDX = 256 * index + 32 * 1;
        localparam int HIDX = 256 * index + 32 * 0;
        localparam int TIDX = (63 - index) * 32;
        localparam int MIDX = index * 32;
        // // debug
        // wire [31:0] state_a = state_mid[AIDX+:32];
        // wire [31:0] state_b = state_mid[BIDX+:32];
        // wire [31:0] state_c = state_mid[CIDX+:32];
        // wire [31:0] state_d = state_mid[DIDX+:32];
        // wire [31:0] state_e = state_mid[EIDX+:32];
        // wire [31:0] state_f = state_mid[FIDX+:32];
        // wire [31:0] state_g = state_mid[GIDX+:32];
        // wire [31:0] state_h = state_mid[HIDX+:32];
        // wire [31:0] msg_temp0 = msg0[MIDX+:32];
        // wire [31:0] msg_temp1 = msg[MIDX+:32];
        // SS1/SS2
        wire [31:0] a_temp = {
            state_mid[AIDX+:20],
            state_mid[AIDX+20+:12]
        };
        wire [31:0] add1_temp = a_temp + state_mid[EIDX+:32];
        wire [31:0] add2_temp = add1_temp + t_rot[TIDX+:32];
        wire [31:0] ss1 = {
            add2_temp[0+:25],
            add2_temp[25+:7]
        };
        wire [31:0] ss2 = ss1 ^ a_temp;
        // TT1/TT2
        wire [31:0] ff, gg;
        if (index < 16) begin: gen_tt_lower
            assign ff = state_mid[AIDX+:32] ^ state_mid[BIDX+:32] ^ state_mid[CIDX+:32];
            assign gg = state_mid[EIDX+:32] ^ state_mid[FIDX+:32] ^ state_mid[GIDX+:32];
        end else begin: gen_tt_upper
            assign ff = (state_mid[AIDX+:32] & state_mid[BIDX+:32])
                                | (state_mid[AIDX+:32] & state_mid[CIDX+:32])
                                | (state_mid[BIDX+:32] & state_mid[CIDX+:32]);
            assign gg = (state_mid[EIDX+:32] & state_mid[FIDX+:32])
                                | ((~state_mid[EIDX+:32]) & state_mid[GIDX+:32]);
        end
        wire [31:0] add11_temp = ff + state_mid[DIDX+:32];
        wire [31:0] add12_temp = add11_temp + ss2;
        wire [31:0] tt1 = add12_temp + msg0[MIDX+:32];
        wire [31:0] add21_temp = gg + state_mid[HIDX+:32];
        wire [31:0] add22_temp = add21_temp + ss1;
        wire [31:0] tt2 = add22_temp + msg[MIDX+:32];
        // update state
        assign state_mid[DIDX+256+:32] = state_mid[CIDX+:32];
        assign state_mid[CIDX+256+:32] = {state_mid[BIDX+:23], state_mid[BIDX+23+:9]};
        assign state_mid[BIDX+256+:32] = state_mid[AIDX+:32];
        assign state_mid[AIDX+256+:32] = tt1;
        assign state_mid[HIDX+256+:32] = state_mid[GIDX+:32];
        assign state_mid[GIDX+256+:32] = {state_mid[FIDX+:13], state_mid[FIDX+13+:19]};
        assign state_mid[FIDX+256+:32] = state_mid[EIDX+:32];
        assign state_mid[EIDX+256+:32] = tt2 ^ {
            tt2[0+:23],
            tt2[23+:9]
        } ^ {
            tt2[0+:15],
            tt2[15+:17]
        };
    end
endgenerate

assign state_res = state_init ^ state_mid[256*64+:256];

endmodule
