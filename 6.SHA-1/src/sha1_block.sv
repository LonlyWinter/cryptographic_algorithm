
module sha1_block (
    input [511:0] data,
    input [159:0] sha_init,
    output [159:0] sha_res
);


wire [2559:0] msg;
msg_sche msg_inst (
    .data(data),
    .msg(msg)
);

wire [127:0] k = {
    32'h5A827999,
    32'h6ED9EBA1,
    32'h8F1BBCDC,
    32'hCA62C1D6
};

wire [159:0] data_mid[81];
assign data_mid[0] = sha_init;

genvar index;
generate
    for (index = 0; index < 80; index = index + 1) begin: gen_loop
        localparam int LOOPIDX = index / 20;
        localparam int KIDX = 96 - LOOPIDX * 32;
        localparam int WIDX = index * 32;
        wire [31:0] a_temp = data_mid[index][128+:32];
        wire [31:0] b_temp = data_mid[index][96+:32];
        wire [31:0] c_temp = data_mid[index][64+:32];
        wire [31:0] d_temp = data_mid[index][32+:32];
        wire [31:0] e_temp = data_mid[index][0+:32];
        wire [31:0] k_temp = k[KIDX+:32];
        wire [31:0] w_temp = msg[WIDX+:32];
        wire [31:0] f_temp;
        wire [5:0] idx_temp = LOOPIDX;
        if (LOOPIDX == 0) begin: gen_loop0
            assign f_temp = (b_temp & c_temp) | ((~b_temp) & d_temp);
        end else if (LOOPIDX == 1) begin: gen_loop1
            assign f_temp = b_temp ^ c_temp ^ d_temp;
        end else if (LOOPIDX == 2) begin: gen_loop2
            assign f_temp = (b_temp & c_temp) | (b_temp & d_temp) | (c_temp & d_temp);
        end else begin: gen_loop3
            assign f_temp = b_temp ^ c_temp ^ d_temp;
        end
        wire [31:0] add1_temp = {a_temp[26:0], a_temp[31:27]} + f_temp;
        wire [31:0] add2_temp = add1_temp + e_temp;
        wire [31:0] add3_temp = add2_temp + k_temp;
        wire [31:0] temp = add3_temp + w_temp;

        assign data_mid[index+1][128+:32] = temp;
        assign data_mid[index+1][96+:32] = a_temp;
        assign data_mid[index+1][64+:32] = {b_temp[1:0], b_temp[31:2]};
        assign data_mid[index+1][32+:32] = c_temp;
        assign data_mid[index+1][0+:32] = d_temp;
    end
    for (index = 0; index < 5; index = index + 1) begin: gen_res
        localparam int IDX = index * 32;
        assign sha_res[IDX+:32] = data_mid[80][IDX+:32] + data_mid[0][IDX+:32];
    end
endgenerate

endmodule
