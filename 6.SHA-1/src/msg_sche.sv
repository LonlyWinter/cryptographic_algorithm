
module msg_sche (
    input [511:0] data,
    output [2559:0] msg
);

genvar index;
generate
    // w0 - w15
    for (index = 1; index <= 16; index = index + 1) begin: gen_word_a
        localparam int IDX0 = (index - 1) * 32;
        localparam int IDX1 = 512 - index * 32;
        assign msg[IDX0+:32] = data[IDX1+:32];
    end
    for (index = 16; index < 80; index = index + 1) begin: gen_word_b
        localparam int IDX0 = index * 32;
        localparam int IDX1 = (index - 3)* 32;
        localparam int IDX2 = (index - 8)* 32;
        localparam int IDX3 = (index - 14)* 32;
        localparam int IDX4 = (index - 16)* 32;
        wire [31:0] word_temp = msg[IDX1+:32] ^ msg[IDX2+:32] ^ msg[IDX3+:32] ^ msg[IDX4+:32];
        assign msg[IDX0+:32] = {word_temp[30:0], word_temp[31]};
    end
endgenerate


endmodule
