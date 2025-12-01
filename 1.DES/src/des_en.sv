
module des_en (
    // 数据
    input [63:0] data_in,
    // 密钥
    input [63:0] key,
    // 计算结果
    output [63:0] data_out
);

wire [767:0] keys_now;
wire [1087:0] data_mid;

ip #(
    .EN(1'b1)
) ip_inst1 (
    .data_in(data_in),
    .data_out(data_mid[63:0])
);

key_schedule keys_inst (
    .data_in(key),
    .data_out(keys_now)
);

genvar index;
generate
    for (index = 0; index < 16; index = index + 1) begin: gen_feistel
        feistel feistel_inst (
            .data_in(data_mid[index*64+:64]),
            .key(keys_now[index*48+:48]),
            .data_out(data_mid[index*64+64+:64])
        );
    end
endgenerate

ip #(
    .EN(1'b0)
) ip_inst2 (
    .data_in({data_mid[1055:1024], data_mid[1087:1056]}),
    .data_out(data_out)
);


endmodule
