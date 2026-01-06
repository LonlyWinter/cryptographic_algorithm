
module msg_expand (
    input [511:0] data,
    output [2175:0] msg,
    output [2047:0] msg0
);

genvar index;
generate
    // 0 - 15
    for (index = 0; index < 16; index = index + 1) begin: gen_word_a
        localparam int IDX0 = index * 32;
        localparam int IDX1 = 480 - index * 32;
        assign msg[IDX0+:32] = data[IDX1+:32];
        // debug
        wire [31:0] msg_now = msg[IDX0+:32];
    end
    // 16-67
    for (index = 16; index < 68; index = index + 1) begin: gen_word_b
        localparam int IDX0 = index * 32;
        localparam int IDX1 = (index - 16) * 32;
        localparam int IDX2 = (index - 9) * 32;
        localparam int IDX3 = (index - 3) * 32;
        localparam int IDX4 = (index - 13) * 32;
        localparam int IDX5 = (index - 6) * 32;
        wire [31:0] p_inp = msg[IDX1+:32] ^ msg[IDX2+:32] ^ {
            msg[IDX3+:17],
            msg[IDX3+17+:15]
        };
        wire [31:0] p_opt = p_inp ^ {
            p_inp[0+:17],
            p_inp[17+:15]
        } ^ {
            p_inp[0+:9],
            p_inp[9+:23]
        };
        assign msg[IDX0+:32] = p_opt ^ {
            msg[IDX4+:25],
            msg[IDX4+25+:7]
        } ^ msg[IDX5+:32];
        // // debug
        // wire [31:0] msg_last = msg[IDX0-32+:32];
        // wire [31:0] msg_now = msg[IDX0+:32];
        // wire [31:0] msg1 = msg[IDX1+:32];
        // wire [31:0] msg2 = msg[IDX2+:32];
        // wire [31:0] msg3 = msg[IDX3+:32];
        // wire [31:0] msg4 = msg[IDX4+:32];
        // wire [31:0] msg5 = msg[IDX5+:32];
    end
    // 0-63
    for (index = 0; index < 64; index = index + 1) begin: gen_word_c
        localparam int IDX0 = index * 32;
        localparam int IDX1 = (index + 4)* 32;
        assign msg0[IDX0+:32] = msg[IDX0+:32] ^ msg[IDX1+:32];
    end
endgenerate


endmodule
