
module sha1 #(
    parameter int NUM = 1
) (
    input [DI:0] data,
    output [159:0] sha_res
);

localparam int DI = NUM * 512 - 1;
localparam int MI = NUM * 160 + 160 - 1;

wire [MI:0] data_mid;

assign data_mid[159:0] = {
    32'h67452301,
    32'hEFCDAB89,
    32'h98BADCFE,
    32'h10325476,
    32'hC3D2E1F0
};

genvar index;
generate
    for (index = 0; index < NUM; index = index + 1) begin: gen_block
        localparam int IDX0 = (NUM - index - 1) * 512;
        localparam int IDX1 = index * 160;
        sha1_block block_inst (
            .data(data[IDX0+:512]),
            .sha_init(data_mid[IDX1+:160]),
            .sha_res(data_mid[IDX1+160+:160])
        );
    end
endgenerate

assign sha_res = data_mid[NUM*160+:160];

endmodule
